rname="gpgme"
rver="1.17.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/gpgme/${rfile}"
rsha256="4ed3f50ceb7be2fce2c291414256b20c9ebf4c03fddb922c88cda99c119a69f5"
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
