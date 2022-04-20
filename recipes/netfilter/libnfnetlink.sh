#
# XXX - deprecated, retool to use libmnl/libnetfilter_queue:
#   https://git.netfilter.org/libnfnetlink/commit/?id=bb4f6c8ef3a5282dc7ee04b6e731029fbca9e03b
#

rname="libnfnetlink"
rver="1.0.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://www.netfilter.org/pub/${rname}/${rfile}"
rsha256="f270e19de9127642d2a11589ef2ec97ef90a649a74f56cf9a96306b04817b51a"
rreqs="bootstrapmake configgit"
rpfile="${cwrecipe}/netfilter/${rname}.patches"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts}
  popd >/dev/null 2>&1
}
"
