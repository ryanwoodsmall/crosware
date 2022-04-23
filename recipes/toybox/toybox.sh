#
# XXX - should probably use tag for toybox_config_script.sh
# XXX - cwmake_ loop since aarch64 occasionally just dies?
#

rname="toybox"
rver="0.8.6"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/landley/${rname}/archive/${rfile}"
rsha256="e2c4f72a158581a12f4303d0d1aeec196b01f293e495e535bcdaf75eb9ae0987"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ${cwcurl} -kLsO https://raw.githubusercontent.com/ryanwoodsmall/${rname}-misc/master/scripts/${rname}_config_script.sh
  sed -i.ORIG 's/^make/#make/g;s/^test/#test/g' ${rname}_config_script.sh
  make defconfig HOSTCC=\"\${CC} -static\"
  bash ${rname}_config_script.sh -m -s
  make oldconfig HOSTCC=\"\${CC} -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  for i in 1 2 3 ; do
    make -j${cwmakejobs} V=1 CC=\"\${CC}\" HOSTCC=\"\${CC} -static\" CFLAGS=\"\${CFLAGS}\" HOSTCFLAGS=\"\${CFLAGS}\" HOSTLDFLAGS=\"\${LDFLAGS}\" || true
  done
  test -e toybox || cwfailexit \"toybox did not build for some reason? aarch64?\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cwmkdir "${ridir}/bin"
  rm -f "${ridir}/bin/${rname}"
  cp -a "${rname}" "${ridir}/bin"
  local a=''
  for a in \$(./${rname}) ; do
    ln -sf "${ridir}/bin/${rname}" "${ridir}/bin/\${a}"
  done
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
