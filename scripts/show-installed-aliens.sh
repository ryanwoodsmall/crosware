#!/usr/bin/env bash
#
# show names of packages installed but unknown to crosware
#

if [ -z "${cwtop}" ] ; then
  cwtop="$(realpath $(dirname ${BASH_SOURCE[0]})/..)"
fi

declare -A installed

for i in ${cwtop}/var/inst/* ; do
  installed["$(basename ${i})"]=0
done

for r in $(${cwtop}/bin/crosware list-recipes | cut -f1 -d:) ; do
  installed["${r}"]=1
done

for a in ${!installed[@]} ; do
  if [ ${installed[${a}]} -eq 0 ] ; then
    echo ${a}
  fi
done | sort
