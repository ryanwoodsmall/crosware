rname="xz"
rver="5.6.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://tukaani.org/${rname}/${rfile}"
rurl="https://github.com/tukaani-project/xz/releases/download/v${rver}/${rfile}"
rsha256="0f5c81f14171b74fcc9777d302304d964e63ffc2d7b634ef023a7249d9b5d875"
rreqs="make slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-doc \
    --disable-nls \
      LIBTOOL=\"${cwsw}/slibtool/current/bin/slibtool-static -all-static\" \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
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
