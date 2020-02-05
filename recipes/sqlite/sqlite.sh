rname="sqlite"
rver="3310100"
rdir="${rname}-autoconf-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.sqlite.org/2020/${rfile}"
rsha256="62284efebc05a76f909c580ffa5c008a7d22a1287285d68b7825a2b6b51949ae"
rreqs="make ncurses readline zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --enable-readline
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
