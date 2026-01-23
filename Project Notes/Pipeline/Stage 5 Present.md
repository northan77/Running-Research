# Stage 5: Present (validation and plots)

## Purpose

Stage 5 generates the plots and inspection tools that validate the outputs of the pipeline.

This stage exists to answer one question:

Do the derived artefacts make sense when aligned to the underlying signals?

Presentation is not a cosmetic reporting step. It is a core part of the trust model.
If Stage 5 cannot support a derived output visually and statistically, that output cannot be treated as reliable.

Stage 5 is also where comparisons become possible, because it produces stable plots and report artefacts for each run.

---

## What happens in this stage

Stage 5 reads:
- processed signal tables
- derived events
- strides and gait cycles
- segments and stride features
- QC and confidence markers

It then generates:
- interactive truth plots for human inspection
- standard validation plots (scatter, histograms, summary views)
- run level report outputs that support comparisons across runs

This stage creates durable evidence that supports future decisions.

---

## Inputs

Stage 5 uses artefacts produced by previous stages:

- processed signal tables (raw and filtered channels)
- events tables (foot strikes, toe off candidates)
- stride tables and gait cycles
- segment tables
- stride feature tables
- QC and confidence summaries

---

## Outputs

Stage 5 outputs validation artefacts, typically:

### Interactive inspection plots
Used to inspect truth directly.
Examples include:
- signal overlays with foot strike and toe off markers
- stride lanes and segment lanes
- QC pass fail lanes
- hover inspection and stride selection

### Standard validation plots
Used to summarise behaviour across a run.
Examples include:
- cadence stability over time
- stride time distributions
- stance proxy distributions
- event timing scatter plots

### Report artefacts
Outputs that support comparisons between runs.
Examples include:
- plot stats tables
- per run report notes
- run summary tables suitable for a dashboard

---

## Why this stage matters

Without Stage 5, a detection system can appear correct while actually being unstable.

Stage 5 prevents that by enforcing:
- direct signal truth visibility
- consistency checks
- outlier visibility
- repeatability evidence

This stage is where you detect hidden failure modes before they become dependencies.

---

## Validation principles

Stage 5 aims to validate at multiple levels:

### 1. Signal truth alignment
Events should align to observable signal structure.
For example:
- foot strike markers should align with strike related features in the signals
- toe off markers should align with plausible late stance features

The goal is not perfection. The goal is that events remain explainable.

### 2. Consistency within regime
Within a stable segment, stride level behaviour should form a coherent cluster.
If the scatter becomes random, either:
- the runner changed regime
- the sensor behaviour changed
- detection is unstable

### 3. Visible uncertainty
If a stride is uncertain, it should be flagged visibly.
Confidence and QC should not be hidden in a table only.

---

## Core validation metrics (math used for evidence, not detection)

Stage 5 uses simple mathematical measures to test stability and repeatability.

### Event phase position
A useful normalisation is to express an event as a phase within the stride:

\[
r = \frac{t_{event} - t_{strike}}{t_{next\_strike} - t_{strike}}
\]

Where:
- \(t_{strike}\) is the start of the stride
- \(t_{next\_strike}\) is the next stride anchor
- \(t_{event}\) is the event time within the stride

This ratio makes runs comparable even when cadence changes.

Interpretation:
- stable phase locking produces tight clusters
- changing running regime may shift the mean phase
- unstable detection produces wide scatter

### Time domain stability
It is equally important to view events in time:

\[
\Delta t = t_{event} - t_{strike}
\]

Time domain analysis prevents false conclusions created by ratio scaling effects at high cadence.

### Variability measures
Simple variability measures provide strong evidence:

- mean
- standard deviation
- interquartile range
- outlier rate

These are used across:
- cadence
- stride time
- event timing
- derived stance proxies

---

## Agreement and drift checks

Stage 5 also supports comparisons between:
- two detection versions
- two candidate event definitions
- two pipeline runs

### Bland Altman style agreement
When comparing two versions of an event timing output:

Difference:
\[
d = A - B
\]

Mean:
\[
m = \frac{A + B}{2}
\]

This allows bias and variability to be reported without over claiming truth.
It is useful for comparing algorithm revisions even before external ground truth exists.

---

## Standard plots produced

Typical plots used for validation include:

### Truth overlays
- raw and filtered signal traces
- event markers overlaid
- stride boundary lanes
- segment lane
- QC lane

These plots are the primary defence against hidden failure modes.

### Scatter plots
- event phase ratio vs cadence
- event time vs cadence
- stance proxy vs cadence
- stride time vs cadence

Scatter plots reveal:
- clusters (regimes)
- trends (cadence dependence)
- outliers (failure points)

### Distributions
- histograms of event timing
- histograms of time shifts between versions
- per segment distributions

Distributions reveal:
- how tight the detection is
- whether there are multiple running regimes
- whether a detector is biased

---

## Acceptance criteria

Stage 5 is considered successful when:

- truth overlays make it possible to inspect derived outputs directly
- key scatter plots reveal coherent structure rather than random noise
- QC and confidence markers are visible
- report outputs allow comparison between runs and versions
- plots are saved as stable artefacts for future review

If Stage 5 outputs are missing, derived outputs should not be trusted.

---

## Relationship to downstream work

Stage 5 enables safe iteration.

It provides:
- evidence that improvements are real
- early detection of regressions
- a durable record of validation findings

In practice, Stage 5 is the stage that prevents the system becoming a house of cards.

---