rname="inadynlibressl"
rver="$(cwver_inadyn)"
rdir="$(cwdir_inadyn)"
rfile="$(cwfile_inadyn)"
rurl="$(cwurl_inadyn)"
rsha256=""
rreqs="make libressl libconfuse pkgconfig zlib"

. "${cwrecipe}/common.sh"

for f in clean fetch extract make patch ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%%libressl}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      --disable-mbedtls \
      --enable-openssl \
      --without-systemd \
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
  ln -sf \"${rname%%libressl}\" \"\$(cwidir_${rname})/sbin/${rname}\"
  ln -sf \"${rname%%libressl}\" \"\$(cwidir_${rname})/sbin/${rname%%libressl}-${rname##inadyn}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
