# Stage 3: Process (foundation transform steps)

## Purpose

Stage 3 converts raw pod capture streams into processed, analysis ready signals through a deterministic sequence of transform steps.

This stage is the foundation of the entire pipeline. It produces the stable signal tables that all downstream analysis depends on.

The goal of Stage 3 is not biomechanical interpretation. The goal is to produce signals that are:
- aligned on a shared time base
- consistently formatted
- traceable back to raw sources
- suitable for both visual inspection and downstream analysis

This stage may include mathematical operations (alignment, filtering, resampling) but does not disclose event detection or selection routines.

---

## What happens in this stage

Stage 3 runs a defined set of processing steps that typically include:

1. Alignment of pod streams onto a common time base
2. Optional resampling or interpolation into a consistent sampling grid
3. Signal conditioning such as filtering and smoothing
4. Creation of a processed signal table used as the contract for later stages

Each step writes explicit artefacts and metadata so the process is reproducible and debuggable.

---

## Inputs

- raw pod stream files from Stage 1 (via Stage 2 ingest)
- pod mapping metadata (which stream corresponds to which limb segment)
- processing configuration parameters (sampling rate, filter characteristics, etc.)

---

## Outputs

Stage 3 outputs processed signal artefacts and transform metadata.

Typical outputs include:
- aligned signal tables
- processed signal tables (often including both raw and filtered channels)
- alignment reports (offsets, stream quality)
- filter reports (channels created, key parameters)
- processing completion markers

These outputs are designed to be stable as downstream algorithms evolve.

---

## Step 3.1: Alignment

### Principle
Multiple sensors produce independent streams with different start times, BLE jitter, and occasional dropouts. Alignment converts these streams into a common timeline so signals can be compared and combined.

At a conceptual level, alignment seeks a mapping between each pod time base and a global run time axis:

\[
t^{(k)} \rightarrow \hat{t}
\]

where \(t^{(k)}\) is the timestamp (or reconstructed time) for pod \(k\), and \(\hat{t}\) is the aligned global time.

### Typical actions
- determine per pod start offset
- correct for discontinuities and gaps
- enforce monotonic time ordering
- optionally resample all streams onto a common grid

### Resampling model (conceptual)
If resampling is used, the aligned signal \(x(\hat{t})\) may be created from irregular samples using interpolation:

\[
x(\hat{t}_i) = interp\left(\{(t_j, x_j)\}, \hat{t}_i\right)
\]

This is a signal processing convenience, not a biomechanical assumption.

### Alignment success criteria
Alignment is considered valid when:
- all channels share a coherent time axis
- pod streams overlap as expected
- discontinuities are recorded and visible
- derived time series do not contain time reversals

Alignment problems must be recorded because they directly impact trust.

---

## Step 3.2: Channel standardisation

### Principle
Raw pod capture files often differ in naming, ordering, and metadata representation. Downstream tools require stable conventions.

This step creates a consistent representation of signals such as:
- fixed column naming conventions
- consistent units
- consistent channel grouping (thigh and calf signals)
- consistent time representation

The output is a processed signals table that downstream stages can rely on as a contract.

---

## Step 3.3: Filtering and conditioning

### Principle
Filtering improves usability of inertial signals for inspection and downstream extraction by reducing high frequency noise and stabilising derivatives.

Filtering is treated as a transparent transformation with traceability back to raw data.

A filtered signal can be expressed as:

\[
x_f(t) = (x * h)(t)
\]

where:
- \(x(t)\) is the raw signal
- \(h(t)\) is the filter impulse response
- \(*\) is convolution

In discrete form:

\[
x_f[n] = \sum_{m=-\infty}^{\infty} x[m] \, h[n-m]
\]

Filtering is applied selectively to channels where it provides benefit and does not obscure truth.

### Common conditioning actions
This stage may include:
- low pass filtering for noise reduction
- smoothing for stable feature display
- optional detrending or offset correction
- creation of both raw and filtered channel variants

### Important note on phase
Filtering can introduce delay. Where phase is important, the pipeline must preserve traceability and ensure outputs remain inspectable against raw signals.

Stage 3 therefore retains both raw and filtered channels so later stages can validate:

- are events consistent in raw signals
- are filtered features simply clearer, not moved or invented

---

## Determinism and traceability

Stage 3 is required to be deterministic.
Given the same inputs and configuration, it must produce identical outputs.

To support this:
- transform parameters are written to metadata
- completion markers indicate successful processing
- errors and warnings are logged as artefacts

This prevents silent drift and supports valid comparisons between runs.

---

## What this stage does not do

Stage 3 intentionally does not include:
- gait event detection logic
- toe off selection logic
- stride segmentation logic
- any biomechanical modelling

Stage 3 produces signals only. Interpretation belongs downstream where it can be validated.

---

## Acceptance criteria

Stage 3 is considered successful when:
- processed signal tables exist and are complete
- time alignment is coherent and documented
- raw and filtered channels are available as expected
- transform metadata exists and is readable
- downstream stages can operate without special cases

If Stage 3 fails or produces questionable alignment, downstream outputs must be treated as lower confidence until inspected.

---

## Relationship to downstream stages

Stage 3 outputs form the stable signal contract for later stages.

Downstream stages assume:
- alignment is correct enough for comparison
- channel naming conventions are stable
- filtered channels are available where expected
- raw channels remain accessible for truth inspection

If Stage 3 changes, downstream stages should not need rewriting.
That is the purpose of this stage.

---