rname="mbedtls2"
rpv="228"
rpn="${rname%2}${rpv}"
rver="$(cwver_${rpn})"
rdir="$(cwdir_${rpn})"
rfile="$(cwfile_${rpn})"
rdlfile="$(cwdlfile_${rpn})"
rurl="$(cwurl_${rpn})"
rsha256="$(cwsha256_${rpn})"
rreqs="${rpn}"

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
  ln -sf \"\$(cwidir_${rpn})\" \"\$(cwidir_${rname})\"
}
"

unset rpv
unset rpn
