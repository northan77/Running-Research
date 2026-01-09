# USB streaming and physical setup

Date: 2026 01 09

## Context

With basic sensor communication working, this session was about getting more visibility into the data and making the setup easier to handle physically.

This ended up covering more ground than expected.

## What I worked on

I focused on streaming sensor data over USB so it could be inspected more easily during testing.

This involved sending larger blocks of data and checking that updates stayed in sync with movement.

Alongside that, I added a battery and put together a rough physical enclosure using a simple 3D print so the setup could be moved around more realistically.

## What was messy

Streaming exposed issues that were not obvious with very small tests.

Some data arrived out of order or inconsistently, and it was not always clear whether the issue was timing, buffering, or something else.

The physical setup was also very rough, with wires everywhere and lots of temporary fixes.

## Observations

Better visibility makes problems more obvious, but not necessarily easier to diagnose.

Having a basic enclosure, even an ugly one, made testing movement much more practical.

## Next session

Try sending data wirelessly and see how it behaves when the device is no longer tethered.
