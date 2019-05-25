#!/bin/bash
#
# XXX - tinkering
#
# ideas:
# - undeclared req detection
#   - sum of all subreqs must equal sum of reqs
#   - i.e., sed(2)->busybox(1)+toybox(1)
#           busybox(1)->make(0)
#           toybox(1)->make(0)
# - recipe expansion
#   - map/reduce-y?
#   - recurisve?
#   - iterative?
#   - stack?
# - loop detection
#   - if stack, see if element checking already exists
# - slow
#   - memozation is probably key but arrays/maps are slow/big
# - stop words?
#   - tried commas, confusing
# - this is like a parser type problem... not a bash one
# - dependency model?
#   - might be easier...
#   - for each recipe, find recipes that require us
# - doing things that are against the nature of the universe
# - gah
#

set -eu

: ${CW_GIT_CMD:="jgitsh"}

cwdir="$(cd $(dirname ${BASH_SOURCE[0]})/.. ; pwd)"
cw="${cwdir}/bin/crosware"
if [ ! -e ${cw} ] ; then
  echo "crosware not found"
  exit 1
fi

declare -A cwreqs
cwrecipes=( $(${cw} list-recipes | xargs echo) )
for r in ${cwrecipes[@]} ; do
  cwreqs["${r}"]=''
done
unset r

for rf in ${cwdir}/recipes/*/*.sh ; do
  rn="$(grep ^rname= ${rf} | head -1 | cut -f2 -d= | tr -d '"')"
  rr="$(grep ^rreqs= ${rf} | head -1 | cut -f2 -d= | tr -d '"')"
  cwreqs["${rn}"]="$(eval eval echo ${rr})"
done
unset rn rr

declare -A cwreqsexp
declare -A cwreqscount
declare -A cwexpreqs
for r in ${!cwreqs[@]} ; do
  eval "
  function cwlistreqs_${r}() {
    echo "${cwreqs[${r}]}" | tr -d ',' | tr -s ' ' | sed 's/^ //g;s/ $//g'
  }
  "
  cwreqscount["${r}"]="$(cwlistreqs_${r} | tr ' ' '\n' | grep -v '^$' | sort -u | wc -l)"
  if [ ${cwreqscount[${r}]} -eq 0 ] ; then
    cwreqsexp["${r}"]=1
  else
    cwreqsexp["${r}"]=0
  fi
  cwexpreqs["${r}"]="${cwreqs[${r}]}"
done
unset r

#recipestack=""
#local rstack+=" ${r}"
# cwchasereqs "${s}"
# if $(echo ${rstack} | tr ' ' '\n' | sort -u | grep -q "^${r}$" ...
function cwchasereqs() {
  local r="${1}"
  if [ ${cwreqsexp[${r}]} -eq 1 ] ; then
    echo "${r} req expanded"
  else
    local s=''
    for s in ${cwexpreqs[${r}]} ; do
      echo "${r} req not expanded, need to recursively expand and check for loop"
      if [ ${cwreqsexp[${s}]} -eq 1 ] ; then
        continue
      else
        cwchasereqs "${s}"
      fi
    done
    unset s
  fi
  unset r
}

for r in ${!cwreqs[@]} ; do
  echo "${r} : ${cwreqs[${r}]} : ${cwreqscount[${r}]}"
done

#for r in ${!cwreqs[@]} ; do
#  if [ ${cwreqscount[${r}]} -lt 2 ] ; then
#    cwchasereqs "${r}"
#  fi
#done
#unset r
#
#for r in ${!cwreqs[@]} ; do
#  echo "${r} : ${cwreqs[${r}]} : ${cwreqscount[${r}]} : ${cwreqsexp[${r}]}"
#done
#unset r
#echo "bash : $(cwlistreqs_bash)"
#echo "zulu : $(cwlistreqs_zulu)"
#echo "bash4 : $(cwlistreqs_bash4)"
#declare -A cwreqcounts
#
#for c in ${!cwreqcounts[@]} ; do
#  #echo "${cwreqcounts[${c}]} : ${c}"
#  :
#done
#unset c
