---
title: interim solution for tape backup
tags: jlab
---

## Firewall and coronavirus blues
I'm writing this a month or so after I actually figured out a backup system, but I figure it's worth updating where things stand since my [last post]({{ site.baseurl }}{% link _posts/2020-02-18-scheduling-tape-backups.md %}).

It turns out JLab has a firewall that blocks internal traffic, particularly if it's going to the tape storage system.
This means our DAQ PC can't submit `jput` jobs directly.
I spent a few weeks working with the IT folks to try to work around the firewall, but no luck.
Coronavirus put that effort on indefinite hold, so I needed to find a workaround.

If I were to backup a single file manually, I would use `scp` to copy data to the [write-through cache](https://scicomp.jlab.org/docs/write-through-cache) on lab computers like the ifarm interactive nodes that *are* allowed to access the tape storage system.
Then, from a terminal logged into ifarm, I can submit `jput`.

## Automating the single file case
We currently have 1520 raw data files on the DAQ.
I, personally, would prefer not to manually submit 1520 individual `scp`s and `jput`s.
A naive approach to automating the `scp`/`ssh`/`jput` method I outlined above would be to have a bash script loop over our files and run these commands.
Each time `scp` and `ssh` run, the user would have to enter their password.
I can get around this bottleneck by using a [public key](https://serverpilot.io/docs/how-to-use-ssh-public-key-authentication/).
As far as I can tell, this does not violate any lab security policies.

I can do some clumsy "parallelization" by creating a [screen](https://en.wikipedia.org/wiki/GNU_Screen) session with a few windows, each of which iterates over a list of files to backup.
I'll submit a few dozen files per screen window, and then once they've finished, double check the MD5 hashes[^1], and remove the temporary file I `scp`-ed to `/cache`.
Each batch should take a day or two, depending on how large they are.

## The code
The code for doing this is all on my (github)[https://github.com/johnmatter/eel124gemdaq-backup].
This repo contains a bunch of scripts because I needed different variants of the same basic idea on different days.

We need to get a list of all the files that pertain to a particular run, and then run `backup_from_filelist.sh` on that list.
Here's how I accomplish that:
1. Pipe the output of `get_files_for_run.sh RUNNUMBER` to a text file called listSOMETHING.txt
  * Optional: If a run has dozens of files associated with it, use `split`[^2] to break it into smaller lists. Ideally, you only want 3 or 4 lists so as not to overwhelm the DAQ.
2. Run `./backup_screen_batch.sh`. It will find all files that match `list*.txt` and create a screen window for each list of files
  * Each window runs `backup_from_filelist.sh` for that list.
3. Check on your screen session every several hours by connecting with `screen -x -S SESSION_NAME`. If you don't know the session name, you can use `screen -l`.
4. Once the backups are finished, check the MD5 hashes either by looking at the output in `screen` or by running `check_run_mss_md5sum.sh RUNNUMBER`.

## The future
Things still to be done:
* Backup processed data (rootfiles containing either decoded data or diagnostic histograms), organized by chamber.
* Switch from `screen` to a [`swif`](https://scicomp.jlab.org/docs/swif)-based approach. The firewall issue may preclude this change.

## Footnotes
[^1]: `jput` already checks that the hashes match, but I want to be extra sure they match.
[^2]: For example, you can split a long text file named longlist into files called list01.txt, list02.txt, ... each of which is 10 lines longs with `split -d -a2 -l10 --additional-suffix=.txt "longlist" "list"`.
