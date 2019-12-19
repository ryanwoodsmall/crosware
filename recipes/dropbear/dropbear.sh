#
# XXX - need openssh for sftp support - append to localoptions.h something like
#   #define SFTPSERVER_PATH "${cwsw}/openssh/current/libexec/sftp-server"
# XXX - move config (keys) to $cwtop/etc/dropbear/
#
rname="dropbear"
rver="2019.78"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
#rurl="https://matt.ucc.asn.au/${rname}/releases/${rfile}"
rurl="https://dropbear.nl/mirror/releases/${rfile}"
rsha256="525965971272270995364a0eb01f35180d793182e63dd0b0c3eb0292291644a4"
# need a patch program, try toybox
rreqs="make toybox zlib"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetch \"https://raw.githubusercontent.com/ryanwoodsmall/${rname}-misc/master/options/${rname}-${rver}_localoptions.h\" \"${cwdl}/${rname}/${rname}-${rver}_localoptions.h\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat \"${cwdl}/${rname}/${rname}-${rver}_localoptions.h\" > localoptions.h
  cwscriptecho 'patching localoptions.h'
  sed -i \"s#/opt/${rname}#${rtdir}#g\" localoptions.h
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
