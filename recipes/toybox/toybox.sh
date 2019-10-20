#
# XXX - should probably use tag for toybox_config_script.sh
#

rname="toybox"
rver="0.8.2"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/landley/${rname}/archive/${rfile}"
rsha256="9d8a9b00a6c93da5b472d8a4c7d9549339ed050d1578c557a20add100172b0f5"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  curl -kLsO https://raw.githubusercontent.com/ryanwoodsmall/${rname}-misc/master/scripts/${rname}_config_script.sh
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
  make -j${cwmakejobs} CC=\"\${CC}\" HOSTCC=\"\${CC} -static\" CFLAGS=\"\${CFLAGS}\" HOSTCFLAGS=\"\${CFLAGS}\" HOSTLDFLAGS=\"\${LDFLAGS}\"
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
