# First IMU connection over I2C

Date: 2026 01 08

## Context

With the modules responding reliably, the next step was to connect the first inertial sensor and try to read data from it.

The focus was on basic communication rather than correctness or calibration.

## What I did

I connected the sensor over I2C and worked through getting the address and bus configuration correct.

Once communication was established, I started reading raw values and checking whether they changed in response to movement.

After that was working with one sensor, I experimented with connecting a second sensor to the same processor to see how that behaved on the bus.

## What didn’t work smoothly

Getting the address and bus setup right took longer than expected.

Adding a second sensor introduced more uncertainty, and it was not always obvious whether problems were wiring related or configuration related.

I spent a lot of time simplifying tests and checking one thing at a time.

## Observations

Small mistakes on shared buses can look like bigger problems than they are.

Verifying each sensor independently before combining them felt essential.

## Next session

Once sensor communication feels stable enough, start looking at moving larger amounts of data off the device.
