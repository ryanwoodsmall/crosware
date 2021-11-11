rname="curlwolfssl"
rreqs="wolfssl"
rcppflags="-I${cwsw}/wolfssl/current/include/wolfssl"
. "${cwrecipe}/${rname%wolfssl}/${rname%wolfssl}tlsprovider.sh.common"
