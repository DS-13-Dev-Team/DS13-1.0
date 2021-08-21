#!/bin/bash
set -euo pipefail

source dependencies.sh

~/$1 --version
