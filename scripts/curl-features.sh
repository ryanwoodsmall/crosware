#!/usr/bin/env bash
#
# show curl features/protocols/etc. per tls provider
#
set -eu
set -o pipefail

declare -a curls
curls=( $(find ${cwsw}/curl*/current/bin/curl-*{ssl,tls} | sort ; true) )

declare -A tls tlsver feat prot

for c in ${curls[@]} ; do
  v=()
  b="$(basename $c)"
  p="${b##curl-}"
  tls["${p}"]="${c}"
  readarray -t v < <(${c} --version)
  for i in ${!v[@]} ; do
    line="${v[${i}]}"
    if [[ "${line}" =~ ^curl ]] ; then
      tlsver["${p}"]="${line}"
    elif [[ "${line}" =~ ^Features: ]] ; then
      line="${line##Features:}"
      for f in ${line} ; do
        feat["${f}"]+=" ${p}"
      done
    elif [[ "${line}" =~ ^Protocols: ]] ; then
      line="${line##Protocols:}"
      for r in ${line} ; do
        prot["${r}"]+=" ${p}"
      done
    fi
  done
done

echo
echo "versions:"
for p in $(echo ${!tls[@]} | tr ' ' '\n' | sort) ; do
  echo "- ${p} : ${tlsver[${p}]}"
done | tr -s ' '
echo
echo "features:"
for f in $(echo ${!feat[@]} | tr ' ' '\n' | sort) ; do
  echo "- ${f} : $(echo ${feat[${f}]} | tr ' ' '\n' | sort | xargs echo)"
done | tr -s ' '
echo
echo "protocols:"
for r in $(echo ${!prot[@]} | tr ' ' '\n' | sort) ; do
  echo "- ${r} : $(echo ${prot[${r}]} | tr ' ' '\n' | sort | xargs echo)"
done | tr -s ' '
echo
