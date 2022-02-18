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
#

rname="opkg"
rver="0.5.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://git.yoctoproject.org/${rname}/snapshot/${rfile}"
rsha256="4e0ae527ca7059d472f7bc85c590d77ef09bbb34db4d79fb738123cccf4ec6fa"
rreqs="make autoconf automake libtool pkgconfig gpgme gnupg curl openssl libarchive xz bzip2 lz4 zstd configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH}\" \
    autoreconf -fiv -I./m4 \$(echo -I${cwsw}/{automake,libtool,pkgconfig}/current/share/aclocal)
  cwfixupconfig_${rname}
  env PATH=\"${cwsw}/curl/current/bin:${cwsw}/openssl/current/bin:${cwsw}/pkgconfig/current/bin:${cwsw}/gpgme/current/bin:${cwsw}/gnupg/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      --enable-{xz,bzip2,lz4,zstd,sha256,curl,ssl-curl,gpg} \
      --with-static-libopkg \
      --without-libsolv \
        PKG_CONFIG_{LIBDIR,PATH}=\"\${PKG_CONFIG_LIBDIR}:${cwsw}/libarchive/current/lib/pkgconfig\" \
        LIBS='-lassuan'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  cwmkdir \"${ridir}/etc/opkg\"
  touch \"${ridir}/etc/opkg/default.conf\"
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
