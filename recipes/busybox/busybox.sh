#
# XXX - make reproducible; probably just need to set compilation time?
#

rname="busybox"
rver="1.35.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
#rurl="http://${rname}.net/downloads/${rfile}"
rsha256="faeeb244c35a348a334f4a59e44626ee870fb07b6884d68c10ae8bc19f83a694"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  chmod -R u+w .
  ${cwcurl} -kLsO https://raw.githubusercontent.com/ryanwoodsmall/${rname}-misc/master/scripts/bb_config_script.sh
  sed -i.ORIG 's/^make/#make/g;s/^test/#test/g' bb_config_script.sh
  make defconfig HOSTCC=\"\${CC} -static\"
  bash bb_config_script.sh -m -s
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
  for a in \$(./${rname} --list) ; do
    ln -sf "${ridir}/bin/${rname}" "${ridir}/bin/\${a}"
  done
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'export PAGER=\"less\"' >> "${rprof}"
  echo 'export MANPAGER=\"less -R\"' >> "${rprof}"
}
"
