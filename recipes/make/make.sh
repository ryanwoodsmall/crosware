rname="make"
rver="4.2.1"
rurl="https://ftp.gnu.org/gnu/${rname}/${rname}-${rver}.tar.bz2"
rfile="$(basename ${rurl})"
rdir="${rfile//.tar.bz2/}"
rsha256="d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589"

eval "
function cwinstall_${rname}() {
  cwfetchcheck "${rurl}" "${cwdl}/${rfile}" "${rsha256}"
  cwextract "${cwdl}/${rfile}" "${cwbuild}"
}
"
