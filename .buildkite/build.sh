#!/usr/bin/env bash

set -euo pipefail

mkdir -p pkg/gems

# shellcheck disable=SC2035
gems=$(find * -name '*.gemspec' | sed 's|/[^/]*$||' | grep -v .gemspec)

for gem in "${gems[@]}"; do
  (
    echo "Building gem for: ${gem}"
    gem build -C "${gem}" "${gem}/${gem}.gemspec"
    mv "${gem}"/*.gem pkg/gems/
  )
done

cd pkg
gem generate_index
