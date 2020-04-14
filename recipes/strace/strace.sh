rname="strace"
rver="5.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="189968eeae06ed9e20166ec55a830943c84374676a457c9fe010edc7541f1b01"
rreqs="make"

. "${cwrecipe}/common.sh"

# XXX - ugly, non-working hack to avoid signal/sigcontext redefs on arm64
eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} --enable-mpers=no --disable-gcc-Werror CFLAGS=\"\${CFLAGS} -Dsigcontext_struct=sigcontext\"
  #if \$(uname -m | grep -q ^aarch64) ; then
  #  echo '#undefine HAVE_STRUCT_SIGCONTEXT' >> config.h
  #  echo '#define HAVE_STRUCT_SIGCONTEXT 1' >> config.h
  #fi
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} CFLAGS=\"\${CFLAGS} -Dsigcontext_struct=sigcontext\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
