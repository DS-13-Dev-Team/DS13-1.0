#!/bin/bash
set -euo pipefail

tools/deploy.sh ci_test
mkdir ci_test/config

cd ci_test
DreamDaemon baystation12.dmb -close -trusted -verbose -params "log-directory=ci"
cd ..
#cat ci_test/data/logs/ci/clean_run.lk
