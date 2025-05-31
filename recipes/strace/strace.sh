rname="strace"
rver="6.15"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/strace/strace/releases/download/v${rver}/${rfile}"
rsha256="8552dfab08abc22a0f2048c98fd9541fd4d71b6882507952780dab7c7c512f51"
rreqs="make"

. "${cwrecipe}/common.sh"

# XXX - ugly hack to avoid signal/sigcontext redefs on arm64
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
