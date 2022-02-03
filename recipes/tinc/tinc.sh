rname="tinc"
rver="1.0.36"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.tinc-vpn.org/packages/${rfile}"
rsha256="40f73bb3facc480effe0e771442a706ff0488edea7a5f2505d4ccb2aa8163108"
rreqs="openssl"

. "${cwrecipe}/tinc/tinc.sh.common"
