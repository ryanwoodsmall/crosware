#
# need openssh for sftp support
# append to localoptions.h something like
#   #define SFTPSERVER_PATH "${cwsw}/openssh/current/libexec/sftp-server"
#
rname="dropbear"
rver="2019.77"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://matt.ucc.asn.au/${rname}/releases/${rfile}"
rsha256="d91f78ebe633be1d071fd1b7e5535b9693794048b019e9f4bea257e1992b458d"
# need a patch program, try toybox
rreqs="make toybox zlib"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${cwdl}/${rname}/${rfile}\" \"${rsha256}\"
  cwfetch \"https://raw.githubusercontent.com/ryanwoodsmall/${rname}-misc/master/options/${rname}-${rver}_localoptions.h\" \"${cwdl}/${rname}/${rname}-${rver}_localoptions.h\"
  #cwfetch \"https://secure.ucc.asn.au/hg/${rname}/raw-rev/4b01f4826a29\" \"${cwdl}/${rname}/${rname}-cli-chansession.c.patch\"
  cwfetch \"https://github.com/mkj/${rname}/commit/7bc6280613f5ab4ee86c14c779739070e5784dfe.patch\" \"${cwdl}/${rname}/${rname}-cli-chansession.c.patch\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat \"${cwdl}/${rname}/${rname}-${rver}_localoptions.h\" > localoptions.h
  patch -p1 < \"${cwdl}/${rname}/${rname}-cli-chansession.c.patch\"
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
