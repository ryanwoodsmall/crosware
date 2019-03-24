#
# need openssh for sftp support
# append to localoptions.h something like
#   #define SFTPSERVER_PATH "${cwsw}/openssh/current/libexec/sftp-server"
#
rname="dropbear"
rver="2019.77"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://matt.ucc.asn.au/dropbear/releases/${rfile}"
rsha256="d91f78ebe633be1d071fd1b7e5535b9693794048b019e9f4bea257e1992b458d"
# need a patch program, try toybox
rreqs="make toybox zlib"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${cwdl}/${rname}/${rfile}\" \"${rsha256}\"
  cwfetch \"https://raw.githubusercontent.com/ryanwoodsmall/dropbear-misc/master/options/dropbear-${rver}_localoptions.h\" \"${cwdl}/${rname}/dropbear-${rver}_localoptions.h\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat \"${cwdl}/${rname}/dropbear-${rver}_localoptions.h\" > localoptions.h
  cwscriptecho 'patching localoptions.h'
  sed -i \"s#/opt/dropbear#${rtdir}#g\" localoptions.h
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
