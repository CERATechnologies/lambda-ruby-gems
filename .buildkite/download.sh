#!/usr/bin/env bash

set -euo pipefail

mkdir -p pkg/gems

aws s3 sync s3://oculo-rubygems/ pkg/
