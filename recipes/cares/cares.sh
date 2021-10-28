rname="cares"
rver="1.18.1"
rdir="c-ares-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/c-ares/c-ares/releases/download/${rname}-${rver//./_}/${rfile}"
rsha256="1a7d52a8a84a9fbffb1be9133c0f6e17217d91ea5a6fa61f6b4729cda78ebbcf"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --disable-tests \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_LIBDIR= \
      PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local p
  make install ${rlibtool}
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man1\"
  for p in a{country,dig,host} ; do
    install -m 0755 src/tools/\${p} \"${ridir}/bin/\${p}\"
    \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/bin/\${p}\"
    install -m 0644 docs/\${p}.1 \"${ridir}/share/man/man1/\${p}.1\"
  done
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

#  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
#  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
#  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
