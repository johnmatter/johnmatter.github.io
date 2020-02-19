---
title: scheduling tape backups for the SBS GEM test DAQ
---

Since October 2019, we've been taking data with cosmic rays at JLab to test our [GEM](https://arxiv.org/abs/1409.5393) setup for the [SBS](https://hallaweb.jlab.org/12GeV/SuperBigBite/).
We have four layers with four GEMs per layer stacked on top of each other.
Pairs of scintillator paddles sit above and below the GEM layers and provide a trigger signal for the DAQ.
When a cosmic ray passes through one scintillator paddle on top and one on the bottom, the DAQ system digitizes the signals coming from all the GEM detectors.
Each event contains about 500 kB of data[^1].

We observe a rate of ~15 cosmic rays per second passing through our setup.
This means an hour's worth of data would give us a ~500 MB file containing ~1,000 events.
We'd like to record something like 100,000 events per detector to be able to characterize how each of our 48 GEM detectors behaves.
This means a grand total of a few TB of cosmic data.
Even if it were only a few MB, these data are crucial and need to be backup up.
Some detectors have been in storage for several years.
Other have recently been moved from UVA to JLab and could have been damaged in transit.
We need to verify that each one functions properly with cosmic ray tests.
The results of these tests need to be stored for future reference once the GEM setup is moved to Hall A for production running.

We need secure backups in case something catastrophic happens to the DAQ computer.
Reader, something has just happened to the DAQ computer.

## A problem
For as-yet-unknown reasons, the DAQ computer has been freezing once every few days.
Over the weekend it froze and wouldn't boot back up.
I hadn't yet set up a backup system for our raw data.
The JLab IT group is doing what they can to restore the computer without erasing the raw data.
In the meantime, I'm planning for the future and developing our backup system.

## Backing up the data
I'm working on a bash script that will be run once per day as a cron job.
This is what it should do:
1. Check the status of any outstanding `jput` jobs and make note of which files they correspond to.
2. Loop over all the local files
+ If we know a file already has a pending or active job from step 1, move on to the next one.
+ If a metadata stub exists on `/mss`, check the md5 hash.
  - If the hash matches, delete the local file to free up space.
  - If the hash does not match, make note of this and keep the local copy.
+ If no stub exists, run `jput /local/directory/myfile.dat /cache/my/backup/directory`

## Generating mock data
In addition to our computer being out of commission, it seems like the lab's farm servers are down so I'm kind of simulating how things should behave on ifarm.
Since I don't have any real data to work with at the moment, I'm making some dummy data that I can play with while we wait for IT.
I don't need GB size files, so I'm just going to make a bunch of small text files contaning random numbers.
{% highlight bash linenos %}
for run in $(seq 20); do
    for i in $(seq 100); do
        echo $RANDOM >> raw/sbs_$run.dat
    done
done
{% endhighlight %}

The JLab tape storage system provides file "stubs" that contain metadata about cached files.
Here's a stub file for one of runs from our 2018 color transparency experiment.

{% highlight plain %}
bitfileIndex=137024448
sourcePath=/net/cdaq/cdaql3data/coda/data/raw/coin_all_02049.dat
size=11610259456
crc32=245794d3
md5=0011834b5f2fc1848dbc00799f4f3f3c
owner=halldata
creationTime=2018-01-20 05:40:28
bfid=120179753
volser=800175
filePosition=943607
volumeSet=c-spring17-raw
stubPath=/mss/hallc/spring17/raw/coin_all_02049.dat
dup.bitfileIndex=88474873
dup.md5=0011834b5f2fc1848dbc00799f4f3f3c
dup.crc32=245794d3
dup.creationTime=2018-01-20 05:41:37
dup.bfid=72963414
{% endhighlight %}

One useful field here is the md5 hash.
We can use this to double check that each cached file's contents match the local file's.
I'll create some mock stubs for our mock data.

{% highlight bash linenos %}
for file in $(ls raw); do
    echo md5=$(md5sum raw/$file  | awk '{print $1}') > mss/$file
    echo sourcePath=$(pwd)/raw/$file >> mss/$file
done
{% endhighlight %}

{% highlight plain %}
/sbs_fake_data$ cat mss/sbs_3.dat
md5=7fed7d98e455e491e4473cfe14271a47
sourcePath=/sbs_fake_data/raw/sbs_3.dat
{% endhighlight %}

We only want to back up "old" data that isn't being used or written, so I modified 5 of the "raw" files to have modification times from a month ago.

## The script
Here's the first version of the script.
I've commented out all the commands that need to run on ifarm and replaced them with dummy text output.

