rname="wireguardtools"
rver="1.0.20210914"
rdir="wireguard-tools-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/WireGuard/wireguard-tools/archive/refs/tags/${rfile}"
rsha256="acb8517eed8f352bbf0758a70573c665521a4300d0c4865afebd6b643738c640"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})/src\" >/dev/null 2>&1
  make PREFIX=\"\$(cwidir_${rname})\" SYSCONFDIR=\"${cwetc}\" WITH_{BASHCOMPLETION,SYSTEMDUNITS}=no V=1 LDFLAGS=-static CC=\"\${CC} \${CFLAGS}\" CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})/src\" >/dev/null 2>&1
  make install PREFIX=\"\$(cwidir_${rname})\" SYSCONFDIR=\"${cwetc}\" WITH_{BASHCOMPLETION,SYSTEMDUNITS}=no V=1 LDFLAGS=-static CC=\"\${CC} \${CFLAGS}\" CPPFLAGS=
  cwmkdir \"\$(cwidir_${rname})/contrib\"
  ( cd ../contrib/ ; tar cf - . ) | ( cd \"\$(cwidir_${rname})/contrib/\" ; tar xf - )
  grep -ril /etc/wireguard \"\$(cwidir_${rname})/contrib/\" \"\$(cwidir_${rname})/share/\" \"\$(cwidir_${rname})/bin/wg-quick\" | xargs sed -i \"s,/etc/wireguard,${cwetc}/wireguard,g\" || true
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
