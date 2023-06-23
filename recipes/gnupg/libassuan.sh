rname="libassuan"
rver="2.5.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="e9fd27218d5394904e4e39788f9b1742711c3e6b41689a31aa3380bd5aa4f426"
rreqs="make libgpgerror slibtool configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-libgpg-error-prefix=\"\${cwsw}/libgpgerror/current/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
