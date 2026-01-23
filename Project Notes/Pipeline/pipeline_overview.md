# Pipeline Overview (Stages)

## Purpose

This document describes the end to end pipeline from run capture through to derived outputs and validation plots.

It is written as a stable reference for future comparison and continuity.
It intentionally avoids algorithm detail and mathematics.

---

## Stage 1: Pod capture (raw truth)

### Goal
Capture raw IMU motion data during a run.

### What happens
- sensor pods stream inertial data
- the logger records the streams as raw run data
- minimal metadata is recorded to preserve provenance

### Output concept
Raw pod level capture.
This is the upstream truth source for the entire pipeline.

---

## Stage 2: Ingest (create the run)

### Goal
Convert the captured run into a standard run folder on the analysis machine.

### What happens
- pull or copy the run off the logger
- validate required inputs exist
- create a stable run folder layout
- write manifest style metadata for traceability

### Output concept
A reproducible run folder that can be processed repeatedly without guesswork.

---

## Stage 3: Process (foundation transform steps)

### Goal
Turn raw pod streams into analysis ready signals through deterministic steps.

### What happens
This stage runs a sequence of processing steps which typically include:

#### 3.1 Align
- align pod streams to a shared time base
- resolve offsets and timing differences
- produce aligned signals suitable for comparison

#### 3.2 Filter and conditioning
- generate filtered versions of key channels
- keep raw and filtered channels traceable
- prepare signals for event detection and visual inspection

#### 3.3 Analysis pipeline preparation
- prepare downstream inputs
- produce any intermediate artefacts needed for analysis stages

### Output concept
Processed analysis ready signals.
This is the core contract used by all downstream derived stages.

---

## Stage 4: Derived (events, strides, segments, features)

### Goal
Create leg level truth artefacts that represent interpretation of the motion signals.

### What happens
Derived outputs are generated from the processed signals, typically including:

- event detection (foot strikes, toe off candidates)
- stride building (stride tables and gait cycles)
- segmentation (stable cadence blocks or regime changes)
- stride level features and summary stats

### Output concept
Derived tables that enable analysis, comparison, and trend detection.

Important note:
Derived outputs must remain inspectable, not treated as automatic truth.

---

## Stage 5: Present (validation and plots)

### Goal
Generate the visual truth tools and run level plots used to validate the pipeline.

### What happens
- create interactive plots for event and stride validation
- generate scatter plots and summary charts
- output run level plot stats tables
- write completion markers so the stage is idempotent

### Output concept
Human validation artefacts.
This stage is what prevents the pipeline becoming a house of cards.

---

## Stage 6: Summary (run level rollups)

### Goal
Produce lightweight run level summaries for quick inspection and downstream dashboards.

### What happens
- create summary JSON outputs
- confidence summaries
- QC rollups
- metadata consolidation

### Output concept
Small summary artefacts that give fast visibility into run quality and results.

---

## Stage 7: Orchestrate (automation wrapper)

### Goal
Provide an automated wrapper that runs the stages consistently and records what happened.

### What happens
- calls pull, ingest, process, present in the correct order
- records logs and results
- supports repeatable end to end execution

### Output concept
Operational traceability.
Orchestration is the system glue that ensures repeatability.

---

## Trust model

A simple rule:

- capture and ingest produce data truth
- process transforms data into analysis ready truth
- derived stages create interpretation artefacts
- present proves whether interpretation is believable

Trust must be earned stage by stage.
Do not build downstream conclusions on an upstream output that has not been validated.

---
