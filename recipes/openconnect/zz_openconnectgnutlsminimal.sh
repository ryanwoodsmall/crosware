rname="openconnectgnutlsminimal"
rver="$(cwver_openconnect)"
rdir="$(cwdir_openconnect)"
rfile="$(cwfile_openconnect)"
rdlfile="$(cwdlfile_openconnect)"
rurl="$(cwurl_openconnect)"
rsha256=""
rreqs="make pkgconfig gnutlsminimal nettleminimal libxml2 zlib xz lz4 slibtool"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

local f
for f in clean fetch extract patch make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_openconnect
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/etc\"
  install -m 755 \"${cwdl}/${rname%gnutlsminimal}/vpnc-script\" \"\$(cwidir_${rname})/etc/vpnc-script\"
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-docs \
    --disable-nls \
    --disable-silent-rules \
    --with-gnutls \
    --with-lz4 \
    --with-system-cafile=\"${cwetc}/ssl/cert.pem\" \
    --with-vpnc-script=\"\$(cwidir_${rname})/etc/vpnc-script\" \
    --without-openssl \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-lgnutls -lhogweed -lnettle -lxml2 -llzma -lz -llz4'
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  ln -sf ${rname%gnutlsminimal} \"\$(cwidir_${rname})/sbin/${rname%minimal}\"
  ln -sf ${rname%gnutlsminimal} \"\$(cwidir_${rname})/sbin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
