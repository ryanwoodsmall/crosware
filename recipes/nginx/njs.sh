rname="njs"
rver="0.8.8"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/nginx/njs/archive/refs/tags/${rfile}"
rsha256="356386c8133590a4d1d3a529694821d4d1a00b6f7575eeb454a698bec823477b"
rreqs="libressl"
. "${cwrecipe}/nginx/${rname}.sh.common"
