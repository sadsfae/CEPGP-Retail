# Classic EPGP
**Do not redistribute this addon. Post a link to this github page instead**

**IMPORTANT: Version 1.12.0 contains major changes to the addon which will render previous versions incompatible. If your guild uses CEPGP, please ensure that all of your members update their addon to the latest version.**

CEPGP Support Discord: https://discord.gg/7mG4GAr

An addon designed to handle your guild's EPGP standings by storing the respective values in your Officer Notes. Another primary function of the addon is to handle loot moderation which you must be the master looter to utilise.

For this addon to work, anyone using the addon must be able to at the very least view Officer Notes. To adjust EP and GP values you must be able to edit Officer Notes.

The addon is entirely GUI based and the frame is designed to only appear automatically on raid bosses.

Functionality:
* Either /cepgp or /cep can be used
* show - Shows the cepgp window
* version - Allows you to check if each raid member is running the addon - and if so, what version of the addon they are using

**Note: cepgp is a context sensitive addon and elements will be visible when they are relevent**

Any function that involves modifying EPGP standings requires you to be able to edit officer notes to have it available to you.

The following commands can be used to get EPGP reports.

**The player you whisper must be able to at least view officer notes**
* /w player !info - Gets your current EPGP standings
* /w player !infoguild - Gets your current EPGP standings and PR rank within your guild
* /w player !inforaid - Gets your current EPGP standings and PR rank within the raid
* /w player !infoclass - Gets your current EPGP standing	s and PR rank among your class within the raid

Definitions:
* EP: Effort points. Points gained from what ever criteria.
* GP: Gear points. Points gained from being awarded gear.
* PR: Priority. Calculated by EP / GP.
* Decay: Reduces the EP and GP of every guild member by a given percent.
* Initial/Minimum GP: The GP that all new guild members start at. This also defines the minimum amount of GP any guild member can have.

* Standby EP: EP awarded to guild members that are not in the raid.
* Standby EP Percent: The percent of standard EP allocation should awarded to standby members.

To install:
  1. Download this addon 
  2. Extract it to ../Interface/AddOns/ 
  3. Rename the extracted folder from cepgp-retail-master to CEPGP (Ensure that the folder name is in FULL CAPITALS)

Author: Alumian
