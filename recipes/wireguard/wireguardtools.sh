rname="wireguardtools"
rver="1.0.20260223"
rdir="wireguard-tools-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/WireGuard/wireguard-tools/archive/refs/tags/${rfile}"
rsha256="859f8af03702db5e5c43f8ece77f5ebef40a2f4627c3e03997a031d4940ea9bc"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})/src\" &>/dev/null
  make PREFIX=\"\$(cwidir_${rname})\" SYSCONFDIR=\"${cwetc}\" WITH_{BASHCOMPLETION,SYSTEMDUNITS}=no V=1 LDFLAGS=-static CC=\"\${CC} \${CFLAGS}\" CPPFLAGS=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})/src\" &>/dev/null
  make install PREFIX=\"\$(cwidir_${rname})\" SYSCONFDIR=\"${cwetc}\" WITH_{BASHCOMPLETION,SYSTEMDUNITS}=no V=1 LDFLAGS=-static CC=\"\${CC} \${CFLAGS}\" CPPFLAGS=
  cwmkdir \"\$(cwidir_${rname})/contrib\"
  ( cd ../contrib/ ; tar cf - . ) | ( cd \"\$(cwidir_${rname})/contrib/\" ; tar xf - )
  grep -ril /etc/wireguard \"\$(cwidir_${rname})/contrib/\" \"\$(cwidir_${rname})/share/\" \"\$(cwidir_${rname})/bin/wg-quick\" | xargs sed -i \"s,/etc/wireguard,${cwetc}/wireguard,g\" || true
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
