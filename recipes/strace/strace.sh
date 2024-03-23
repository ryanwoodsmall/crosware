rname="strace"
rver="6.8"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="ba6950a96824cdf93a584fa04f0a733896d2a6bc5f0ad9ffe505d9b41e970149"
rreqs="make"

. "${cwrecipe}/common.sh"

# XXX - ugly hack to avoid signal/sigcontext redefs on arm64
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --enable-mpers=no \
    --disable-gcc-Werror \
      CFLAGS=\"\${CFLAGS} -Dsigcontext_struct=sigcontext\" \
      CPPFLAGS= \
      LDFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  touch config.h
  if \$(uname -m | grep -q ^aarch64) ; then
    echo '#undef __ASM_SIGCONTEXT_H' >> src/config.h
    echo '#define __ASM_SIGCONTEXT_H 1' >> src/config.h
  fi
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
