rname="libite"
rver="2.6.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/libite/releases/download/v${rver}/${rfile}"
rsha256="83a439237528388fe3134f1b96524fb6c350c7881032e2f7d9b0b85570eedfdf"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --disable-doxygen-doc \
      {CPP,LD}FLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
