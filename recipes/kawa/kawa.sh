rname="kawa"
rver="3.0"
rurl="ftp://ftp.gnu.org/pub/gnu/${rname}/${rname}-${rver}.zip"
rfile="$(basename ${rurl})"
rdir="${rname}-${rver}"
rsha256="63116eec4b2b2dd8fae0b30127639aa42ad7a7430c4970d3fd76b42a148e423c"
rprof="${cwetcprofd}/${rname}.sh"
# we need unzip, use the busybox version
rreqs="busybox"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir "${cwsw}/${rname}"
  test -e "${cwsw}/${rname}/${rdir}" && mv "${cwsw}/${rname}/${rdir}"{,.PRE-${TS}}
  unzip -o "${cwdl}/${rfile}" -d "${cwsw}/${rname}"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export KAWA_HOME=\"${cwsw}/${rname}/current\"' > "${rprof}"
  echo 'append_path \"\${KAWA_HOME}/bin\"' >> "${rprof}"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwsourceprofile
  cwmakeinstall_${rname}
  cwlinkdir "${rdir}" "${cwsw}/${rname}"
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
