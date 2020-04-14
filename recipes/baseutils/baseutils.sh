rname="baseutils"
rver="c94996162fd53f817fee09e424150a88bdf8677a"
rdir="baseutils-${rver}"
rfile="${rver}.zip"
#rurl="https://github.com/ibara/${rname}/archive/${rfile}"
rurl="https://github.com/ryanwoodsmall/${rname}/archive/${rfile}"
rsha256=""
rreqs="bmake bsdheaders"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's/make /\$(MAKE) /g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  bmake \
    PREFIX=\"${ridir}\" \
    MANDIR=\"${ridir}/share/man\" \
    LDFLAGS='-static' \
    CPPFLAGS= \
    CC=\"\${CC} -I${cwsw}/bsdheaders/current\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  bmake \
    install \
    PREFIX=\"${ridir}\" \
    MANDIR=\"${ridir}/share/man\" \
    LDFLAGS='-static' \
    CPPFLAGS= \
    CC=\"\${CC} -I${cwsw}/bsdheaders/current\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
