rname="libmetalink"
rver="0.1.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/metalink-dev/${rname}/releases/download/release-${rver}/${rfile}"
rsha256="86312620c5b64c694b91f9cc355eabbd358fa92195b3e99517504076bf9fe33a"
rreqs="make sed expat configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --with-libexpat --without-libxml2
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
