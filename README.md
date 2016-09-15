# 3DMembraneReconstruction

The is a package to reconstruct 3D membrane fluorescent/brightfield microscope images/movies.

## System Requirement

- Requires MATLAB (R2015a) or newer to run. 
- Computer memory requirement. The RAM has to be bigger than the size of the movie being analyzed + 4 times the size of a single z stack in the movie
- 1920x1080 screen is recommended to display UI.

## UI vs Script
GUI or matlab script can be used to interact with the package. To start the GUI, open the program ‘main.m’ and the UI will pop up. To work with the script, please check out sample_script_*.m first. A detail description of class is available at the end of this file. Use of script is strongly encouraged if you want to process a batch of files and speed things up by parallel computing.

## Sample Images
There are several different types of sample images
- sample_image.dv ---- fission yeast nuclei labeled with cut11-gfp
- sample_image_er.dv ---- fission yeast, er labled
- sample_image_mamalian.dv –--- mamalian cell
- sample_image_doubleparticle.TIF ---- 2 fluorescent particles per cell

## UI Guide

- Run the program ‘main.m’ and a simple UI will pop up.
- For the rest, please check User Guide.docx file.