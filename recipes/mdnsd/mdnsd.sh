rname="mdnsd"
rver="0.11"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/troglobit/${rname}/releases/download/v${rver}/${rfile}"
rsha256="285fbb58eef25002726cf662a5621f1de93226f38dd949700d2a409294523a9a"
rreqs="make slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --without-systemd \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
