rname="libuv"
rver="1.50.0"
rdir="${rname}-${rver}"
rfile="${rname}-v${rver}-dist.tar.gz"
rurl="https://dist.libuv.org/dist/v${rver}/${rfile}"
rsha256="c42c51d4e630f95dcefcafff95bf003ea52939e312d5e6584e7d9e102ead3e9e"
rreqs="make slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
