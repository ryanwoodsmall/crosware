rname="mawk"
rver="1.3.4-20200120"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="7fd4cd1e1fae9290fe089171181bbc6291dfd9bca939ca804f0ddb851c8b8237"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CFLAGS=\"\${CFLAGS} \${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make install
  rm -f \"${ridir}/bin/awk\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/awk\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
