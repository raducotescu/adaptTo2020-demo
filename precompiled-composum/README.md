Paving the way to a native Sling - Composum Demo
====

This demo is built from two Maven projects:
1. `composum` - a fork of the Composum modules, where the projects have been reorganised to precompile the scripts and pack them as OSGi Bundles
2. `sling-feature` - a project that provides two Sling Features:
    1. an Apache Sling Starter instance with the latest Composum release, accessible at http://localhost:8080
    2. an Apache Sling Starter instance with the SNAPSHOT Composum build from above, accessible at http://localhost:8081

## How to run the demo

```bash
git submodule init
git submodule update
mvn --settings composum/settings.xml clean install -DskipTests
./start.sh
```
