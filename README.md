# splinePainter
An interactive painting program that allows you to paint with the mouse using different brushes and patterns.

The painter creates bezier splines whose direction, position and length follow the mouse pointer’s position and speed when dragged. These curves are then slowly drawn from beginning to end using randomised combinations of brushes and circular symmetry. Each single mouse drag action creates many splines. Each spline will play a single harp note at some time during its ‘walk’. For each new mouse drag the pitch of all the harp notes is shifted randomly.

Right clicking the mouse clears the canvas and selects a new random combination of brush and symmetry. Middle clicking also changes the colour combination.

[See a video of it in action](https://vimeo.com/100034793)
