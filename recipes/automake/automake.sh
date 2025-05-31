rname="automake"
rver="1.18"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/automake/${rfile}"
rsha256="af6043a5d4b3beef0c48161f4a6936259321cd101a34c1ab0768328515626c8a"
rreqs="make perl m4 autoconf sed"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=${cwsw}/perl/current/bin:${cwsw}/m4/current/bin:${cwsw}/autoconf/current/bin:\${PATH} ./configure ${cwconfigureprefix}
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
