rname="bootstrapmake"
rver="4.2.1"
rdir="${rname//bootstrap/}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname//bootstrap/}/${rfile}"
rsha256="e40b8f018c1da64edd1cc9a6fce5fa63b2e707e404e20cad91fbae337c98a5b7"
rreqs="configgit"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --disable-load CPPFLAGS= LDFLAGS='-static -s'
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  bash ./build.sh
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./make install-binPROGRAMS
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/make/current/bin\"' > "${rprof}"
  echo 'append_path \"${rtdir}/current/bin\"' >> "${rprof}"
}
"
