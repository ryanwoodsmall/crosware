rname="linkslibressl"
rver="$(cwver_links)"
rdir="$(cwdir_links)"
rfile="$(cwfile_links)"
rurl="$(cwurl_links)"
rsha256=""
rreqs="make libevent zlib libressl xz bzip2 lzlib cacertificates"

. "${cwrecipe}/common.sh"

for f in clean fetch extract make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%%libressl}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env \
    PATH=\"${cwsw}/libressl/current/bin:\${PATH}\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    PKG_CONFIG_LIBDIR=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    PKG_CONFIG_PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      ./configure ${cwconfigureprefix} \
        --with-ssl=\"${cwsw}/libressl/current\" \
        --with-ipv6 \
        --disable-ssl-pkgconfig \
        --disable-graphics \
        --without-x
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf \"${rname%%libressl}\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rname%%libressl}\" \"${ridir}/bin/${rname%%libressl}-${rname##links}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
