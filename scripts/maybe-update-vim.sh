#!/usr/bin/env bash
#
# conditionally update the vim recipe if a new version is detected
#
set -eu
set -o pipefail

: ${cwtop:=""}
test -z "${cwtop}" && { echo 'the ${cwtop} environment variable is not set' 1>&2 ; exit 1 ; }

for c in curl xmllint ; do
  command -v "${c}" &>/dev/null || { echo "required program '${c}' not found" 1>&2 ; exit 1 ; }
done
unset c

currentver=$(grep ^rver= ${cwtop}/recipes/vim/vim.sh | cut -f2 -d'"')
latestver=$(bash ${cwtop}/scripts/show-latest-vim.sh)

if [[ ${currentver} != ${latestver} ]] ; then
  echo "updating from ${currentver} to ${latestver}" 1>&2
  bash ${cwtop}/scripts/update-recipe-file.sh vim "${latestver}"
else
  echo "no update necessary" 1>&2
fi
