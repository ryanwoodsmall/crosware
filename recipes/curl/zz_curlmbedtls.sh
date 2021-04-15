rname="curlmbedtls"
rreqs="make zlib mbedtls cacertificates nghttp2 pkgconfig libgpgerror libgcrypt libssh2libgcrypt"
. "${cwrecipe}/${rname%mbedtls}/${rname%mbedtls}tlsprovider.sh.common"
