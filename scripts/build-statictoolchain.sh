#!/usr/bin/env bash

#
# build a native statictoolchain package
#

set -eu

export TS="$(date '+%Y%m%d%H%M')"

: ${EXTRA_MAKE_ARGS:=""}

st="$(date)"

logfile="/tmp/musl-cross-make.out"
echo "logging to ${logfile}"
echo "started: ${st}" >${logfile}

source /etc/profile
source /usr/local/crosware/etc/profile

echo "installing prerequisites"
crosware check-installed ccache || crosware install ccache >>${logfile} 2>&1
source /usr/local/crosware/etc/profile
for r in patch diffutils binutils git rsync ; do
  echo installing ${r}
  ( time ( crosware check-installed ${r} || crosware install ${r} ) ) >>${logfile} 2>&1
  source /usr/local/crosware/etc/profile
done
source /usr/local/crosware/etc/profile

cd ${cwtop}/tmp/
pwd

echo "cloning/updating musl-cross-make"
export GIT_SSL_NO_VERIFY=1
export mcmd="musl-cross-make"
if [ ! -e ${mcmd} ] ; then
  git clone https://github.com/richfelker/musl-cross-make.git >>${logfile} 2>&1
else
  pushd ${mcmd} >/dev/null 2>&1
  git pull >>${logfile} 2>&1
  popd >/dev/null 2>&1
fi
cd ${mcmd}

echo "getting Makefile.arch_indep"
curl -fkLO https://raw.githubusercontent.com/ryanwoodsmall/musl-misc/master/musl-cross-make-confs/Makefile.arch_indep

echo "building compiler"
( date ; time ( make -f Makefile.arch_indep ${EXTRA_MAKE_ARGS} ; echo $? ) ; date ) >>${logfile} 2>&1

et="$(date)"
echo "finished: ${et}" >>${logfile}

echo "started: ${st}"
echo "finished: ${et}"
