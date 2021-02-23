#!/usr/bin/env bash

set -euo pipefail

cd pkg
echo "<h1>'ere be gems</h1>" >index.html
aws s3 sync . s3://oculo-rubygems/
