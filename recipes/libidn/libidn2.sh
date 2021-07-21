rname="libidn2"
rver="2.3.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/libidn/${rfile}"
rsha256="76940cd4e778e8093579a9d195b25fff5e936e9dc6242068528b437a76764f91"
rreqs="make libunistring"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --disable-nls --disable-doc
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  sed -i 's/-lidn2/-lidn2 -lunistring/g' \"${ridir}/lib/pkgconfig/${rname}.pc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
