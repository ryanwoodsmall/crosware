rname="automake"
rver="1.20"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/automake/${rfile}"
rsha256="00c0e397a3c0096b1b9167eb4a5ecb87a66fe50888d939c4e02111e603936570"
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
