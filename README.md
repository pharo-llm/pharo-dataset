# Completion-Dataset-Generator

A Pharo utility for exporting structured code completion datasets from existing packages.  
It enables researchers and tool builders to generate JSON datasets suitable for training, testing, or analyzing code completion systems.

## Features

- Export completion datasets from any Pharo package
- Configurable heuristics for completion extraction
- Multiple context levels for varying semantic richness
- JSON output for easy downstream processing
- Designed for research and ML-based tooling

## Installation 

```st
Metacello new
  githubUser: 'omarabedelkader' project: 'Completion-Dataset-Generator' commitish: 'main' path: 'src';
  baseline: 'CompletionDatasetGenerator';
  load.
```
