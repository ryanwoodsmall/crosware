rname="libffi"
rver="3.2.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="ftp://sourceware.org/pub/${rname}/${rfile}"
rsha256="d06ebb8e1d9a22d19e38d63fdb83954253f39bedc5d46232a05645685722ca37"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
  sed -i.ORIG 's/__gnu_linux__/__linux__/g' src/closures.c
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
