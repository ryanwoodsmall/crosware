#
# XXX - should probably use hash or tag for toybox_config_script.sh and add a sha for offline build
# XXX - cwmake_ loop since aarch64 occasionally just dies?
# XXX - bearssl+libtlsbearssl with CONFIG_WGET_LIBTLS?
# XXX - openssl variant with CONFIG_WGET_OPENSSL?
#

rname="toybox"
rver="0.8.11"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/landley/${rname}/archive/${rfile}"
rsha256="83a3a88cbe1fa30f099c2f58295baef4637aaf988085aaea56e03aa29168175d"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG '/crypt.*ssl/s,for i in .*,for i in nononononono,g' scripts/make.sh
  csu=\"https://raw.githubusercontent.com/ryanwoodsmall/${rname}-misc/master/scripts/${rname}_config_script.sh\"
  cs=\"\$(basename \${csu})\"
  cwfetch \"\${csu}\" \"\$(cwbdir_${rname})/\${cs}\"
  sed -i.ORIG 's/^make/#make/g;s/^test/#test/g' \"\${cs}\"
  make defconfig HOSTCC=\"\${CC} -static\"
  bash \"\${cs}\" -m -s
  make oldconfig HOSTCC=\"\${CC} -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  for i in 1 2 3 4 5 6 7 ; do
    make -j${cwmakejobs} V=1 CC=\"\${CC}\" HOSTCC=\"\${CC} -static\" CFLAGS=\"\${CFLAGS}\" HOSTCFLAGS=\"\${CFLAGS}\" HOSTLDFLAGS=\"\${LDFLAGS}\" || true
  done
  make V=1 CC=\"\${CC}\" HOSTCC=\"\${CC} -static\" CFLAGS=\"\${CFLAGS}\" HOSTCFLAGS=\"\${CFLAGS}\" HOSTLDFLAGS=\"\${LDFLAGS}\" || true
  test -e toybox || cwfailexit \"toybox did not build for some reason? aarch64?\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  cp -a \"${rname}\" \"\$(cwidir_${rname})/bin/\"
  local a=''
  for a in \$(./${rname}) ; do
    ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/\${a}\"
  done
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
