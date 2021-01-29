rname="autoconf"
rver="2.71"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="f14c83cfebcc9427f2c3cea7258bd90df972d92eb26752da4ddad81c87a0faa4"
rreqs="make perl m4 sed configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=${cwsw}/perl/current/bin:${cwsw}/m4/current/bin:\${PATH} ./configure ${cwconfigureprefix}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
