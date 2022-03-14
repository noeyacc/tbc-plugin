
Simple Interrupt Announce
=========================

Copyright 2011-2021 BeathsCurse (Bowmore - Silvermoon EU)


Introduction
------------

Simple Interrupt Announce (SIA) is a World of Warcraft addon that aims to be
a relatively simple and efficient, yet flexible interrupt announcer. The main
use of such an addon is to help coordinate interrupts in raids.


Settings
--------

SIA stores settings for how to announce interrupts based on your grouping
status. So you can have separate settings for when you are solo, in a party,
or raid.

For each of these three statuses, SIA can announce your own interrupts, and
those of other people/pets in your party/raid.

Announcing is based on modes, which decide what channel the announcement goes
to. They can be: off, self, say, party, and raid.

The default settings are:

    status       own    other
    -------------------------
    solo        self      N/A
    party       self     self
    raid        self     self

So, when you are playing solo, you will get your own interrupts announced to
yourself, and not see others. When in a party or raid, your own interrupts and
other peoples interrupts will be announced to yourself.

Own covers interrupts made by you or your pet, other covers interrupts made
by any player or pet in your party/raid.

SIA can optionally play a sound when announcing. In the configuration panel
you can select one of the default sounds, or you can add your own custom sound
files to Interface/AddOns/SimpleInterruptAnnounce with one of these names:
sound1.mp3, sound2.mp3, sound1.ogg, sound2.ogg.


Slash Commands
--------------

You can enable and disable announcing with

    /sia on
    /sia off

You can use

    /sia <status>

to see what the modes are for that status. And

    /sia <status> [own [other]]

to set the mode for own and other interrupts respectively.

For switching modes in macros, a special compact syntax is supported; an
exclamation mark followed by six characters, two (own and other) for each
of the three statuses. Each character can be: o = off, m = self, s = say,
p = party, r = raid. If a character is not one of these, the corresponding
mode is not changed.

Here are a few examples:

    /sia party         - print current party modes
    /sia solo self     - when solo, own interrupts to yourself
    /sia raid say self - when raid, own to say, others to self
    /sia !mommmm       - set default modes
