rname="libksba"
rver="1.6.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="cf72510b8ebb4eb6693eef765749d83677a03c79291a311040a5bfd79baab763"
rreqs="make libgpgerror slibtool configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-libgpg-error-prefix=\"\${cwsw}/libgpgerror/current/\" \
      CPPFLAGS='-I${cwsw}/libgpgerror/current/include' \
      LDFLAGS='-L${cwsw}/libgpgerror/current/lib' \
      PKG_CONFIG_{LIBDIR,PATH}='${cwsw}/libgpgerror/current/lib/pkgconfig'
  popd &>/dev/null
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
