sname="mbedtls"
rname="${sname}228"
rver="2.28.10"
rdir="${sname}-${rver}"
rfile="${sname}-${rver}.tar.bz2"
rurl="https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-${rver}/${rfile}"
rsha256="19e5b81fdac0fe22009b9e2bdcd52d7dcafbf62bc67fc59cf0a76b5b5540d149"

. "${cwrecipe}/${sname}/${sname}.sh.common"

unset sname
