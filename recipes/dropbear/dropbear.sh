rname="dropbear"
rver="2017.75"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://matt.ucc.asn.au/dropbear/releases/${rfile}"
rsha256="6cbc1dcb1c9709d226dff669e5604172a18cf5dbf9a201474d5618ae4465098c"
# need a patch program, try toybox
rreqs="make toybox zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  curl -kLO https://raw.githubusercontent.com/ryanwoodsmall/dropbear-misc/master/options/dropbear-${rver}_options.h.patch
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
      CC=\"\${CC}\" LDFLAGS=\"\${LDFLAGS}\"
  patch -p0 < dropbear-${rver}_options.h.patch
  sed -i \"s#/opt/dropbear#${rtdir}#g\" options.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make -j$(($(nproc)+1)) \
    MULTI=1 \
    SCPPROGRESS=1 \
    STATIC=1 \
    PROGRAMS=\"dropbear dbclient dropbearkey dropbearconvert scp\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make install \
    MULTI=1 \
    SCPPROGRESS=1 \
    STATIC=1 \
    PROGRAMS=\"dropbear dbclient dropbearkey dropbearconvert scp\"
  cwmkdir "${rtdir}/etc"
  popd >/dev/null 2>&1
}
"

eval "
function cwuninstall_${rname}() {
  pushd "${rtdir}" >/dev/null 2>&1
  rm -rf "${rdir}"
  rm -f "${rprof}"
  rm -f "${cwvarinst}/${rname}"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_path \"${rtdir}/current/sbin\"' >> "${rprof}"
}
"
