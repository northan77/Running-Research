# Approach

This document outlines a working approach for exploring running gait analysis over time.

The intent is to describe how the problem is being broken down and explored, rather than to define a fixed plan or implementation.

The approach is expected to evolve as understanding improves.

## Overall aim

The aim is to explore how running gait changes over time and across conditions, and how those changes can be observed in captured movement data.

The focus is on comparison and trend rather than absolute measurement.

## Stage 1 Initial capture and context

Begin by capturing running sessions in a consistent way.

At this stage the emphasis is on:
• repeatability
• recording basic context alongside each run
• understanding what a “typical” session looks like

Notes focus on what was captured and under what conditions, rather than on analysis.

## Stage 2 Review and segmentation

Explore ways to break longer recordings into meaningful sections that can be compared.

This includes:
• identifying the run portion of a recording
• separating steady running from transitions or disruptions
• noting obvious data quality issues

The goal is to make different runs easier to compare without over processing.

## Stage 3 Feature exploration

Explore different ways of describing running gait using simple derived features.

At this stage:
• multiple candidate features may be explored
• some will be unstable or unhelpful
• others may show consistent behaviour

Features that do not behave well are expected to be discarded.

## Stage 4 Comparing sessions over time

Once a small set of useful features exists, explore how they change:
• within a single run
• between similar runs
• across weeks or different conditions

The focus is on observing patterns and deltas rather than drawing conclusions.

## Stage 5 Interpretation and use

Explore how observed changes might be used as prompts for attention or reflection, for example around fatigue, load, or running efficiency.

Any interpretation is treated as indicative rather than definitive.

## Notes on implementation

This repository contains notes, summaries, and illustrative snippets only.

Full analysis code and tooling live elsewhere and are not part of this repository.

## Data sharing

Example run data may be added later once capture and review methods are stable.
