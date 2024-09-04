sname="mbedtls"
rname="${sname}228"
rver="2.28.9"
rdir="${sname}-${rver}"
rfile="${sname}-${rver}.tar.bz2"
rurl="https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-${rver}/${rfile}"
rsha256="e85ea97aaf78dd6c0a5ba2e54dd5932ffa15f39abfc189c26beef7684630c02b"

. "${cwrecipe}/${sname}/${sname}.sh.common"

unset sname
