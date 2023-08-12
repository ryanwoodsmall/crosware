#
# XXX - separate out conf into ${cwtop}/etc/opkg?
# XXX - provide a binary archive so opkg itself doesn't have to be bootstrapped...
# XXX - libsolv support - it needs cmake though, ugh
# XXX - state directory - var/opkg?
# XXX - local repo?
# XXX - per recipe cw{create,install}binpkg_${rname}
# XXX - compression type?
# XXX - gpg signing/distribution?
# XXX - building packages by hand: https://raymii.org/s/tutorials/Building_IPK_packages_by_hand.html
# XXX - workstation repo: https://jumpnowtek.com/yocto/Using-your-build-workstation-as-a-remote-package-repository.html
# XXX - private repo: https://jumpnowtek.com/yocto/Managing-a-private-opkg-repository.html
# XXX - opkg presentation: https://elinux.org/images/2/24/Opkg_debians_little_cousin.pdf
# XXX - curl -latomic fix
# XXX - bringing in mbedtls for some reason?
#

rname="opkg"
rver="0.6.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://git.yoctoproject.org/${rname}/snapshot/${rfile}"
rsha256="126fe62286e72e85539cf67bfc6941b1764e8c79df982a11a84511aa8e19ed4b"
rreqs="make autoconf automake libtool pkgconfig gpgme gnupg curl openssl libarchive xz bzip2 lz4 zstd configgit slibtool libassuan zlib libssh2 expat libmd libbsd acl nghttp2 lzo mbedtls"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH}\" \
    autoreconf -fiv -I./m4 \$(echo -I${cwsw}/{automake,libtool,pkgconfig}/current/share/aclocal)
  cwfixupconfig_${rname}
  env PATH=\"${cwsw}/curl/current/bin:${cwsw}/openssl/current/bin:${cwsw}/pkgconfig/current/bin:${cwsw}/gpgme/current/bin:${cwsw}/gnupg/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      --enable-{xz,bzip2,lz4,zstd,sha256,curl,ssl-curl,gpg} \
      --with-static-libopkg \
      --without-libsolv \
        CFLAGS=\"\${CFLAGS} -g0 -Wl,-s -Os\" \
        CXXFLAGS=\"\${CXXFLAGS} -g0 -Wl,-s -Os\" \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        LIBS='-lassuan'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  cwmkdir \"\$(cwidir_${rname})/etc/opkg\"
  touch \"\$(cwidir_${rname})/etc/opkg/default.conf\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

# echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
# echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
