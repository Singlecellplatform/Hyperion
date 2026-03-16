# Evident Viewer Installation Guide (macOS)

This document describes how to install the **Evident Viewer plugin** for
Fiji (ImageJ distribution) on macOS to open Olympus / Evident `.vsi`
microscopy files.

Official Guide Source:\
https://github.com/evident-imagejplugin/evident-viewer-guide

------------------------------------------------------------------------

## Overview

The Evident Viewer plugin allows Fiji to read:

-   `.vsi`
-   `.ets`
-   Olympus / Evident whole-slide image formats

Recommended platform: Fiji

------------------------------------------------------------------------

## System Requirements

-   macOS (Intel or Apple Silicon)
-   Fiji installed
-   Java bundled inside Fiji (do not use system Java)

------------------------------------------------------------------------

## Step 1 --- Install Fiji

1.  Download Fiji from: https://fiji.sc/

2.  Unzip the downloaded file.

3.  Move `Fiji.app` to: /Applications

4.  Launch once to confirm it runs correctly.

------------------------------------------------------------------------

## Step 2 --- Download Evident Viewer Plugin

1.  Visit: https://github.com/evident-imagejplugin

2.  Download the latest release `.jar` file.

Example: EvidentViewer_x.x.x.jar

------------------------------------------------------------------------

## Step 3 --- Install Plugin into Fiji

Copy the downloaded `.jar` file into:

/Applications/Fiji.app/plugins/

Example terminal command:

mv EvidentViewer_x.x.x.jar /Applications/Fiji.app/plugins/

Restart Fiji after copying.

------------------------------------------------------------------------

## Step 4 --- macOS Security Fix (If Blocked)

If macOS blocks the plugin due to security restrictions:

Option A --- Remove quarantine from Fiji:

xattr -cr /Applications/Fiji.app

Option B --- Remove quarantine from plugin only:

xattr -d com.apple.quarantine
/Applications/Fiji.app/plugins/EvidentViewer_x.x.x.jar

Then reopen Fiji.

------------------------------------------------------------------------

## Step 5 --- Verify Installation

Open Fiji.

Check the menu:

Plugins → Evident Viewer

If visible, installation is successful.

------------------------------------------------------------------------

## Step 6 --- Open VSI Files

Ensure both files exist in the same directory:

sample.vsi\
sample.ets/

Then open using:

File → Import → Evident Viewer

or

Plugins → Evident Viewer → Open

------------------------------------------------------------------------

## Troubleshooting

Plugin Not Appearing: - Confirm `.jar` is inside `Fiji.app/plugins/` -
Fully restart Fiji

macOS Developer Warning: Run: xattr -cr /Applications/Fiji.app

VSI File Not Opening: - Confirm `.ets` folder exists - Keep `.vsi` and
`.ets` together - Update Fiji: Help → Update...

------------------------------------------------------------------------

End of Document.

