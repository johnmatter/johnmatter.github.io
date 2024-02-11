---
title: big arduino volume knob
tags: arduino maxmsp
---

A few months ago I bought a used
[MOTU UltraLite mk3 Hybrid](https://motu.com/products/motuaudio/ultralite-mk3),
the oldest model of this interface that still works with Apple Silicon.
It has 2 preamp inputs, 6 analog inputs, 8 analog outputs, 24-bit 192 kHz
sampling. Very cool for very cheap. It has a lot of DSP bells and whistles that
I probably won't use, but I wanted something I with a few inputs for
mics/synths, and could maybe send audio from Max or Ableton to a few cheap
speakers/amplifiers for performances.

The monitor level knob on the front is fairly small and it sits in the corner
of my office, where it isn't particularly easy to reach while working.
MOTU's software
[CueMix FX](https://motu.com/products/motuaudio/ultralite-mk3/cuemix-fx-overview.html)
allows control over USB of a zillion mix parameters including EQ, reverb,
send/return loops, and (fortunately for me) monitor level, but the monitor level
knob in the GUI is also small. 

{% include image.html filename="cuemix.png" max-width="1000" %}

I found a
[2014 blog post](https://www.pongasoft.com/blog/yan/music/2014/04/24/how-to-control-CueMixFX-volume-with-MIDI)
by Yan Pujante[^1] explaining how to control monitor level in CueMix using MIDI/OSC.
His solution uses [osculator](https://osculator.net), a paid application for
routing MIDI and OSC messages between other software and hardware.
I'm relatively frugal, so I wanted to create my own solution instead of buying
another piece of software.

I built a first draft of a Max patch using MIDI CC from a
[16n faderbank](https://16n-faderbank.github.io) to control volume.
It worked well enough, but I wanted to have a self-contained single knob/slider
to control monitor level.
I decided to try putting together a little Arduino project with an encoder.
I found [another post](https://lastminuteengineers.com/rotary-encoder-arduino-tutorial/)
with code I could use for my purposes.
The encoder increments/decrements an integer counter in the arduino, which it sends
over serial.
Max converts that to a float between 0 and 1, and sends that to CueMix over
OSC.
The push button on the encoder mutes audio until you turn the knob again.
It would be nice to handle all the OSC in the Arduino code without some Max
middleware, but I couldn't figure it out this afternoon so this solution will
work for now.

Parts were about $30 and an osculator license is $24. So much for being frugal.


{% include image.html filename="arduino.jpeg" %}

{% include image.html filename="max_patch.png" %}


{% highlight bash %}
----------begin_max5_patcher----------
1263.3ocuX88haiCD94j+JDl6wsdkjsjrN5CEJbbObk9vcENnTBNIpacqskw
Vda5U5+6m9gc1jcU13MQIDvAIKqY9lY9FMZ947YQKkaDcQfeG7QvrY+b9rY1
oLSLaX7rnp7MqJy6rKKZYuRIqitw8ph01IkK+5qHiy0j2lWITh1Eh57kkByJ
fCuqtupntTnr6E5gIk8pGOaStZ0WJpuaQqXkxogoLVL7F.BihSwoPLJKIClj
RXra.3TyqLOAeZXGbap5GMB2mGsLu9tHvmLu8WymadbyDQcs36ZLNhPkXiUi
hJk4qqDcc.jGCRRVTPPMACMPKw9jYehwOGLCJDK9L32JPfWqs5Y.0WD01ghx
NA.5CzrfBZLBGSobJmyvLHV6p4Z+eJ+RYDVWjWtMNtUzIpU4pBY8NZlN3yDC
Rrp.Au8uspxtVC5ISJ1U5mjEjwsjEN9fJ5SrYeVGOqBZzSSaQsB7lFYSeiWR
BJ8EDu.OLZQYVzllX8KbzCAHm.XLT576D9QiOP3moiewA8NmERq36leiBIZ5
O9JS76DsZx.XIfSg9X5XzKvygOJSGQYwjTZFExxzgobBMQmsicbPacIAF6Zl
ZqDjj3C13.4qGf8i701yxHziC6S+rLk7t6JE9fVxk+H7AXyHwZjqgLOMMkmx
yl3I3FmcHczsfU8hphMKJZVjWudQir0KAOwqSG9RQOEybGkii4HRBiQQTHJk
RolHgzqMCehfGGlTzoo6jgFgomUJ5iUP1BY2p3E8qa7AnvThhCOtxxPH9U14
8ehVYrtFAY4893xHZHAYJzdfJ6hEgdnSbucs39ag5eURcgmdKf.Ez7wOgZB0
EbxIWYm6sZ9AK1CZoAErXBKlwwjjLJCQPbMr0VfIDIG9BE0LUc4tqAHcIPHZ
VLJFwS.jLBL02sLBSFoQedZVLLICinDcoVPcoGYZFMCcIRPYosKakeuyKqkG
FVqS2QHKekQuTQu8Uh5dOvfEn5HRNLB4IN1J2cYL3zqSzUq3nRqDUNr7t2+O
e.7gRUa9eomDT8sDve9iksEqAusW7thMf+3eAu+ueKPmGpJWoZWJkeqoU9pJ
bzIX4L6PeguHfS21Y1SWAdFPeZI5GZu.7hkv6f.GSNefWq+tWLvGhjb8THAd
s6uh9d9MlDe4Ml+7YXBSJAGLwDalAN8Z2EIs6zC13AEaH2eYWYroz2QtDrpT
j6ChHXTPR3MjR2koilLwKHNjvyob6AZ6GFUVT+31+ZksY98sDcx91Ui68Xus
.OH+0hNUQ811U8ws0qryZpJV2H04gGjXFjFa5rg65trLGQbuQC8shf4lUNz9
Juttop17In0X2ZNK4nyiCPGSNj.Hno3FLEIe1BhLEKWHDjow4GWRIgPRrIHo
jmMHdLzLcuv18FwrGsLDsaFblZMdJdBDM.1mQi7y6IBAcYbSt7QWiaxy6yYg
PRSPPgPNnojSybNz4KorqkWBMEl4i.trcsvVHH7JHZpeQiNOQOoj4oWDTOIQ
iuHndJYYBQ5dD5ZIH3DN8mGJAMwbLGpHL6wWYtKRCwaGEBMCeNZlog3ZkAwc
MjBZOKc+QW.0dJrfmlz1UMs9Nb2KZ6FVsUF5aP7UokijcicXQsaH0NrUbew3
5s2wMJuUW4uRW1eeqUuh1Pcc.KpRpYa05KO6HbZzoEo81Il6810j6.h8RLy+
07+2UJrqr
-----------end_max5_patcher-----------
{% endhighlight %}

{% highlight c++ linenos %}
#define SW 2
#define DT 3
#define CLK 4

int counter = 0;
int counterIncrement = 5;
int currentStateCLK;
int lastStateCLK;
unsigned long lastButtonPress = 0;

void setup() {
    pinMode(CLK, INPUT);
    pinMode(DT, INPUT);
    pinMode(SW, INPUT_PULLUP);
    Serial.begin(9600);
    lastStateCLK = digitalRead(CLK);
}

void loop() {   
    currentStateCLK = digitalRead(CLK);
    
    if (currentStateCLK != lastStateCLK  && currentStateCLK == 1){
        if (digitalRead(DT) != currentStateCLK) {
            counter += counterIncrement;
        } else {
            counter -= counterIncrement;
        }
        counter = constrain(counter, 0, 127);
        Serial.write(counter);
    }

    lastStateCLK = currentStateCLK;

    int btnState = digitalRead(SW);
    if (btnState == LOW) {
        if (millis() - lastButtonPress > 50) {
            Serial.write(255);
        }
        lastButtonPress = millis();
    }
    delay(1);
}
{% endhighlight %}

## Footnotes
[^1]: Apparently a cofounder of LinkedIn.
