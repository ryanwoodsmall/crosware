sname="mbedtls"
rname="${sname}228"
rver="2.28.8"
rdir="${sname}-${rver}"
rfile="${sname}-${rver}.tar.bz2"
rurl="https://github.com/Mbed-TLS/mbedtls/releases/download/v${rver}/${rfile}"
rsha256="241c68402cef653e586be3ce28d57da24598eb0df13fcdea9d99bfce58717132"

. "${cwrecipe}/${sname}/${sname}.sh.common"

unset sname
