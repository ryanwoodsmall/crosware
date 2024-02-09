rname="bsdrs"
rver="1.16"
rdir="${rname}-${rver}"
rfile="${rdir}.fake"
rurl="http://cvsweb.netbsd.org/bsdweb.cgi/src/usr.bin/rs/"
rsha256="4ccbd6128302b2eaac39aaf63fb6d292888b4de218d0224074ec4e3cfefad2f8"
rreqs="libbsd pkgconfig"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/bsdprogs/bsdprogs.sh.common"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/rs/rs.c?rev=${rver}\" \"${cwdl}/${rname}/rs.c\" \"${rsha256}\"
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/rs/rs.1?rev=1.11\" \"${cwdl}/${rname}/rs.1\" \"1a5753034daf0bdce754342c34615111a7ba1e1deaf2b6c100dd7c7842725916\"
}
"
