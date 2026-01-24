# Foot Pressure Sensor Development

## 1. Sensor Construction

### 1.1 Purpose

The foot sensor is designed to provide **temporal gait event information** rather than absolute pressure measurement. The goal is reliable detection of:

- Foot strike timing
- Mid stance loading behaviour
- Toe off timing

Signal shape and repeatability are more important than calibrated force values.

------

### 1.2 Layer Stack

The sensor uses a flexible resistive construction suitable for dynamic loading inside footwear.

**Layer structure:**

Top protective layer
 Kapton polyimide tape

Upper electrode
 Conductive nylon tape

Sensing layer
 Velostat pressure sensitive resistive sheet

Lower electrode
 Conductive nylon tape

Bottom protective layer
 Kapton polyimide tape

This creates a **force dependent variable resistance sandwich**.

Kapton was chosen for:

- Mechanical durability under flex
- Thin profile
- Electrical insulation
- Temperature stability

Velostat provides:

- Large resistance change under compression
- Tolerance to repeated loading cycles
- Simple analogue interface

<img src="../../../../../Pictures/WhatsApp Image 2026-01-24 at 12.06.25c PM.jpeg" style="zoom:25%;" />

<img src="../../../../../Pictures/WhatsApp Image 2026-01-24 at 12.06.26b PM.jpeg" alt="WhatsApp Image 2026-01-24 at 12.06.26b PM" style="zoom:25%;" />



------

### 1.3 Electrode and Wiring Arrangement

The sensor uses **3 wires** routed to MCU analogue inputs:

- Heel channel
- Toe channel
- Common reference or shared electrode depending on configuration

This forms 2 independent pressure regions:

- Rear foot loading
- Forefoot loading

Wiring choices:

- Basic (no solder wire to tape connection)

- Connections terminated using lightweight connectors
- Assembly encapsulated using Kapton to prevent layer shift

Design priority was **mechanical reliability over cosmetic finish**.



<img src="../../../../../Pictures/WhatsApp Image 2026-01-24 at 12.06.26 PM.jpeg" style="zoom:25%;" />

------

### 1.4 Electrical Behaviour

The sensor behaves as:

- A non linear force sensitive resistor
- Large resistance when unloaded
- Lower resistance under compression
- Some hysteresis expected
- Absolute values drift with placement and footwear

This is acceptable because the system relies on:

**Relative change and waveform shape**, not absolute force.

------

## 2. Software and Signal Validation

### 2.1 Objective

Validation aimed to confirm:

1. The sensor produces a repeatable waveform during gait
2. Heel and toe channels show expected phase differences
3. Signal timing aligns with biomechanical expectations
4. Noise level is acceptable for event detection

This stage validates **usability**, not calibration.

------

### 2.2 Method

Procedure used:

1. Sensors connected to MCU analogue inputs
2. Raw ADC values streamed over serial
3. Data observed using:
   - Serial plotter for live behaviour
   - Logged data plotted offline
4. User performed natural walking or running trials

No filtering or scaling applied beyond basic normalisation for plotting.

------

### 2.3 Observed Signal Characteristics

From the plotted data (example shown in figure):

- Clear cyclic behaviour present
- Heel channel shows early stance peak
- Toe channel shows later stance peak
- Waveforms are smooth, not impulse noise dominated
- Amplitude varies between steps, which is expected in dynamic gait

Important finding:

**Waveform shape and timing are consistent**, which is the primary requirement.

Magnitude is not treated as a reliable metric at this stage.

![](../../../../../Pictures/foot.PNG)

------

### 2.4 Gait Phase Behaviour

The signals demonstrate:

| Phase       | Heel                | Toe        |
| ----------- | ------------------- | ---------- |
| Foot strike | Rapid heel increase | Low        |
| Mid stance  | Heel elevated       | Toe rising |
| Push off    | Heel decreasing     | Toe peak   |
| Swing       | Both low            |            |

