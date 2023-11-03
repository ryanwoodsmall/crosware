#
# XXX - uses separate openssldir in ${cwtop}/etc/libressl
# XXX - broken on centos 6, ugh
# XXX - when upgraded, an installed dependents reinstall should be performed - {libssh2,curl,...}libressl
# XXX - 3.8.x broken w/nginx: sha3_update, sha3_final conflicts from gcrypt (remove from libxslt???)
# XXX - 3.8.x broken w/openvpn: ENGINE_get_next
#
rname="libressl"
rsv="37"
rlp="${rname}${rsv}"
rver="$(cwver_${rlp})"
rdir="$(cwdir_${rlp})"
rfile="$(cwfile_${rlp})"
rdlfile="$(cwdlfile_${rlp})"
rurl="$(cwurl_${rlp})"
rsha256="$(cwsha256_${rlp})"
rreqs="${rlp}"

. "${cwrecipe}/common.sh"

for f in fetch clean extract configure make ; do
  cwstubfunc "cw${f}_${rname}"
done
unset f

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${rtdir}\"
  rm -rf \"${rtdir}/current\"
  rm -rf \"\$(cwidir_${rname})\"
  ln -sf \"\$(cwidir_${rlp})\" \"\$(cwidir_${rname})\"
}
"

unset rsv
unset rlp
