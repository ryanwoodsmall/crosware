rname="rsyncminimal"
rver="$(cwver_rsync)"
rdir="$(cwdir_rsync)"
rfile="$(cwfile_rsync)"
rdlfile="$(cwdlfile_rsync)"
rurl="$(cwurl_rsync)"
rsha256=""
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

for f in fetch clean extract make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%minimal}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-included-popt \
    --with-included-zlib \
    --enable-ipv6 \
    --disable-acl-support \
    --disable-asm \
    --disable-lz4 \
    --disable-openssl \
    --disable-simd \
    --disable-xattr-support \
    --disable-xxhash \
    --disable-zstd \
      CFLAGS=\"\${CFLAGS} -DINET6\" \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf rsync \"${ridir}/bin/${rname}\"
  ln -sf rsync \"${ridir}/bin/rsync-minimal\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/bin/rsync\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/rsync/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
