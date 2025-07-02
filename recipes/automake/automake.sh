rname="automake"
rver="1.18.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/automake/${rfile}"
rsha256="63e585246d0fc8772dffdee0724f2f988146d1a3f1c756a3dc5cfbefa3c01915"
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
