#
# XXX - move config (keys) to $cwtop/etc/dropbear/ ??? .gitignore might get ugly
# XXX - sftp-server is messy
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
rver="2020.81"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
#rurl="https://matt.ucc.asn.au/${rname}/releases/${rfile}"
rurl="https://dropbear.nl/mirror/releases/${rfile}"
rsha256="48235d10b37775dbda59341ac0c4b239b82ad6318c31568b985730c788aac53b"
# need a patch program, try toybox
rreqs="make toybox zlib configgit"

. "${cwrecipe}/common.sh"

lshver="2.1"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetch \"https://raw.githubusercontent.com/ryanwoodsmall/${rname}-misc/master/options/${rname}-${rver}_localoptions.h\" \"${cwdl}/${rname}/${rname}-${rver}_localoptions.h\"
  cwfetch_nettle
  #cwfetch_lsh
  cwfetchcheck \"https://ftp.gnu.org/pub/gnu/lsh/lsh-${lshver}.tar.gz\" \"${cwdl}/lsh/lsh-${lshver}.tar.gz\" \"8bbf94b1aa77a02cac1a10350aac599b7aedda61881db16606debeef7ef212e3\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  cwextract \"\$(cwdlfile_nettle)\" \"${rbdir}\"
  cwextract \"${cwdl}/lsh/lsh-${lshver}.tar.gz\" \"${rbdir}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat \"${cwdl}/${rname}/${rname}-${rver}_localoptions.h\" > localoptions.h
  cwscriptecho 'patching localoptions.h'
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
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} \
    MULTI=1 \
    SCPPROGRESS=1 \
    PROGRAMS=\"dropbear dbclient dropbearkey dropbearconvert scp\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install \
    MULTI=1 \
    SCPPROGRESS=1 \
    PROGRAMS=\"dropbear dbclient dropbearkey dropbearconvert scp\"
  ln -sf \"${ridir}/bin/dbclient\" \"${ridir}/bin/ssh\"
  cwmkdir \"${rtdir}/etc\"
  popd >/dev/null 2>&1
  cwmakeinstall_sftpserver_${rname}
}
"

eval "
function cwmakeinstall_sftpserver_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cd \"\$(cwdir_nettle)\"
  ./configure \
    ${cwconfigurelibopts} \
    --prefix=\"${rbdir}/sftp-server\" \
    --libdir=\"${rbdir}/sftp-server/lib\" \
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
  ./configure --prefix=\"${rbdir}/sftp-server\" \
    LDFLAGS=\"-L${rbdir}/sftp-server/lib -static\" \
    CPPFLAGS=\"-I${rbdir}/sftp-server/include\"
  make -j${cwmakejobs}
  make install
  cd -
  cwmkdir \"${ridir}/libexec\"
  install -m 0755 \"${rbdir}/sftp-server/sbin/sftp-server\" \"${ridir}/libexec/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwuninstall_${rname}() {
  pushd \"${rtdir}\" >/dev/null 2>&1
  rm -rf \"${rdir}\"
  rm -f \"${rprof}\"
  rm -f \"${cwvarinst}/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"

unset lshver
