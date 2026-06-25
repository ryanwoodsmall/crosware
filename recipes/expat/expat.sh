rname="expat"
rver="2.8.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/libexpat/libexpat/releases/download/R_${rver//./_}/${rfile}"
rsha256="ef7d1994f533c9e7343d6c19f31064fc8ebbcbcaa144be3812b4f43052a05f4c"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --without-docbook LDFLAGS=-static CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  sed -i \"s#\$(cwidir_${rname})#${rtdir}/current#g\" \"\$(cwidir_${rname})/lib/lib${rname}.la\" \"\$(cwidir_${rname})/lib/pkgconfig/${rname}.pc\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
