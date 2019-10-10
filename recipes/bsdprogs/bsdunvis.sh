rname="bsdunvis"
rver="1.13"
rdir="${rname}-${rver}"
rfile="${rdir}.fake"
rurl="http://cvsweb.netbsd.org/bsdweb.cgi/src/usr.bin/unvis/"
rsha256="d72ba7261929b85b8880a68c5f4f24a7141cdcd028459e00a2c21a5e03898c43"
rreqs="libbsd pkgconfig"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/bsdprogs/bsdprogs.sh.common"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/unvis/unvis.c?rev=${rver}\" \"${cwdl}/${rname}/unvis.c\" \"${rsha256}\"
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/unvis/unvis.1?rev=1.10\" \"${cwdl}/${rname}/unvis.1\" \"7d225292adf40a9d5eb5614c2eee52ed94b5ea24c7c7c077e38e41d4661849c1\"
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \${CC} -DLIBBSD_NETBSD_VIS ${cwdl}/${rname}/unvis.c -o unvis \$(pkg-config --cflags --libs libbsd-overlay) -static
  popd >/dev/null 2>&1
}
"
