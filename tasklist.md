# Tasks

These are in order of priority for the first milestone, split into the different section responsibilities.

*Spectrogram*
- [ ] Fixed bin number implementation
- [ ] Multiple rows
- [ ] Stem stacking / colour differenciation
- [ ] Colour addative from freeform angles
- [ ] Verticle stacking, snapped to sideview
- [ ] Bin expansion / dynamic vertices for changable resolution

*UI / Camera Movement*
- [ ] Play / stop button
- [ ] Resolution pow-2 slider (basically, number of bins)
- [ ] Time value: init 3 sec
- [ ] Number of samples: init 2048
- [ ] frequency multiplier / max freq height slider / integer / whatever
- [ ] Stem Controls:
  - [ ] Checkbox to enable / disable distringuishing stem
  - [ ] Slider for stem contribution (amplitude)

*Music*
- [X] Play music stems in music player nodes
- [X] Multiple players at the same time, is it possible? Otherwise, some shenanigans will be required
- [ ] Look into making number of bins a global variable (can we change it on the fly and do we want to?)
- [ ] Signals between music players and script
  - [ ] Work with the UI to mute stems
- [ ] Add buses that combine the stems for display
  - Front bus will have one stem
  - Second stem will have first bus and another stem, etc.
- [ ] Functions with parameters (num secs, freq bins / num bins)
- [ ] Maybe analyze the demo code and refactor for more meaningful

*Bonus:*
- [ ] Camera Controls:
  - [ ] Arrow keys to change between snap positions
  - [ ] Freeform control
- [ ] memory (saved last config)
