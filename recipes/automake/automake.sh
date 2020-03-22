rname="automake"
rver="1.16.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="ccc459de3d710e066ab9e12d2f119bd164a08c9341ca24ba22c9adaa179eedd0"
rreqs="make perl m4 autoconf sed"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=${cwsw}/perl/current/bin:${cwsw}/m4/current/bin:${cwsw}/autoconf/current/bin:\${PATH} ./configure ${cwconfigureprefix}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
