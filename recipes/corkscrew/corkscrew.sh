rname="corkscrew"
rver="2.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/corkscrew/${rfile}"
rsha256="0d0fcbb41cba4a81c4ab494459472086f377f9edb78a2e2238ed19b58956b0be"
rreqs="bootstrapmake configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env LDFLAGS=-static CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}= ./configure ${cwconfigureprefix}
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
