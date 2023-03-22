rname="inadyngnutlsminimal"
rver="$(cwver_inadyn)"
rdir="$(cwdir_inadyn)"
rfile="$(cwfile_inadyn)"
rurl="$(cwurl_inadyn)"
rsha256=""
rreqs="make libconfuse pkgconfig zlib gnutlsminimal nettleminimal"

. "${cwrecipe}/common.sh"

for f in clean fetch extract make patch ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%%gnutlsminimal}
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
      --disable-openssl \
      --without-systemd \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        LIBS='-lz -lgnutls -lhogweed -lnettle -static'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf \"${rname%%gnutlsminimal}\" \"\$(cwidir_${rname})/sbin/${rname}\"
  ln -sf \"${rname%%gnutlsminimal}\" \"\$(cwidir_${rname})/sbin/${rname%%gnutlsminimal}-${rname##inadyn}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
