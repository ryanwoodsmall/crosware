rname="toybox"
rver="0.7.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://landley.net/${rname}/downloads/${rfile}"
rsha256="3ada450ac1eab1dfc352fee915ea6129b9a4349c1885f1394b61bd2d89a46c04"
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
  make -j$(($(nproc)+1)) CC=\"\${CC}\" HOSTCC=\"\${CC} -static\" CFLAGS=\"\${CFLAGS}\" HOSTCFLAGS=\"\${CFLAGS}\" HOSTLDFLAGS=\"\${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cwmkdir "${ridir}/bin"
  rm -f "${ridir}/bin/${rname}"
  cp -a "${rname}" "${ridir}/bin"
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
