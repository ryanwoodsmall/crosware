rname="xz"
rver="5.8.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/tukaani-project/xz/releases/download/v${rver}/${rfile}"
#rurl="https://tukaani.org/${rname}/${rfile}"
#rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="507825b599356c10dca1cd720c9d0d0c9d5400b9de300af00e4d1ea150795543"
rreqs="make slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat Makefile.in > Makefile.in.ORIG
  sed -i '/DIRS/s, po, ,g' Makefile.in
  sed -i '/DIRS/s, tests, ,g' Makefile.in
  rm -rf ./po/ ./tests/
  mkdir -p po tests
  touch po/Makefile.in.in
  touch tests/Makefile.in
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-doc \
    --disable-nls \
      LIBTOOL=\"${cwsw}/slibtool/current/bin/slibtool-static -all-static\" \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
