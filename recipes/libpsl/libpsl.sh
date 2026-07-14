rname="libpsl"
rver="0.23.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/rockdaboot/libpsl/releases/download/${rver}/${rfile}"
rsha256="f39b9631b3d369a21259ea4654f8875c0ec6995ce9551c0eb5d423e4c011f911"
rreqs="make libidn2 libunistring python3"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  sed -i \"s,\$(cwidir_${rname}),${rtdir}/current,g\" \$(cwidir_${rname})/lib/pkgconfig/*.pc \$(cwidir_${rname})/lib/*.la
  cwmkdir \"\$(cwidir_${rname})/share/publicsuffix\"
  install -m 644 list/public_suffix_list.dat \"\$(cwidir_${rname})/share/publicsuffix/\"
  popd &>/dev/null
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
