rname="libpsl"
rver="0.23.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/rockdaboot/libpsl/releases/download/${rver}/${rfile}"
rsha256="93941f85a1e7bd593fa94f299233cb5dfc91cd144fd9a78a6ceb75001c5b03be"
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
