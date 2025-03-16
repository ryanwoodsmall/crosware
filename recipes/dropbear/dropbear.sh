#
# XXX - use git commit instead of date (requiring a git tag) for options file?
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
# XXX - enable DROPBEAR_USE_SSH_CONFIG in dropbear-misc and test
#
rname="dropbear"
rsver="2025.87"
rdate="20250316031738"
rver="${rsver}-${rdate}"
rdir="${rname}-${rsver}"
rfile="${rdir}.tar.bz2"
#rurl="https://matt.ucc.asn.au/dropbear/releases/${rfile}"
#rurl="https://dropbear.nl/mirror/releases/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/dropbear/${rfile}"
rsha256="738b7f358547f0c64c3e1a56bbc5ef98d34d9ec6adf9ccdf01dc0bf2caa2bc8d"
# need a patch program, try toybox
rreqs="make toybox zlib configgit lshsftpserver"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetchcheck \
    \"https://raw.githubusercontent.com/ryanwoodsmall/dropbear-misc/${rdate}-${rname}-${rsver}/options/${rname}-${rsver}_localoptions.h\" \
    \"${cwdl}/${rname}/${rname}-\$(cwver_${rname})_localoptions.h\" \
    \"5102cb5cd514e5b3bf8b515de6ab19875a92230c24d5089b2a5e322e37a58cac\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
      CC=\"\${CC}\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make -j${cwmakejobs} \
    MULTI=1 \
    SCPPROGRESS=1 \
    PROGRAMS=\"dropbear dbclient dropbearkey dropbearconvert scp\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install \
    MULTI=1 \
    SCPPROGRESS=1 \
    PROGRAMS=\"dropbear dbclient dropbearkey dropbearconvert scp\"
  ln -sf dbclient \"\$(cwidir_${rname})/bin/ssh\"
  cwmkdir \"${cwetc}/${rname}\"
  cwmkdir \"\$(cwidir_${rname})/libexec\"
  install -m 0755 \"${cwsw}/lshsftpserver/current/sbin/sftp-server\" \"\$(cwidir_${rname})/libexec/\"
  popd &>/dev/null
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

unset rdate
unset rsver
