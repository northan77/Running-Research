# IMU Sensor Pods (Equipment)

## Purpose

The IMU Sensor Pods are wearable motion sensors used to capture lower limb movement during running.
They stream timestamped inertial measurements to the BLE Central Logger for storage as raw run data.

The pods are designed to be small, lightweight, and practical for repeated use.
They prioritise consistent data capture and stable behaviour over onboard analytics.

This document describes the pods at a system level without implementation detail.

| <img src="../images/WhatsApp Image 2026-01-23 at 12.46.38 AM.jpeg" alt="WhatsApp Image 2026-01-23 at 12.46.38 AM" style="zoom:25%;" /> | <img src="../images/WhatsApp Image 2026-01-23 at 12.46.38b AM.jpeg" alt="WhatsApp Image 2026-01-23 at 12.46.38b AM" style="zoom:25%;" /> |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="../images/WhatsApp Image 2026-01-23 at 12.46.38c AM.jpeg" alt="WhatsApp Image 2026-01-23 at 12.46.38c AM" style="zoom:25%;" /> | <img src="../images/WhatsApp Image 2026-01-23 at 12.46.38d AM.jpeg" alt="WhatsApp Image 2026-01-23 at 12.46.38d AM" style="zoom:25%;" /> |
| <img src="../images/WhatsApp Image 2026-01-23 at 12.46.38e AM.jpeg" alt="WhatsApp Image 2026-01-23 at 12.46.38e AM" style="zoom:25%;" /> | <img src="../images/WhatsApp Image 2026-01-23 at 12.46.38f AM.jpeg" alt="WhatsApp Image 2026-01-23 at 12.46.38f AM" style="zoom:25%;" /> |



---

## What the pods do

At a high level, each pod performs these responsibilities:

1. Measure motion using an inertial sensor (accelerometer and gyroscope)
2. Package measurements into a timestamped sample stream
3. Stream the data to the BLE Central Logger over BLE
4. Maintain stable behaviour throughout a run (no pauses, no drift in behaviour)
5. Provide identity information so the logger can distinguish pods reliably

The pods do not perform gait detection or stride processing.
They act as measurement instruments only.

---

## Typical configuration

The system is typically used with multiple pods at the same time.

Common configuration:
- 2 pods per leg
- 1 pod mounted on the thigh
- 1 pod mounted on the calf

The full system therefore captures:
- left thigh
- left calf
- right thigh
- right calf

This multi pod layout enables:
- segment orientation and relative motion analysis
- event detection using both local and cross segment signals
- redundancy and validation across signals

---

## Sensor outputs

Each pod provides motion measurements that typically include:

- accelerometer (3 axis)
- gyroscope (3 axis)

Optional or future outputs may include:
- magnetometer
- temperature
- battery status

The pods stream raw measurements without interpretation.

Key output requirements:
- stable sampling rate
- monotonic timestamping or sequence numbering
- consistent axis mapping
- deterministic formatting

---

## Sampling behaviour

The pods are configured to sample at a fixed rate.
The exact rate is less important than consistency.

Important behaviours:
- do not drop into low power modes during recording
- do not change sampling behaviour mid run
- maintain streaming even during brief BLE link quality changes where possible

Downstream processing assumes the sampling rate is stable.

---

## BLE behaviour

The pods act as BLE peripherals.

Expected behaviour:
- advertising when idle
- connectable by the BLE Central Logger
- stream measurement packets continuously when recording

The pods must expose enough identity information for stable mapping.
This can be by:
- device name
- BLE address
- configured ID

---

## Pod identity and mapping

Each pod must be identifiable in a deterministic way so that data can be assigned to the correct limb segment.

Examples of mapping:
- left thigh pod
- left calf pod
- right thigh pod
- right calf pod

This mapping is fundamental.
If the mapping is incorrect, downstream analysis is invalid regardless of algorithm quality.

The logger stores pod mapping metadata within the run folder so it can be reconstructed later.

---

## Mounting and placement

The pods are mounted directly to the runner, typically using straps, sleeves, or tape.

Key placement principles:
- placement should be repeatable between runs
- pods should be firmly attached to reduce relative motion
- orientation should be consistent to reduce variation in axis alignment

Placement is part of the measurement system.
If placement changes significantly, signal morphology can change even with identical running mechanics.

---

## Battery and runtime considerations

Pods are designed for run duration capture.
Battery requirements depend on:
- sampling rate
- BLE transmit rate
- whether onboard logging is enabled

At minimum, pods must support:
- full duration capture without battery failure
- stable streaming behaviour until the end of the run

Battery level reporting is useful for diagnostics but not required for analysis.

---

## Output expectations and downstream responsibility

The pods provide raw motion data only.
All interpretation occurs downstream.

Downstream stages are responsible for:
- aligning pod streams to a common time base
- filtering and signal conditioning
- gait event detection (foot strike, toe off)
- stride segmentation and feature extraction
- plots and validation tooling

The pods should remain stable even while downstream algorithms evolve.

---

## Design principles

The pods follow these core principles:

- capture truth, do not interpret
- stable sampling behaviour
- deterministic identity and mapping
- practical wearable form factor
- robust streaming under realistic conditions
- do not hide failures

---

## Known limitations

This stage intentionally does not include:
- force or pressure measurement
- direct ground truth for contact timing
- lab grade kinematic tracking

The pods produce inertial proxies only.
Truth validation is performed using downstream inspection tools and repeatable capture protocols.

---
