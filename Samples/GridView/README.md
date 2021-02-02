# Grid view demo

This demo shows how to combine the SVGMagic SVG graphic component with a VirtualTree view to create a basic thumbnail view. In particular, it demonstrates how a SVG image may be painted from a SVG image list component onto a destination canvas belonging to another component.

![Thumbnail view](Screenshots\GridView.png)

## Building

Open src\SVGLibrary.groupproj build and install.

## Third-Party library

This demo requires a third-party library, named VirtualTrees. This library provides several highly customizable and well optimized tree view components, and is linked to the Git project as a submodule, in the Samples\Common dir. For that reason, don't forget to execute the command:

<p style="font-family: courier new"><b>git submodule init</b></p>

after you cloned the project. On the same way, you will have to execute the following command to update your submodule:

<p style="font-family: courier new"><b>git submodule update</b></p>

Once obtained, the VirtualTrees should be compiled and installed before trying to compile and execute the demo.

## License

Copyright (C) 2018 - 2021 Ursa Minor Ltd., All Rights Reserved