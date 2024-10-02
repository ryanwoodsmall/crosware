rname="njs"
rver="0.8.6"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/nginx/njs/archive/refs/tags/${rfile}"
rsha256="164556dc472498a5b0b3f2c4c239d2892409868ac656db3881d319be13dc36bd"
rreqs="libressl"
. "${cwrecipe}/nginx/${rname}.sh.common"
