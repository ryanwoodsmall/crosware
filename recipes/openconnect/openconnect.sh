#
# XXX - chromeos needs some love: https://scene-si.org/2015/06/01/openconnect-on-a-chromebook-without-crouton/
# XXX - make sure shill doesn't tear down the tun# interface...
# XXX - 3.8.1 renamed: GNUTLS_NO_EXTENSIONS -> GNUTLS_NO_DEFAULT_EXTENSIONS, remove patch when updated
#
rname="openconnect"
rver="9.12"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.infradead.org/${rname}/download/${rfile}"
rsha256="a2bedce3aa4dfe75e36e407e48e8e8bc91d46def5335ac9564fbf91bd4b2413e"
rreqs="make pkgconfig openssl libxml2 zlib xz lz4 slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetchcheck \"https://gitlab.com/openconnect/vpnc-scripts/-/raw/22756827315bc875303190abb3756b5b1dd147ce/vpnc-script\" \
    \"${cwdl}/${rname}/vpnc-script\" \
    \"46c0413e26f1d918d95755d323cf833bf1b7540400a3b75ebbb2ac4c906f7f7f\"
}
"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG s,-Wmissing-include-dirs,,g configure
  sed -i.ORIG s,GNUTLS_NO_EXTENSIONS,GNUTLS_NO_DEFAULT_EXTENSIONS,g gnutls-dtls.c
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/etc\"
  install -m 755 \"${cwdl}/${rname}/vpnc-script\" \"\$(cwidir_${rname})/etc/vpnc-script\"
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-docs \
    --disable-nls \
    --disable-silent-rules \
    --with-lz4 \
    --with-openssl \
    --with-system-cafile=\"${cwetc}/ssl/cert.pem\" \
    --with-vpnc-script=\"\$(cwidir_${rname})/etc/vpnc-script\" \
    --without-gnutls \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-lxml2 -llzma -lz -llz4'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
