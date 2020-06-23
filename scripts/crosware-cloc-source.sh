#!/usr/bin/env bash

#
# count lines of source in..
#   - bin/, etc/profile, recipes/, ...
#   - `crosware set` output
# to get a sense of how big runtime-expanded script/env is
#

cwtop="$(realpath $(dirname ${BASH_SOURCE[0]})/..)"
cw="${cwtop}/bin/crosware"
test -e "${cw}" || {
  echo 'this does not look like crosware'
  exit 1
}

export PATH="${PATH}:${cwtop}/software/cloc/current/bin"

which cloc >/dev/null 2>&1 || {
  echo 'cloc not found'
  exit 1
}

echo 'crosware source:'
cloc \
  --lang-no-ext='Bourne Again Shell' \
  --force-lang='Bourne Again Shell',sh{,.common} \
  --ignored=/tmp/crosware_cloc_ignored.out \
    "${cwtop}/bin/" \
    "${cwtop}/etc/profile" \
    "${cwtop}/recipes/"

echo
cwso="${cwtop}/tmp/crosware.set.out"
"${cw}" set > "${cwso}"
echo 'crosware set expanded:'
cloc \
  --force-lang='Bourne Again Shell' \
    "${cwso}"
