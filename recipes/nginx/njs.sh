rname="njs"
rver="0.8.10"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/nginx/njs/archive/refs/tags/${rfile}"
rsha256="0be4bdd79184cd43f55a0377e59107fddfeef33e54f97c890894f0fe72628d26"
rreqs="libressl"
. "${cwrecipe}/nginx/${rname}.sh.common"
