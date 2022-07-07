#
# XXX - sftp-server is messy - split out into a standalone recipe?
#
# dropbear supports dss, ecdsa, ed25519, and rsa keys
#
# generate a bunch of test keys in multiple formats
#   for t in $(dropbearkey -h 2>&1 | sed -n '/^-t/,/^-f/!d;/^-/d;p') ; do
#     e=''
#     d=${cwtop}/tmp/id_dropbear.${t}
#     s=${d//dropbear/openssh}
#     echo ${t} : ${d} : ${a}
#     test ${t} == rsa && e='-s 4096'
#     test ${t} == ecdsa && e='-s 521'
#     dropbearkey -t ${t} ${e} -f ${d}
#     dropbearkey -y -f ${d} | egrep -v '^(Public key.*:|Fingerprint:)' > ${s}_pub
#     dropbearconvert dropbear openssh ${d} ${s}
#     echo
#   done
#
# key conversion/pubkey reclamation between openssh/dropbear is something like...
#   dropbearconvert openssh dropbear ~/.ssh/id_rsa ~/.ssh/id_dropbear
#
# convert dropbear rsa key to openssh and write a pub key
#   dropbearconvert dropbear openssh ~/.ssh/id_dropbear ~/.ssh/id_rsa
#   dropbearkey -y -f ~/.ssh/id_dropbear | egrep -v '^(Public key.*:|Fingerprint:)' > ~/.ssh/id_rsa.pub
#
rname="dropbear"
rver="2022.82"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
#rurl="https://matt.ucc.asn.au/${rname}/releases/${rfile}"
#rurl="https://dropbear.nl/mirror/releases/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="3a038d2bbc02bf28bbdd20c012091f741a3ec5cbe460691811d714876aad75d1"
# need a patch program, try toybox
rreqs="make toybox zlib configgit"

. "${cwrecipe}/common.sh"

lshver="2.1"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetch \
    \"https://raw.githubusercontent.com/ryanwoodsmall/${rname}-misc/master/options/${rname}-\$(cwver_${rname})_localoptions.h\" \
    \"${cwdl}/${rname}/${rname}-\$(cwver_${rname})_localoptions.h\"
  cwfetch_nettle
  cwfetchcheck \"https://ftp.gnu.org/pub/gnu/lsh/lsh-${lshver}.tar.gz\" \"${cwdl}/lsh/lsh-${lshver}.tar.gz\" \"8bbf94b1aa77a02cac1a10350aac599b7aedda61881db16606debeef7ef212e3\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  cwextract \"\$(cwdlfile_nettle)\" \"\$(cwbdir_${rname})\"
  cwextract \"${cwdl}/lsh/lsh-${lshver}.tar.gz\" \"\$(cwbdir_${rname})\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cat \"${cwdl}/${rname}/${rname}-\$(cwver_${rname})_localoptions.h\" > localoptions.h
  cat localoptions.h >> localoptions.h.ORIG
  cwscriptecho 'patching localoptions.h'
  sed -i \"/PRIV/s#/opt/${rname}/etc#${cwetc}/${rname}#g\" localoptions.h
  sed -i \"s#/opt/${rname}#${rtdir}#g\" localoptions.h
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
      CC=\"\${CC}\" LDFLAGS=\"\${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} \
    MULTI=1 \
    SCPPROGRESS=1 \
    PROGRAMS=\"dropbear dbclient dropbearkey dropbearconvert scp\"
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
  cwmkdir \"${cwetc}/${rname}\"
  popd >/dev/null 2>&1
  cwmakeinstall_sftpserver_${rname}
}
"

eval "
function cwmakeinstall_sftpserver_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cd \"\$(cwdir_nettle)\"
  ./configure \
    ${cwconfigurelibopts} \
    --prefix=\"\$(cwbdir_${rname})/sftp-server\" \
    --libdir=\"\$(cwbdir_${rname})/sftp-server/lib\" \
    --disable-assembler \
    --disable-documentation \
    --disable-openssl \
    --enable-mini-gmp \
      LDFLAGS=-static \
      CPPFLAGS=
  make -j${cwmakejobs}
  make install
  cd -
  cd lsh-${lshver}/src/sftp
  ./configure --prefix=\"\$(cwbdir_${rname})/sftp-server\" \
    LDFLAGS=\"-L\$(cwbdir_${rname})/sftp-server/lib -static\" \
    CPPFLAGS=\"-I\$(cwbdir_${rname})/sftp-server/include\"
  make -j${cwmakejobs}
  make install
  cd -
  cwmkdir \"\$(cwidir_${rname})/libexec\"
  install -m 0755 \"\$(cwbdir_${rname})/sftp-server/sbin/sftp-server\" \"\$(cwidir_${rname})/libexec/\"
  popd >/dev/null 2>&1
}
"

# XXX - hmm
eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rbdir}\"
  popd >/dev/null 2>&1
  if [ -e \"${rtdir}/etc\" ] ; then
    test -e \"${cwetc}/${rname}\" || cwmkdir \"${cwetc}/${rname}\"
    { cd \"${rtdir}/etc\" ; tar -cf - . ; } | { cd \"${cwetc}/${rname}\" ; tar -xf - ; }
    local t=\"${cwtop}/tmp/${rname}-etc.PRE-\${TS}\"
    cwmkdir \"\${t}\"
    { cd \"${rtdir}/etc\" ; tar -cf - . ; } | { cd \"\${t}\" ; tar -xvf - ; cwscriptecho \"\$(cwmyfuncname): backed up ${rtdir}/etc to ${cwetc}/${rname} and \${t}\" ; }
    rm -rf \"${rtdir}/etc\"
  fi
}
"

# XXX - hmm HMM
eval "
function cwuninstall_${rname}() {
  cwclean_${rname}
  pushd \"${rtdir}\" >/dev/null 2>&1
  rm -rf ${rname}-*
  rm -f current previous
  rm -f \"${rprof}\"
  rm -f \"${cwvarinst}/${rname}\"
  if [ -e etc ] ; then
    rmdir etc || echo \"${rtdir}/etc not empty\"
  fi
  popd >/dev/null 2>&1
  pushd \"${cwsw}\" >/dev/null 2>&1
  if [ -e ${rname} ] ; then
    rmdir ${rname} || echo \"${cwsw}/${rname} not empty\"
  fi
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/openssh/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${cwsw}/openssh/current/sbin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/opensshlibressl/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/opensshlibressl/current/sbin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"

unset lshver
