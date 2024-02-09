rname="bsdjot"
rver="1.27"
rdir="${rname}-${rver}"
rfile="${rdir}.fake"
rurl="http://cvsweb.netbsd.org/bsdweb.cgi/src/usr.bin/jot/"
rsha256="628d638d35dfcf8a6fd1b5e0ede650bb6501e02d40113f6e524f9b61f8b92e29"
rreqs="libbsd pkgconfig"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/bsdprogs/bsdprogs.sh.common"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/jot/jot.c?rev=${rver}\" \"${cwdl}/${rname}/jot.c\" \"${rsha256}\"
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/jot/jot.1?rev=1.16\" \"${cwdl}/${rname}/jot.1\" \"39711d1da08196d3f8670949343c177fa0a7d71b5cdb60dcfea917826be8df1b\"
}
"
