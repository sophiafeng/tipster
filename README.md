# Tipster

Tipster is a tip calculator application for iOS.

Submitted by: Sophia Feng

Time spent: 12 hours

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [ ] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

* [x] Custom segment control with animations
* [x] Split bill information
* [x] App color changes based on tip percent selection

## Video Walkthrough 

Here's a walkthrough of implemented user stories:
<img src='http://imgur.com/KqVjdnG.gif' title='Tipster Walkthrough' width='' alt='Tipster Walkthrough' />

Here's a walkthrough demoing <10 min state restoration. Since this was done in simulator, I first background the app and then killed it in Xcode's Stop button, then open the app again. 
<img src='http://imgur.com/AaS2M4B.gif' title='State restorationg within 10 min demo' width='' alt='State restorationg within 10 min demo' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I spent the most time on state restoration. I took some time to understand methods in the AppDelegate and the order at which they were called. I had read about how to enabled state restoration but ran into a bug where even though I added restoration identifiers the encode/decode methods weren't being called.

## License

    Copyright 2016 Sophia Feng

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
