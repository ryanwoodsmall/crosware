#!/usr/bin/env bash

set -eu
set -o pipefail

if [ ! -e /usr/local/crosware/etc/vars ] ; then
  echo "$(basename ${0}): this does not appear to be crosware"
  exit 1
fi

. /usr/local/crosware/etc/vars
. ${cwtop}/etc/functions

declare -a a
declare -A q
declare -A e
declare -A m

readarray -t a < <(crosware list-recipe-reqs)

function uniqueify() {
  echo "${@}" | tr ' ' '\n' | sort -u | xargs echo
}

for i in ${!a[@]} ; do
  l="${a[${i}]}"
  r="${l// /}"
  r="${r%%:*}"
  d="${l##${r} : }"
  d="$(uniqueify ${d})"
  q["${r}"]="${d}"
  e["${r}"]="${d}"
  m["${r}"]=0
done

function reqcount() {
  echo ${#}
}

function expandreqs() {
  local r="${1}"
  if [ "${m[${r}]}" -eq 1 ] ; then
    return
  fi
  if [ $(reqcount ${q[${r}]}) -eq 0 ] ; then
    m["${r}"]=1
    return
  fi
  local o="${2}"
  local n
  for d in ${e[${r}]} ; do
    if [ ${m[${d}]} -ne 1 ] ; then
      if [ $(reqcount ${q[${d}]}) -ge 1 ] ; then
        expandreqs "${d}" "$(reqcount ${q[${d}]})"
      fi
    fi
    m["${d}"]=1
  done
  for d in ${e[${r}]} ; do
    e["${r}"]+=" ${e[${d}]}"
  done
  e["${r}"]="$(uniqueify ${e[${r}]})"
  n="$(reqcount ${e[${r}]})"
  if [[ ${o} != ${n} ]] ; then
    expandreqs "${r}" "${n}"
  fi
  m["${r}"]=1
}

for r in $(echo ${!q[@]} | tr ' ' '\n' | sort) ; do
  c="$(reqcount ${q[${r}]})"
  echo -n "${r} : ${c} : ${q[${r}]} : "
  expandreqs "${r}" "${c}"
  n="$(reqcount ${e[${r}]})"
  echo  "${n} : ${e[${r}]}"
done
