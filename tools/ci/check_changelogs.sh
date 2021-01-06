#!/bin/bash
set -euo pipefail

md5sum -c - <<< "b9a10c9ad689d9d06df2bfb0e56be951 *html/changelogs/example.yml"
python3 tools/GenerateChangelog/ss13_genchangelog.py html/changelog.html html/changelogs
