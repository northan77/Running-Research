# Stage 2: Ingest (create the run)

## Purpose

Stage 2 takes the raw capture output from Stage 1 and turns it into a reproducible, analysis ready run folder on the analysis machine.

The purpose of ingest is not to process biomechanics.
Its purpose is to make the run:
- relocatable
- repeatable
- traceable
- safe to process automatically

This stage is the boundary between physical capture and the software pipeline.

---

## What happens in this stage

A run captured on the logger is pulled or copied onto the analysis machine, then normalised into a standard run structure.

During ingest the pipeline:
- creates the canonical run folder
- copies raw pod artefacts into expected locations
- validates that required files exist
- records a manifest of what was ingested
- records mapping and provenance information needed downstream
- writes completion markers and logs

Ingest should be deterministic.
The same raw run ingested twice should result in the same canonical run structure.

---

## Inputs

Stage 2 consumes only capture truth and metadata.

Typical inputs:
- raw run folder copied from the logger
- pod capture streams for each device
- capture metadata (pod mapping, start stop times, warning logs)

This stage should not depend on any downstream products.
If later stages fail, ingest should still be valid.

---

## Outputs

The outputs of Stage 2 are a canonical run folder and traceability artefacts.

### Canonical run folder
A run is stored under a standard run identifier, typically a timestamp based ID.

The folder contains:
- raw pod streams (preserved and unchanged)
- ingest metadata and logs
- placeholders or folders for downstream outputs

The structure is designed so future tools can run without needing to discover where inputs live.

### Ingest manifest
A manifest is produced to describe what was ingested.

The manifest typically captures:
- list of pods detected and included
- count of files and sizes
- start and stop times
- mapping information
- software version identifiers
- warnings encountered

The manifest exists so you can later prove what the analysis was based on.

### Completion markers
This stage writes explicit completion markers so it can be used in automated orchestration.

A completed ingest stage should be unambiguous and machine readable.

---

## What this stage does not do

Stage 2 is intentionally limited in scope.

It does not include:
- stream alignment
- filtering
- channel creation
- event detection
- stride building
- any biomechanical interpretation

If Stage 2 starts to include these activities, it becomes harder to validate and maintain.

---

## Why this stage matters

Ingest prevents the pipeline becoming fragile.

Without a strong ingest stage, downstream tools tend to:
- rely on ad hoc file naming
- infer pod mapping from unreliable hints
- depend on manual copying
- fail unpredictably when new run variations appear

Stage 2 eliminates those risks by enforcing:
- stable structure
- traceability
- deterministic inputs

This stage is also where many quality problems should be detected early, such as missing pods or corrupted files.

---

## Design goals

### 1. Preserve raw truth
Raw pod data must not be modified during ingest.
If any transformation is required, it belongs in later processing stages with explicit outputs.

### 2. Make runs reproducible
A run should be a self contained unit that includes:
- raw data
- mapping metadata
- configuration and environment identifiers
- pipeline results as they are generated

### 3. Support automation
Ingest must be reliable enough to be executed unattended as part of an orchestrated workflow.

### 4. Provide traceability
When analysis results change, ingest metadata allows you to determine whether the change came from:
- different input data
- different mapping
- different pipeline version

---

## Quality and validation checks

Stage 2 should perform lightweight checks that prevent wasted processing.

Typical checks include:
- required pod files exist
- expected number of pods present
- file sizes exceed minimum thresholds
- timestamps or sequence counts appear monotonic
- mapping metadata is present and unambiguous

These are not deep correctness checks.
They are sanity checks that ensure the run is processable.

---

## Acceptance criteria

Stage 2 is considered successful when:

- the canonical run folder exists and is complete
- all raw pod artefacts have been copied and preserved unchanged
- pod mapping metadata is present
- an ingest manifest has been written
- completion markers indicate success
- logs capture any warnings clearly

If ingest fails, downstream stages must not run automatically.

---

## Relationship to downstream stages

Stage 2 creates the stable run structure required for processing.

Downstream stages assume:
- the run structure exists
- raw pod streams are available and unchanged
- mapping and provenance metadata is reliable
- automation can locate all required inputs without heuristics

Stage 2 is therefore a foundation stage.
It makes the rest of the pipeline possible.

---