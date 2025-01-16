# SVGMagic - SVG support for RAD Studio

## Building

Open src\SVGLibrary.groupproj build and install.

## Third-Party library

SVGMagic requires a third-party library, named VerySimpleXml. This library brings the support of the Xml reading/writing in the Delphi IDE, and is linked to the Git project as a submodule. For that reason, don't forget to execute the command:

<p style="font-family: courier new">git submodule init</p>

after you cloned the project. On the same way, you will have to execute the following command to update your submodule:

<p style="font-family: courier new">git submodule update</p>

## Contributing

Expected workflow is: Fork -> Patch -> Push -> Pull Request

## License

Copyright (C) 2018 - 2025 Ursa Minor Ltd., All Rights Reserved
