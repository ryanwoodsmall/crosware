sname="mbedtls"
rname="${sname}216"
rver="2.16.12"
rdir="${sname}-${sname}-${rver}"
rfile="${sname}-${rver}.tar.gz"
rurl="https://github.com/ARMmbed/${sname}/archive/${rfile}"
rsha256="0afb4a4ce5b771f2fb86daee786362fbe48285f05b73cd205f46a224ec031783"
rreqs="make cacertificates"

. "${cwrecipe}/${sname}/${sname}.sh.common"

unset sname
