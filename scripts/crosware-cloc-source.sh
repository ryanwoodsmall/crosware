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

export PATH="${PATH}:${cwtop}/software/cloc/current/bin:${cwtop}/software/perl/current/bin"

for p in cloc perl ; do
  hash ${p} >/dev/null 2>&1 || {
    echo "${p} not found"
    exit 1
  }
done

echo 'crosware source:'
cwsi="${cwtop}/tmp/crosware_cloc_ignored.out"
cloc \
  --lang-no-ext='Bourne Again Shell' \
  --force-lang='Bourne Again Shell',sh{,.common} \
  --ignored="${cwsi}" \
    "${cwtop}/bin/" \
    "${cwtop}/etc/profile" \
    "${cwtop}/etc/functions" \
    "${cwtop}/etc/vars" \
    "${cwtop}/recipes/"

echo
cwso="${cwtop}/tmp/crosware.set.out"
test -e "${cwso}" && cat "${cwso}" > "${cwso}.old"
"${cw}" set > "${cwso}"
echo 'crosware set expanded:'
cloc \
  --force-lang='Bourne Again Shell' \
    "${cwso}"

echo "view diffs of ${cwso} with:"
echo "  ${cwtop}/scripts/view-cloc-diff.sh"
