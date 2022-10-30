rname="strace"
rver="6.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="92d720a666855e9f1c6a11512fd6e99674a82bbfe1442557815f2ce8e1293338"
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
