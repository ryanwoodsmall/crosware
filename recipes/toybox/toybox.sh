#
# XXX - cwmake_ loop since aarch64 occasionally just dies?
# XXX - bearssl+libtlsbearssl with CONFIG_WGET_LIBTLS?
# XXX - openssl variant with CONFIG_WGET_OPENSSL?
# XXX - scripts/genconfig.sh and the like need workarounds for '#!/bin/bash' -> '#!/usr/bin/env bash'
# XXX - CONFIG_AWK
# XXX - shell configs?
#
rname="toybox"
rver="0.8.15"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/landley/toybox/archive/${rfile}"
rsha256="52452b68a6cf50f9a9728b0f844b03c4dd1f70463675b202e6cf0475bda3934f"
rreqs="bootstrapmake alpinemuslutils"

. "${cwrecipe}/common.sh"

# ef599804ec9ce57336ab4699409412678b5450ca
eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetchcheck \
    \"https://github.com/ryanwoodsmall/toybox-misc/raw/ef599804ec9ce57336ab4699409412678b5450ca/scripts/toybox_config_script.sh\" \
    \"\$(dirname \$(cwdlfile_${rname}))/toybox_config_script.sh\" \
    \"fa5e277d7f97ace82ffab1a720e7cda9e8af2ea32d4c783acc46208ad9966f80\"
}
"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG 's,/bin/bash,/usr/bin/env bash,g' scripts/genconfig.sh scripts/make.sh
  sed -i '/crypt.*ssl/s,for i in .*,for i in nononononono,g' scripts/make.sh
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cs=\"toybox_config_script.sh\"
  cat \"\$(dirname \$(cwdlfile_${rname}))/\${cs}\" > \"\${cs}\"
  chmod 755 \"\${cs}\"
  sed -i.ORIG 's/^make/#make/g;s/^test/#test/g' \"\${cs}\"
  make defconfig HOSTCC=\"\${CC} -static\"
  bash \"\${cs}\" -m -s
  make oldconfig HOSTCC=\"\${CC} -static\"
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  for i in 1 2 3 4 5 6 7 ; do
    make -j${cwmakejobs} V=1 CC=\"\${CC}\" HOSTCC=\"\${CC} -static\" CFLAGS=\"\${CFLAGS}\" HOSTCFLAGS=\"\${CFLAGS}\" HOSTLDFLAGS=\"\${LDFLAGS}\" || true
  done
  make V=1 CC=\"\${CC}\" HOSTCC=\"\${CC} -static\" CFLAGS=\"\${CFLAGS}\" HOSTCFLAGS=\"\${CFLAGS}\" HOSTLDFLAGS=\"\${LDFLAGS}\" || true
  test -e toybox || cwfailexit \"toybox did not build for some reason? aarch64?\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  cp -a \"${rname}\" \"\$(cwidir_${rname})/bin/\"
  local a=''
  for a in \$(./${rname}) ; do
    ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/\${a}\"
  done
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
