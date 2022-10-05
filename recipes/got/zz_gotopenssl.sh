rname="gotopenssl"
rver="$(cwver_got)"
rdir="$(cwdir_got)"
rfile="$(cwfile_got)"
rdlfile="$(cwdlfile_got)"
rurl="$(cwurl_got)"
rsha256=""
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="openssl"

if ! command -v ssh &>/dev/null ; then
  rreqs="${rreqs} openssh"
fi

. "${cwrecipe}/got/got.sh.common"

for f in fetch clean extract make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%openssl}
  }
  "
done
unset f
