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
rreqs="bmake libbsd pkgconf"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG 's/make /\$(MAKE) /g' Makefile
  grep -ril 'sys/cdefs' . | xargs sed -i.ORIG 's#sys/cdefs#bsd/sys/cdefs#g'
  grep -ril 'sys/queue' . | xargs sed -i.ORIG 's#sys/queue#bsd/sys/queue#g'
  sed -i.ORIG 's/SIMPLEQ/STAILQ/g' paste/paste.c
  if [[ \${karch} =~ riscv64 ]] ; then
    sed -i.ORIG '/-C arch/d;/-C uname/d' Makefile
  fi
  sed -i 's/-o maketab/-o maketab -static/g' awk/Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  export PKG_CONFIG=\"${cwsw}/pkgconf/current/bin/pkgconf\"
  \"${cwsw}/bmake/current/bin/bmake\" \
    PREFIX=\"\$(cwidir_${rname})\" \
    MANDIR=\"\$(cwidir_${rname})/share/man\" \
    LDFLAGS=\"\$(\${PKG_CONFIG} --libs libbsd) -static\" \
    CPPFLAGS=\"\$(\${PKG_CONFIG} --cflags libbsd)\" \
    CC=\"\${CC} \$(\${PKG_CONFIG} --cflags libbsd)\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  export PKG_CONFIG=\"${cwsw}/pkgconf/current/bin/pkgconf\"
  \"${cwsw}/bmake/current/bin/bmake\" \
    install \
    PREFIX=\"\$(cwidir_${rname})\" \
    MANDIR=\"\$(cwidir_${rname})/share/man\" \
    LDFLAGS=\"\$(\${PKG_CONFIG} --libs libbsd) -static\" \
    CPPFLAGS=\"\$(\${PKG_CONFIG} --cflags libbsd)\" \
    CC=\"\${CC} \$(\${PKG_CONFIG} --cflags libbsd)\"
  find \"\$(cwidir_${rname})/\" -type f -exec chmod u+rw {} +
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo -n '' > \"${rprof}\"
  echo 'append_path \"${cwsw}/bison/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/byacc/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/flex/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/reflex/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
