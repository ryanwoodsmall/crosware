rname="gotopenssl"
rver="$(cwver_got)"
rdir="$(cwdir_got)"
rfile="$(cwfile_got)"
rdlfile="$(cwdlfile_got)"
rurl="$(cwurl_got)"
rsha256="$(cwsha256_got)"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="openssl libretls"

. "${cwrecipe}/got/got.sh.common"

for f in fetch clean extract patch ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%openssl}
  }
  "
done
unset f

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  find . -type f -name Makefile | xargs sed -i 's,-ltls,-ltls -lssl -lcrypto,g'
  cwmake_${rname%openssl}
  popd &>/dev/null
}
"
