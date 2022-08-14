rname="gpgme"
rver="1.18.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/gpgme/${rfile}"
rsha256="361d4eae47ce925dba0ea569af40e7b52c645c4ae2e65e5621bf1b6cdd8b0e9e"
rreqs="make gnupg libgpgerror libgcrypt libksba libassuan npth ntbtls sqlite readline ncurses slibtool zlib bzip2 pkgconfig pinentry configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/gnupg/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --with-libgpg-error-prefix=\"${cwsw}/libgpgerror/current\" \
      --with-libassuan-prefix=\"${cwsw}/libassuan/current\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/gnupg/current/bin:\${PATH}\" \
    make -j${cwmakejobs} ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/gnupg/current/bin:\${PATH}\" \
    make install ${rlibtool}
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
