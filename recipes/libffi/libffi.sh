rname="libffi"
rver="3.5.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/libffi/libffi/releases/download/v${rver}/${rfile}"
rsha256="f99eb68a67c7d54866b7706af245e87ba060d419a062474b456d3bc8d4abdbd1"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} LDFLAGS=-static CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}=
  sed -i.ORIG 's/__gnu_linux__/__linux__/g' src/closures.c
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
