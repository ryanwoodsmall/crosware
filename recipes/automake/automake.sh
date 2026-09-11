rname="automake"
rver="1.19"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/automake/${rfile}"
rsha256="79e8b1f7a967e87ce8a9ded76bee7f793d0ce1886ab2002feb1b0510f578b75a"
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
