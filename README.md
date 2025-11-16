# Timeliner

A simple utility for visualiazing timelines encoded as CSV files

## Installation
Binaries can be found in the releases page (https://github.com/alcalino-git/timeliner/releases)

## Usage

Using the `Open` button on the UI will result in that CSV file being parsed and rendered.
The program will begin watching for changes on that file and automatically re-render
if any changes are made

The CSV file must have at least the following headers (Spelled EXACTLY like that but not necessarily in that order)
- name: String
- start: date (ISO format)
- end: date (ISO format) (optional)
- description: String
- image: URL pointing to an image

For example, the following is a valid CSV file
```csv
name,start,end,description,image
Ada Lovelace,1815-12-10,1852-11-27,English mathematician who wrote notes on Babbage's Analytical Engine and is often credited with the first algorithm intended to be carried out by a machine.,https://upload.wikimedia.org/wikipedia/commons/a/a4/Ada_Lovelace_portrait.jpg
```

|name        |start     |end       |description                                                                                                                                                 |image                                                                        |
|------------|----------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|
|Ada Lovelace|1815-12-10|1852-11-27|English mathematician who wrote notes on Babbage's Analytical Engine and is often credited with the first algorithm intended to be carried out by a machine.|https://upload.wikimedia.org/wikipedia/commons/a/a4/Ada_Lovelace_portrait.jpg|

## Configurating the timeline
The following options are provided via the UI:
- Gaps: Space between each item (in pixels)
- Height: Height of each item (in pixels)
- Aspect Ratio: Aspect ratio of the cards (slider from 0 to 2)
- Orientation: Either column or row

## Exporting the timeline

The `Export` button will save the currently loaded timeline as a png file.

This file is strictly rendered using the `Height` specified, even if said height can't fit in the preview.
This means the actual image might be bigger than the UI can display (but never smaller)
