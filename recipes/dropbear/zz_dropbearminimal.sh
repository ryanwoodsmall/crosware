rname="dropbearminimal"
rver="$(cwver_dropbear)"
rdir="$(cwdir_dropbear)"
rbdir="$(cwbdir_dropbear)"
rfile="$(cwfile_dropbear)"
rdlfile="$(cwdlfile_dropbear)"
rurl="$(cwurl_dropbear)"
rsha256="$(cwsha256_dropbear)"
rreqs="bootstrapmake zlibng configgit"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

for f in clean fetch make ; do
  eval "function cw${f}_${rname}() { cw${f}_dropbear ; }"
done

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cat \"${cwdl}/${rname%minimal}/${rname%minimal}-\$(cwver_${rname})_localoptions.h\" > localoptions.h
  cat localoptions.h > localoptions.h.ORIG
  cwscriptecho 'patching localoptions.h'
  sed -i \"/PRIV/s#/opt/${rname%minimal}/etc#${cwetc}/${rname%minimal}#g\" localoptions.h
  sed -i \"s#/opt/${rname%minimal}#${rtdir}#g\" localoptions.h
  sed -i '/DROPBEAR_SMALL_CODE/s,0,1,g' localoptions.h
  sed -i s,2222,22222,g localoptions.h
  echo '#undef SFTPSERVER_PATH' >> localoptions.h
  echo '#define SFTPSERVER_PATH \"${rtdir}/current/libexec/sftp-server\"' >> localoptions.h
  ./configure \
    ${cwconfigureprefix} \
     --disable-lastlog \
     --disable-utmp \
     --disable-utmpx \
     --disable-wtmp \
     --disable-wtmpx \
     --disable-pututline \
     --disable-pututxline \
     --enable-bundled-libtom \
     --disable-pam \
     --enable-zlib \
     --enable-static \
       CC=\"\${CC} -Os -Wl,-s -I${cwsw}/zlibng/current/include\" \
       CFLAGS=\"\${CFLAGS} -Os -Wl,-s\" \
       CXXFLAGS=\"\${CXXFLAGS} -Os -Wl,-s\" \
       CPPFLAGS=\"-I${cwsw}/zlibng/current/include\" \
       LDFLAGS=\"-L${cwsw}/zlibng/current/lib -static -s\" \
       PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install \
    MULTI=1 \
    SCPPROGRESS=1 \
    PROGRAMS=\"dropbear dbclient dropbearkey dropbearconvert scp\"
  ln -sf dbclient \"\$(cwidir_${rname})/bin/ssh\"
  cwmkdir \"${cwetc}/${rname%minimal}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo '# ${rname}' > \"${rprof}\"
  echo 'append_path \"${rtdir%minimal}/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir%minimal}/current/sbin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
