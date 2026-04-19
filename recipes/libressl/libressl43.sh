rver="4.3.0"
rname="libressl${rver%.*}"
rname="${rname//./}"
rsha256="e4fd17e1be4cc1e0c3197c132981204758f9909f49434789590971bd52bc7161"

. "${cwrecipe}/libressl/libressl.sh.common"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  echo '#include <limits.h>' >> tls/tls_internal.h
  popd &>/dev/null
}
"
