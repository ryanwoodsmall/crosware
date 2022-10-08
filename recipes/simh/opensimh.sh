#
# XXX - uses a github commit, download every time
# XXX - pcre and libedit? not sure it's worth it?
# XXX - libedit has a bunch of duplicate symbols
#
rname="opensimh"
rver="7b494542efdd0c74eec220a627b909200814c798"
rdir="simh-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/open-simh/simh/archive/${rfile}"
rsha256=""
rreqs="bootstrapmake"

. "${cwrecipe}/simh/simh.sh.common"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local TMPCC=\"\${CC} \${CFLAGS} -g0 -Os -Wl,-s -I. -D_LARGEFILE64_SOURCE -static\"
  cwscriptecho \"TMPCC = \${TMPCC}\"
  make -j${cwmakejobs} all alpha \
    TESTS=0 \
    CC=\"\${TMPCC}\" \
    LDFLAGS=\"-static -s\" \
    CFLAGS= \
    CPPFLAGS= \
    CXXFLAGS=
  popd >/dev/null 2>&1
}
"
