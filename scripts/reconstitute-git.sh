#!/usr/bin/env bash
#
# (re)create crosware .git dir
#

set -eu

: ${CW_GIT_CMD:="git"}
: ${cwtop:="/usr/local/crosware"}
: ${giturl:="https://github.com/ryanwoodsmall/crosware.git"}
: ${gitbranch:="master"}
: ${g:=".git"}

TS="$(date +%Y%m%d%H%M%S)"
gitcmd="${CW_GIT_CMD}"
c="${g}/config"
b="${c}.PRE-${TS}"

function failexit() {
  echo "${BASH_SOURCE[0]}: ${@}"
  exit 1
}

which ${CW_GIT_CMD} >/dev/null 2>&1 || failexit "no ${CW_GIT_CMD}"
test -e "${cwtop}" || failexit "no ${cwtop} directory"

pushd "${cwtop}" >/dev/null 2>&1
test -e "${g}" && mv "${g}" "${g}.PRE-${TS}" || true
"${gitcmd}" clone --bare --branch "${gitbranch}" "${giturl}" "${g}"
cat "${c}" > "${b}"
# XXX - ugh, path of least resistance here
#sed -i 's/bare.*=.*true/bare = false/g' "${c}"
#sed -i '/fetch.*=.*/s,fetch.*,fetch = +refs/heads/*:refs/remotes/origin/*,g' "${c}"
cat >"${c}.new"<<EOF
[core]
|repositoryformatversion = 0
|filemode = true
|bare = false
|logallrefupdates = false
[remote "origin"]
|url = ${giturl}
|fetch = +refs/heads/*:refs/remotes/origin/*
[branch "${gitbranch}"]
|remote = origin
|merge = refs/heads/${gitbranch}
EOF
tr '|' '\t' < "${c}.new" > "${c}"
rm -f "${c}.new"
"${gitcmd}" fetch origin
"${gitcmd}" reset "origin/${gitbranch}" --hard
"${gitcmd}" checkout "${gitbranch}"
"${gitcmd}" status
popd >/dev/null 2>&1
