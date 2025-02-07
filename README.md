# SVGMagic - SVG support for RAD Studio

## Building

Open src\SVGLibrary.groupproj build and install.

## Third-Party library

SVGMagic requires a third-party library, named VerySimpleXml. This library brings the support of the Xml reading/writing in the Delphi IDE, and is linked to the Git project as a submodule. For that reason, don't forget to execute the command:

```
git submodule init
```

after you cloned the project. On the same way, you will have to execute the following command to update your submodule:

```
git submodule update
```

## Contributing

Expected workflow is: _Fork -> Patch -> Push -> Pull Request_

## License

Since 2025, [Ursa Minor Ltd.](https://copytrans.studio/) kindly opened the source code of the SVGMagic library. Now the code is under the MIT license.
