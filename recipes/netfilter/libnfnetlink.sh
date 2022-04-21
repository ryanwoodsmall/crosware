#
# XXX - deprecated, retool to use libmnl/libnetfilter_queue:
#   https://git.netfilter.org/libnfnetlink/commit/?id=bb4f6c8ef3a5282dc7ee04b6e731029fbca9e03b
#

rname="libnfnetlink"
rver="1.0.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://www.netfilter.org/pub/${rname}/${rfile}"
rsha256="b064c7c3d426efb4786e60a8e6859b82ee2f2c5e49ffeea640cfe4fe33cbc376"
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