{% highlight bash linenos %}
#!/usr/bin/env bash

# Where do the raw data live?
# raw_dir=/data/raw
# mss_dir=/cache/halla/sbs/raw/gem/uva
# cache_dir=/mss/halla/sbs/raw/gem/uva

raw_dir=/sbs_fake_data/raw
mss_dir=/sbs_fake_data/mss
cache_dir=/sbs_fake_data/cache

username=sbs-onl

md5_log=files_with_bad_md5_sums.txt

# ---------------------------
# Check status of jcache requests.
echo Checking any pending jobs for $username.

# We need to save this info for later so that we don't submit duplicate jput jobs.
pending_files=()
# jcache_requests=$(jcache pendingRequest -u $username | grep request: | cut -d : -f 2)
jcache_requests=$(cat request_get_multiple_pending | grep request: | cut -d : -f 2)

for request_id in ${jcache_requests}; do
    # status=$(jcache status $request_id | grep status: | cut -d -: -f 2)
    status=$(cat request_${request_id}_pending | grep status: | cut -d : -f 2)

    # Add filename ('/cache/halla/sbs/etc/etc') to list of pending files
    # filename=$(jcache status $request_id | grep /cache/ | awk -F'->' '{print $1}')
    filename=$(cat request_${request_id}_pending | grep /cache/ | awk -F'->' '{print $1}')
    pending_files+=( $filename )

    echo "request $request_id: status = $status, filename = $filename"
done

# ---------------------------
# Loop over files older than 3 days and check if they should be deleted or cached
files=$(find $raw_dir -mtime +2)
for file in ${files}; do
    bname=$(basename $file)
    stub=$mss_dir/$bname
    cached_file=$cache_dir/$bname

    echo
    echo --------
    echo $bname
    # Check if we already have a pending job
    if [[ " ${pending_files[@]} " =~ " ${cached_file} " ]]; then
        echo "Already has a pending job. We'll continue to wait."

    else
        echo "No pending job exists."

        # If the stub does exist, check the md5 then remove the local copy.
        # If the md5 doesn't match, add it to a log.
        if test -f "$stub"; then
            echo Stub exists so it should have been cached. Checking md5 hash.
            local_md5=$(md5sum $file | awk '{print $1}')
            stub_md5=$(grep md5= $stub | cut -d = -f 2)

            # Check md5
            if [ "$local_md5" = "$stub_md5" ]; then
                echo "md5 sums are equal. Safe to delete local copy."
                echo rm $file
            else
                echo "md5 sums are not equal!"
                echo $file >> $md5_log
            fi
        else

        # If the stub doesn't exist, submit a jput job.
            echo "Stub doesn't exist so we should submit a job."
            echo jput $file $cache_dir
        fi
    fi
done
{% endhighlight %}

### Terminal output

This is what the output of the script looks like in the case that sbs_1.dat and sbs_2.dat already have jobs, sbs_3.dat is already backed up, and the rest of the files are "new" and shouldn't be backed up yet.

{% highlight plain %}
/sbs_fake_data$ ./backup_raw.sh
Checking any pending jobs for sbs-onl.
request 23772028: status =  pending, filename = /sbs_fake_data/cache/sbs_1.dat
request 23772029: status =  pending, filename = /sbs_fake_data/cache/sbs_2.dat

--------
/sbs_fake_data/raw/sbs_1.dat
Already has a pending job. We'll continue to wait.

--------
/sbs_fake_data/raw/sbs_3.dat
No pending job exists.
Stub exists so it should have been cached. Checking md5 hash.
md5 sums are equal. Safe to delete local copy.
rm /sbs_fake_data/raw/sbs_3.dat

--------
/sbs_fake_data/raw/sbs_2.dat
Already has a pending job. We'll continue to wait.

--------
/sbs_fake_data/raw/sbs_5.dat
No pending job exists.
Stub doesn't exist so we should submit a job.
jput /sbs_fake_data/raw/sbs_5.dat /sbs_fake_data/cache

--------
/sbs_fake_data/raw/sbs_4.dat
No pending job exists.
Stub doesn't exist so we should submit a job.
jput /sbs_fake_data/raw/sbs_4.dat /sbs_fake_data/cache
{% endhighlight %}

## Useful links
JLab Scientific Computing's documentation for the Mass Storage System can be found [here](https://scicomp.jlab.org/docs/storage).

## Footnotes
[^1]: Each GEM has about 2,800 individual readout channels. With four layers of four GEMs, that's about 45k channels total. Each channel reports six 25 ns time samples, each of which is a 16-bit word. Multiplying these togethers gives 500 kB.
