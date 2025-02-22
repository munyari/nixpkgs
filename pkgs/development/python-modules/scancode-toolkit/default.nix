{ lib
, attrs
, beautifulsoup4
, bitarray
, boolean-py
, buildPythonPackage
, chardet
, click
, colorama
, commoncode
, debian-inspector
, dparse
, extractcode
, extractcode-7z
, extractcode-libarchive
, fasteners
, fetchPypi
, fingerprints
, ftfy
, gemfileparser
, html5lib
, importlib-metadata
, intbitset
, jaraco_functools
, javaproperties
, jinja2
, jsonstreams
, license-expression
, lxml
, markupsafe
, packageurl-python
, packaging
, parameter-expansion-patched
, pefile
, pkginfo
, pluggy
, plugincode
, publicsuffix2
, pyahocorasick
, pycryptodome
, pygmars
, pygments
, pymaven-patch
, pytestCheckHook
, pythonOlder
, requests
, saneyaml
, spdx-tools
, text-unidecode
, toml
, typecode
, typecode-libmagic
, typing
, urlpy
, xmltodict
, zipp
}:

buildPythonPackage rec {
  pname = "scancode-toolkit";
  version = "30.1.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UYQf+cBi2FmyZxIbQJo7vLjPuoePIMC8FugvoG1Ebj0=";
  };

  dontConfigure = true;

  propagatedBuildInputs = [
    attrs
    beautifulsoup4
    bitarray
    boolean-py
    chardet
    click
    colorama
    commoncode
    debian-inspector
    dparse
    extractcode
    extractcode-7z
    extractcode-libarchive
    fasteners
    fingerprints
    ftfy
    gemfileparser
    html5lib
    intbitset
    jaraco_functools
    javaproperties
    jinja2
    jsonstreams
    license-expression
    lxml
    markupsafe
    packageurl-python
    packaging
    parameter-expansion-patched
    pefile
    pkginfo
    pluggy
    plugincode
    publicsuffix2
    pyahocorasick
    pycryptodome
    pygmars
    pygments
    pymaven-patch
    requests
    saneyaml
    spdx-tools
    text-unidecode
    toml
    typecode
    typecode-libmagic
    urlpy
    xmltodict
    zipp
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.7") [
    typing
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pdfminer.six >= 20200101" "pdfminer.six" \
      --replace "pluggy >= 0.12.0, < 1.0" "pluggy" \
      --replace "pygmars >= 0.7.0" "pygmars" \
      --replace "license_expression >= 21.6.14" "license_expression"
  '';

  # Importing scancode needs a writeable home, and preCheck happens in between
  # pythonImportsCheckPhase and pytestCheckPhase.
  postInstall = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "scancode"
  ];

  # takes a long time and doesn't appear to do anything
  dontStrip = true;

  meta = with lib; {
    description = "Tool to scan code for license, copyright, package and their documented dependencies and other interesting facts";
    homepage = "https://github.com/nexB/scancode-toolkit";
    license = with licenses; [ asl20 cc-by-40 ];
    maintainers = teams.determinatesystems.members;
  };
}
