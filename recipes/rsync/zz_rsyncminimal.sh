rname="rsyncminimal"
rver="$(cwver_rsync)"
rdir="$(cwdir_rsync)"
rfile="$(cwfile_rsync)"
rdlfile="$(cwdlfile_rsync)"
rurl="$(cwurl_rsync)"
rsha256="$(cwsha256_rsync)"
rreqs="bootstrapmake busybox"

. "${cwrecipe}/common.sh"

for f in fetch clean extract patch make ; do
  eval "function cw${f}_${rname}() { cw${f}_${rname%minimal} ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    --with-included-popt \
    --with-included-zlib \
    --enable-ipv6 \
    --disable-acl-support \
    --disable-md5-asm \
    --disable-roll-asm \
    --disable-roll-simd \
    --disable-lz4 \
    --disable-openssl \
    --disable-xattr-support \
    --disable-xxhash \
    --disable-zstd \
      CFLAGS=\"\${CFLAGS} -DINET6 -Os -g0 -Wl,-s\" \
      LDFLAGS=\"-static -s\" \
      SED=\"${cwsw}/busybox/current/bin/sed\" \
      AWK=\"${cwsw}/busybox/current/bin/awk\" \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  ln -sf rsync \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf rsync \"\$(cwidir_${rname})/bin/rsync-minimal\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/rsync\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/rsync/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
