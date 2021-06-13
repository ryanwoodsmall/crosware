#!/usr/bin/env bash
#
# expand recipe reqs using an associative array and lengths
#
# XXX - slow and naive but recursive chasing down is expensive
# XXX - really need to preserve order, recursive approach makes that easier
# XXX - i.e., l="r1 r2 ... rN" ; l="$(cwreqs_r1) r1 $(cwreqs_r2) r2 ... $(cwreqs_rN) rN)" ; l="$(cwuniqueargs ${l})" # repeat until input length = output length
# XXX - needs memoization
# XXX - memoize each recipe as it's expanded
# XXX - also work on ${!cwrecipes[@]} ${!cwbootstraprecipes[@]}
# XXX - this should simplify gathering downstreams too
# XXX - downstream upgrades would require some sort order tracking
# XXX - need an "cwupgradable[${rname}]=(0|1)" flag instead of being version-based
# XXX - i.e., mark all downstreams upgradable, then upgrade-all
# XXX - cwcheckupgradable - if marked, yes; if not installed, no; otherwise check version diff and decide
# XXX - probably need an ignored list too - {bootstrap,}make, configgit, slibtool, etc. are "safe transitives"
#

set -eu

function cwfailexit() {
  echo "$(basename ${BASH_SOURCE[0]}): failed: ${@}" 1>&2
  exit 1
}

which crosware >/dev/null 2>&1 || cwfailexit "crosware program not found"

function cwsourcerecipes() {
  true
}

# return unique elements passed, preserving order
#   unused in this implementation but useful?
#   simplified version of https://github.com/ryanwoodsmall/shell-ish/blob/master/examples/uniqueify.bash
function cwuniqueargs() {
  declare -A seen
  local o=''
  for i in ${@} ; do
    : ${seen[${i}]:=0}
    if [ ${seen[${i}]} -eq 0 ] ; then
      o="${o} ${i}"
      seen[${i}]=1
    fi
  done
  o="${o# }"
  echo "${o}"
}

# ${#aa[@]} doesn't work to get a count of elements in a hash in some versions of bash?
function cwcountargs() {
  echo "${#}"
}


function cwrecipeexists() {
  test ${#} -lt 1 && return 1 || true
  cwsourcerecipes
  local r="${1}"
  : ${cwrecipes[${r}]:=0}
  if [ ${cwrecipes[${r}]} -eq 0 ] ; then
    unset cwrecipes[${r}]
    return 1
  fi
  true
}

# given a recipe name, expand its reqs
function cwexpandreq() {
  test ${#} -lt 1 && { echo '' ; return ; } || true
  cwsourcerecipes
  local r="${1}"
  cwrecipeexists "${r}" || { echo '' ; return ; } || true
  local sl=0
  local el=0
  declare -A qs
  for q in ${cwrecipereqs[${r}]} ; do
    qs[${q}]="${cwrecipereqs[${q}]}"
  done
  while true ; do
    sl="$(cwcountargs ${!qs[@]})"
    for q in ${!qs[@]} ; do
      for n in ${cwrecipereqs[${q}]} ; do
        : ${qs[${n}]:=${cwrecipereqs[${n}]}}
      done
    done
    el="$(cwcountargs ${!qs[@]})"
    if [ ${sl} -eq ${el} ] ; then
      break
    fi
  done
  cwrecipeexpandedreqs[${r}]="${!qs[@]}"
  echo "${cwrecipeexpandedreqs[${r}]}"
}

function cwexpandreqs() {
  if [ ${cwrecipereqsexpanded} -eq 1 ] ; then
    return
  fi
  for r in ${!cwrecipes[@]} ; do
    cwrecipeexpandedreqs[${r}]="$(cwexpandreq ${r})"
  done
  cwrecipereqsexpanded=1
}

function cwshowtransitives() {
  test ${#} -lt 1 && { echo '' ; return ; } || true
  cwsourcerecipes
  local r="${1}"
  cwrecipeexists "${r}" || { echo '' ; return ; } || true
  cwexpandreqs
  declare -A qs
  for q in ${cwrecipeexpandedreqs[${r}]} ; do
    qs[${q}]=1
  done
  for q in ${cwrecipereqs[${r}]} ; do
    unset qs[${q}]
  done
  echo "${!qs[@]}"
}

# fake out our associative arrays
declare -A cwrecipes cwrecipereqs cwrecipereqcount cwrecipeexpandedreqs
cwrecipereqsexpanded=0
for rr in $(crosware list-recipe-reqs | sed 's/ : /:/g;s/ /|/g' | tr -s ' ') ; do
  q=''
  r=''
  r="${rr%%:*}"
  q="${rr##*:}"
  q="${q//|/ }"
  cwrecipes[${r}]=1
  cwrecipereqs[${r}]="${q}"
  cwrecipereqcount[${r}]="$(cwcountargs ${q})"
done

# recipe list sorted by name
rs="$(echo ${!cwrecipes[@]} | tr ' ' '\n' | sort | paste -s -d' ' -)"

# recipe list sorted by number of requirements ascending
ls="$(for r in ${rs} ; do echo "${cwrecipereqcount[${r}]} ${r}" ; done | sort -n | cut -f2 -d' ')"

# XXX these should be similar
#diff -Naur \
#  <(for r in ${rs} ; do echo "${cwrecipereqcount[${r}]} : ${r} : ${cwrecipereqs[${r}]}" ; done | sort -n) \
#  <(for r in ${ls} ; do echo "${cwrecipereqcount[${r}]} : ${r} : ${cwrecipereqs[${r}]}" ; done)

if [[ ${#} -eq 0 ]] ; then
  cwexpandreqs
  for r in ${rs} ; do
    echo "${r} : ${cwrecipeexpandedreqs[${r}]}"
  done
elif [[ ${@} =~ -t ]] ; then
  cwexpandreqs
  for r in ${ls} ; do
    echo "${r} : ${cwrecipereqs[${r}]}"
    echo "  $(cwcountargs ${cwrecipereqs[${r}]}) : $(echo ${cwrecipereqs[${r}]} | tr ' ' '\n' | sort | paste -d' ' -s -)"
    echo "  $(cwcountargs ${cwrecipeexpandedreqs[${r}]}) : $(echo ${cwrecipeexpandedreqs[${r}]} | tr ' ' '\n' | sort | paste -d' ' -s -)"
    echo "  $(cwcountargs $(cwshowtransitives ${r})) : $(cwshowtransitives ${r} | tr ' ' '\n' | sort | paste -d' ' -s -)"
    echo
  done
else
  for i in ${@} ; do
    echo "${i} : $(cwexpandreq ${i})"
  done
fi
