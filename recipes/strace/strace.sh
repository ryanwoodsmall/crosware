rname="strace"
rver="5.19"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="aa3dc1c8e60e4f6ff3d396514aa247f3c7bf719d8a8dc4dd4fa793be786beca3"
rreqs="make"

. "${cwrecipe}/common.sh"

# XXX - ugly hack to avoid signal/sigcontext redefs on arm64
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} --enable-mpers=no --disable-gcc-Werror CFLAGS=\"\${CFLAGS} -Dsigcontext_struct=sigcontext\"
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
