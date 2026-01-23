# Stage 4: Derived (events, strides, segments, features)

## Purpose

Stage 4 converts processed signals into structured derived artefacts that can be analysed, compared, and validated.

This stage is where continuous time series become discrete units such as:
- events (foot strike, toe off candidates)
- stride units and gait cycles
- segments (stable running regimes)
- stride level features and summary statistics

Stage 4 produces interpretation, not absolute truth.
For this reason its outputs are designed to be inspectable and validated in Stage 5.

This document describes the principles and outputs without disclosing detection routines.

---

## What happens in this stage

Stage 4 builds a layered set of derived artefacts from the processed signals.

A typical flow:

1. Generate event candidates from processed signals
2. Assemble events into strides and gait cycles
3. Identify stable running segments (regimes) for fair comparisons
4. Compute stride level feature tables and run level summaries

Each derived artefact is written as a stable file and is designed to be reused by downstream tools without recomputation.

---

## Inputs

- processed signal tables from Stage 3 (aligned and conditioned)
- pod mapping information (thigh, calf roles)
- configuration parameters (window sizes, thresholds, validation settings)

---

## Outputs

Stage 4 outputs structured tables and metadata.

Typical categories:

### 1. Events
Tables representing discrete gait events.

Examples:
- foot strike event list
- toe off event list (may include multiple candidates or methods)
- supporting event QC or confidence indicators

Events are always stored as time anchored records, suitable for overlay on signal plots.

### 2. Stride and gait cycle tables
Tables that describe stride boundaries and derived gait cycles.

These artefacts allow:
- consistent indexing of strides
- alignment of signals per stride
- extraction of stride level features

### 3. Segments
Tables that describe run segmentation.

Segments exist to separate different running regimes such as:
- stable cadence blocks
- warmup versus steady state
- transitions or anomalies

Segmentation prevents misleading comparisons by avoiding mixing incompatible conditions.

### 4. Feature tables
Stride level feature tables suitable for:
- scatter plots
- trend analysis
- outlier detection
- later modelling

Feature tables are intentionally broad and can evolve over time.
They remain interpretable because all features trace back to stride definitions and event anchors.

---

## Events (principle without disclosure)

Events are discrete time points derived from the processed signals.
They are not assumed correct by default.
They are treated as candidates with confidence.

An event record typically includes:
- event type (for example foot strike, toe off)
- event time
- stride index or association
- confidence or QC fields
- optional context fields (such as candidate score)

### Candidate based philosophy
This stage may generate multiple event candidates for a given stride and then select one for downstream use.

This avoids fragile behaviour where one missed peak causes silent corruption.
Instead the system can:
- choose the best candidate
- or reject the stride if confidence is too low

The specific selection logic is intentionally not disclosed here.

---

## Strides and gait cycles (why they exist)

Once events are detected, strides are constructed as the primary analysis unit.

A stride is typically defined between two consecutive anchor events, for example strike to strike for the same side.
Stride building enables:

- normalised comparisons between strides
- consistent feature extraction
- robust scatter plot analysis
- separation of stable running regimes

Stride tables form the backbone of all run level analysis.

---

## Segmentation (regime awareness)

Runs often contain multiple regimes even on a treadmill.
Cadence and stride dynamics can change due to:
- speed steps
- adaptation and settling
- fatigue drift
- form changes
- transient anomalies

Segmentation aims to identify stable regions so comparisons are valid.

This stage may output:
- segment boundaries in time or stride index
- per segment cadence summary statistics
- segment labels (stable, transition, anomaly)

Segmentation does not require perfect classification to be useful.
Even coarse segmentation greatly reduces false conclusions.

---

## Feature extraction (interpretation in tables)

Features are computed at the stride level and are intended to support:

- fast scanning of patterns
- detection of outliers
- statistical summaries by segment
- regression and modelling later

Features may include:
- cadence, stride time
- stance proxy measures (derived from events)
- magnitude and timing features from signals
- variability metrics over windows

Feature computation must remain traceable.
No feature should exist without:
- a clear definition
- a link to stride boundaries
- a link to the underlying signals

---

## Quality control and confidence

Stage 4 introduces quality control indicators to prevent silent failure.

Typical QC concepts include:
- stride validity checks
- missing event handling
- outlier rejection flags
- confidence scores per event and stride

These indicators are not intended to hide poor runs.
They exist to highlight uncertainty and prevent overconfident conclusions.

---

## What this stage does not do

Stage 4 intentionally avoids:
- publishing proprietary detection routines
- claiming generalisation across runners
- assuming biomechanical truth without validation

It generates derived artefacts for inspection and testing.
Trust is earned in Stage 5.

---

## Acceptance criteria

Stage 4 is considered successful when:

- event tables exist and are consistent with processed signals
- stride tables are coherent and indexable
- segmentation outputs provide stable regime grouping
- feature tables exist and link back to strides and events
- QC and confidence fields are present and interpretable

If derived outputs appear inconsistent, they must be validated visually before being used for conclusions.

---

## Relationship to downstream stages

Stage 4 outputs are inputs to Stage 5 presentation, where they are validated.

Stage 5 is responsible for proving that:
- detected events align with real signal structure
- stride and segment boundaries make biomechanical sense
- outliers and failures are visible and explainable

Stage 4 provides the structure.
Stage 5 provides the evidence.

---