This matches expected biomechanical loading patterns.

------

### 2.5 Validation Outcome

The sensor system is considered **functionally validated** for:

- Detecting stance periods
- Identifying heel strike region
- Identifying toe off region
- Providing waveform data suitable for event detection algorithms

The hardware is therefore suitable for integration into the gait analysis pipeline.

------

## 3. Next Development Step

Current limitation:

Data is only visible in real time over serial.

Next step:

- Log sensor data internally to LittleFS on the MCU
- Timestamp alongside BLE IMU data
- Allow post run alignment between:
  - Pressure signals
  - IMU derived gait events

This will enable:

- Direct validation of toe off and foot strike algorithms
- Quantitative comparison between pressure and inertial signals
- Algorithm tuning using ground contact truth proxy

This marks the transition from **qualitative validation** to **synchronised multi sensor validation**.



## 4. Internal Foot Sensor Logging System

### 4.1 Purpose of This Stage

The foot pressure system has moved from **live serial viewing only** to **structured internal data logging** on the pod itself.

This transforms the sensors from a visual validation aid into a **post run analysis tool** that can be directly aligned with IMU derived gait events.

The objective is:

- Capture heel and toe pressure waveforms during real running
- Preserve precise timing
- Enable offline decoding into CSV
- Compare pressure derived contact timing with IMU event detection

This stage is about **time alignment and ground contact truth proxy**, not pressure calibration.

------

### 4.2 Logging Architecture

Foot sensor data is now recorded locally on the pod using:

- **LittleFS** on the ESP32 C3 internal flash
- Binary log files (`.bin`)
- Block structured format optimised for:
  - Low write overhead
  - Deterministic timing
  - Post processing reliability

Each run produces a file of the form:

```
/foot_<timestamp>.bin
```

Files contain:

- Block headers
- Timestamp of first sample in block
- Fixed sample rate (100 Hz)
- Interleaved heel and toe ADC values

This design ensures:

- No dependency on BLE connection
- No packet loss due to radio conditions
- Clean continuous waveform capture

The logger is active only while the pod is in **STREAMING state**, keeping behaviour aligned with IMU capture.

------

### 4.3 Data Retrieval Method

After a run:

1. Logging stops automatically when streaming stops.
2. The latest log file is requested over the USB serial port.
3. The pod streams the file as **raw binary** (no framing or text).
4. A host side script captures the serial stream and saves:

```
foot_dump.bin
```

This avoids:

- BLE transfer delays
- Protocol packet overhead
- Real time streaming constraints

The serial link is used purely as a **file transport channel**.

------

### 4.4 Decoding and CSV Generation

A Python decoder script converts the binary log into structured data:

```
decode_foot_log.py
```

This script:

- Parses block headers
- Reconstructs timestamps
- Outputs CSV containing:

| t_us | toe_adc | heel_adc |
| ---- | ------- | -------- |
|      |         |          |

The resulting CSV can be:

- Plotted directly
- Overlaid with IMU events
- Used to validate foot strike and toe off timing

![output (12)](../../../../../Downloads/output (12).png)

This moves the system from:

**"Signal looks right"**
 to
 **"Signal timing can be compared numerically to algorithm outputs."**

------

### 4.5 What This Enables

This logging capability now allows:

- Objective comparison between:
  - Pressure based contact detection
  - IMU derived gait events
- Investigation of:
  - False toe off detections
  - Missed foot strike events
  - Phase shifts between kinematic and pressure signals
- Development of hybrid algorithms using:
  - IMU for kinematics
  - Pressure as contact truth proxy

This is the foundation for **algorithm validation rather than visual intuition**.

------

### 4.6 System Role Clarification

The pressure system is now defined as:

**A validation and ground contact reference tool**, not a permanent production sensor.

Its purpose is to:

- Validate IMU event detection models
- Characterise timing error
- Guide algorithm refinement

Once models are proven, the system can return to IMU only operation with quantified confidence.