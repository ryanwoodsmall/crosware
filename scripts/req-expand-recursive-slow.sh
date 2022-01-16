#!/usr/bin/env bash
#
# XXX - memoization, slow
#

set -eu
set -o pipefail

if [ ! -e /usr/local/crosware/etc/vars ] ; then
  echo "$(basename ${0}): this does not appear to be crosware"
  exit 1
fi

. /usr/local/crosware/etc/vars
. ${cwtop}/etc/functions

declare -A q
declare -A e
declare -A x

#f="${cwtop}/tmp/reqs.out"
#readarray -t a < ${f}
readarray -t a < <(crosware list-recipe-reqs)

function uniqueify() {
  echo "${@}" | tr ' ' '\n' | sort -u | xargs echo -n
}

for i in ${!a[@]} ; do
  l="${a[${i}]}"
  r="${a[${i}]}"
  r="${r// /}"
  r="${r%%:*}"
  d="${l##${r} : }"
  d="$(uniqueify ${d})"
  q["${r}"]="${d}"
done

function reqcount() {
  local r="${1}"
  local c=0
  local d="$(uniqueify ${q[${r}]})"
  local i
  d="${d# }"
  d="${d% }"
  for i in ${d} ; do
    ((c++))
  done
  echo "${c}"
}

function expandreqs() {
  local r="${1}"
  local o="${2}"
  local n
  for d in ${q[${r}]} ; do
    q["${r}"]="$(uniqueify ${q[${r}]} ${q[${d}]})"
  done
  n="$(reqcount ${r})"
  if [[ $o != $n ]] ; then
    expandreqs "${r}" "${n}"
  fi
}

#for r in $(echo ${!q[@]} | tr ' ' '\n' | sort) ; do
#  echo "${r} : $(reqcount ${r}) : '${q[${r}]}'"
#done

for r in $(echo ${!q[@]} | tr ' ' '\n' | sort) ; do
  c="$(reqcount ${r})"
  echo -n "${r} : ${c} : ${q[${r}]} : "
  expandreqs "${r}" "${c}"
  n="$(reqcount ${r})"
  echo  "${n} : ${q[${r}]}"
done
