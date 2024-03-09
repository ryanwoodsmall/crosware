rname="lunzip"
rver="1.14"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://download.savannah.gnu.org/releases/lzip/${rname}/${rfile}"
rsha256="70a30ca88c538b074a04a6d5fa12a57f8e89febcb9145d322e9525f3694e4cb0"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} CPPFLAGS=\"\" LDFLAGS=\"-static\" CC=\"\${CC}\" CFLAGS=\"\${CFLAGS}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
