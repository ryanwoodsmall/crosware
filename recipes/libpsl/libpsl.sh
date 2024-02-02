rname="libpsl"
rver="0.21.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/rockdaboot/libpsl/releases/download/${rver}/${rfile}"
rsha256="1dcc9ceae8b128f3c0b3f654decd0e1e891afc6ff81098f227ef260449dae208"
rreqs="make libidn2 libunistring python3"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/python3/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --enable-builtin \
      --enable-runtime=libidn2 \
      --disable-gtk-doc \
      --disable-nls \
        PYTHON=\"${cwsw}/python3/current/bin/python3\" \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  sed -i \"s,\$(cwidir_${rname}),${rtdir}/current,g\" \$(cwidir_${rname})/lib/pkgconfig/*.pc \$(cwidir_${rname})/lib/*.la
  cwmkdir \"\$(cwidir_${rname})/share/publicsuffix\"
  install -m 644 list/public_suffix_list.dat \"\$(cwidir_${rname})/share/publicsuffix/\"
  popd >/dev/null 2>&1
}
"

#eval "
#function cwgenprofd_${rname}() {
#  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
#  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
#  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
#  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
#}
#"
