# make defconfig HOSTCC="$CC $CFLAGS"
# make oldconfig HOSTCC="$CC $CFLAGS"
# CC="$CC $CFLAGS" HOSTCC="$CC $CFLAGS" CFLAGS=$CFLAGS HOSTCFLAGS=$CFLAGS LDFLAGS="$LDFLAGS" make
rname="toybox"
rver="0.7.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://landley.net/${rname}/downloads/${file}"
rsha256="3ada450ac1eab1dfc352fee915ea6129b9a4349c1885f1394b61bd2d89a46c04"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
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
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  make -j$(($(nproc)+1)) CC=\"\${CC}\" HOSTCC=\"\${CC} -static\" CFLAGS=\"\${CFLAGS}\" HOSTCFLAGS=\"\${CFLAGS}\" HOSTLDFLAGS=\"\${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  cwmkdir "${cwsw}/${rname}/${rdir}/bin"
  rm -f "${cwsw}/${rname}/${rdir}/bin/${rname}"
  cp -a "${rname}" "${cwsw}/${rname}/${rdir}/bin"
  for a in \$(./${rname} --list) ; do
    ln -sf ${rname} "${cwsw}/${rname}/${rdir}/bin/\${a}"
  done
  popd >/dev/null 2>&1
}
"

eval "                                                                                                                                                                                                 
function cwgenprofd_${rname}() {                                                                                                                                                                       
  echo 'append_path "${cwsw}/${rname}/current/bin"' > ${rprof}
}                                                                                                                                                                                                      
"
