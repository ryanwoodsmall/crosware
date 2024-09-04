rname="cares"
rver="1.33.1"
rdir="c-ares-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/c-ares/c-ares/releases/download/v${rver}/${rfile}"
rsha256="06869824094745872fa26efd4c48e622b9bd82a89ef0ce693dc682a23604f415"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --disable-tests \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_LIBDIR= \
      PKG_CONFIG_PATH=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  local p
  make install ${rlibtool}
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  for p in a{dig,host} ; do
    install -m 0755 src/tools/\${p} \"\$(cwidir_${rname})/bin/\${p}\"
    \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/\${p}\"
    install -m 0644 docs/\${p}.1 \"\$(cwidir_${rname})/share/man/man1/\${p}.1\"
  done
  popd &>/dev/null
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
