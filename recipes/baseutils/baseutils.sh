#
# XXX - no riscv64 machine support in arch/uname (yet)
#

rname="baseutils"
rver="c94996162fd53f817fee09e424150a88bdf8677a"
rdir="baseutils-${rver}"
rfile="${rver}.zip"
#rurl="https://github.com/ibara/${rname}/archive/${rfile}"
rurl="https://github.com/ryanwoodsmall/${rname}/archive/${rfile}"
rsha256=""
rreqs="bmake libbsd pkgconfig"
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
  grep -ril 'sys/cdefs' . | xargs sed -i.ORIG 's#sys/cdefs#bsd/sys/cdefs#g'
  grep -ril 'sys/queue' . | xargs sed -i.ORIG 's#sys/queue#bsd/sys/queue#g'
  sed -i.ORIG 's/SIMPLEQ/STAILQ/g' paste/paste.c
  if [[ ${karch} =~ riscv64 ]] ; then
    sed -i.ORIG '/-C arch/d;/-C uname/d' Makefile
  fi
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \"${cwsw}/bmake/current/bin/bmake\" \
    PREFIX=\"${ridir}\" \
    MANDIR=\"${ridir}/share/man\" \
    LDFLAGS=\"\$(pkg-config --libs libbsd) -static\" \
    CPPFLAGS=\"\$(pkg-config --cflags libbsd)\" \
    CC=\"\${CC} \$(pkg-config --cflags libbsd)\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \"${cwsw}/bmake/current/bin/bmake\" \
    install \
    PREFIX=\"${ridir}\" \
    MANDIR=\"${ridir}/share/man\" \
    LDFLAGS=\"\$(pkg-config --libs libbsd) -static\" \
    CPPFLAGS=\"\$(pkg-config --cflags libbsd)\" \
    CC=\"\${CC} \$(pkg-config --cflags libbsd)\"
  find \"${ridir}/\" -type f -exec chmod u+rw {} +
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
