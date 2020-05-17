ocaml-chrome-ext: OCaml bindings to the Chrome browser extensions JavaScript API
================================================================================

Overview
--------

This project implements (partial) bindings to the Chrome browser extensions JavaScript API. The bindings are created with gen_js_api.

Installation
------------

````
opam pin add chrome_ext https://github.com/dboris/ocaml-chrome-ext.git
````

Examples
--------

The test suite is implemented in a Chrome extension that serves as an example of how to use the bindings. To install the extension, run `make` and load the extension into Chrome from the `dist` directory. The test results are printed on the background page console and on a page opened by the extension.