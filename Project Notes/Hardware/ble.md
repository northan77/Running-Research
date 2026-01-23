# BLE Central Logger (Equipment)

## Purpose

The BLE Central Logger is the capture device responsible for collecting sensor data from multiple IMU pods over Bluetooth Low Energy (BLE) and storing it locally as a complete run.

It is designed to be simple, robust, and field usable.
The logger prioritises reliable capture, clear run folder structure, and deterministic outputs over advanced processing.

This document describes the logger at a system level without implementation detail.



<img src="../images/WhatsApp Image 2026-01-23 at 12.30.33 AM.jpeg" alt="WhatsApp Image 2026-01-23 at 12.30.33 AM" style="zoom:25%;" />

<img src="../images/WhatsApp Image 2026-01-23 at 12.30.34 AM.jpeg" alt="WhatsApp Image 2026-01-23 at 12.30.34 AM" style="zoom:25%;" />

---

## What the logger does

At a high level, the logger performs these responsibilities:

1. Discover and connect to multiple BLE sensor pods
2. Start and stop recording
3. Receive timestamped sensor samples from each pod
4. Write the raw data to a run folder on local storage
5. Maintain run state and produce minimal metadata
6. Provide user feedback through simple physical UI (buttons and LEDs)

The logger does not attempt to perform analysis.
It is a capture appliance.

---

## Physical interface

The logger is intended to be operated without a screen.

Typical physical interface:

- Button input used to start and stop recording
- LED status patterns used to communicate state and error conditions

The specific LED patterns are less important than the principle:
the user must be able to determine the current state quickly and reliably.

---

## Connection model

The logger acts as the BLE Central device.

### Pod connectivity
- The sensor pods act as BLE peripherals
- The logger connects to a fixed set of known pods
- Pods are typically assigned functional roles (for example thigh or calf)

### Expected behaviour
- Connect to all required pods before starting capture
- Identify each pod reliably (by name, address, or configured identity mapping)
- Detect and handle connection dropouts
- Ensure the run output is still well formed even if a pod disconnects mid run

---

## Run lifecycle

The logger is built around a simple run lifecycle:

### 1. Idle
No active connections or capture.
Waiting for user action.

### 2. Connect
Connect to pods.
Confirm expected pods are present and responsive.

### 3. Armed
Connected and ready.
Waiting for start command.

### 4. Recording
Data is streaming from pods.
Logger writes streams to disk continuously.

### 5. Stop and finalise
Recording stops.
Logger flushes buffers and writes end of run metadata.
Run folder is marked complete.

### 6. Error state (optional)
If a failure occurs that threatens integrity, the logger enters a visible error state and writes error metadata where possible.

---

## Data captured

Each IMU pod typically provides at minimum:

- accelerometer samples
- gyroscope samples
- timestamps or sequence numbers

The logger writes the streams without attempting to interpret them.

Key capture goals:
- preserve time order
- preserve completeness
- preserve provenance (what pod produced what stream)

---

## Output structure (run folder)

Each recording produces a single run folder, stored locally on the logger.

Example:
`runs_pi/<run_id>/`

Typical contents:

- raw per pod stream files (CSV or equivalent)
- small metadata files describing the run and pod mapping
- log file with status and any warnings

The logger output must be stable and deterministic so it can be pulled to an analysis machine later.

---

## Metadata written by the logger

Minimum metadata needed for reproducibility:

- run identifier
- start and stop times
- list of pods involved
- pod mapping information (for example which pod was on which limb segment)
- firmware or version information where possible
- any warnings such as disconnects or packet loss indicators

This metadata is intended to support traceability, not analysis.

---

## Relationship to downstream pipeline

The logger is upstream of all analysis stages.

Downstream stages assume:
- the run folder exists
- raw pod streams are complete and time ordered
- the logger metadata correctly describes the run

Downstream stages perform:
- ingestion into the canonical run structure on the analysis machine
- alignment across pods
- filtering and channel creation
- event detection and stride segmentation
- plots and validation tools

The logger must remain stable even while downstream algorithms evolve.

---

## Design principles

The logger follows these core principles:

- Capture first, analyse later
- Deterministic artefacts
- Simple user operation
- Robust handling of disconnects
- Write everything needed to reproduce the run later
- Do not hide errors
- Leave truth artefacts behind

---

## Known limitations

This stage intentionally does not include:
- biomechanical logic
- filtering or feature extraction
- stride segmentation
- cloud sync or app integration

Those belong in later stages and should not compromise the capture appliance behaviour.

---
