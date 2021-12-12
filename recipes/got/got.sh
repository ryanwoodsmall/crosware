#
# XXX - default to libressl since this is a portable version of an openbsd project!
# XXX - openssl variant
# XXX - netbsdcurses has issues
# XXX - need a mirror in github?
# XXX - /usr/bin/ssh path is hardcoded in lib/dial.c as GOT_DIAL_PATH_SSH with execv used by default
# XXX - would a git<->http(s) proxy be possible with libgit2? hmm...
#

rname="got"
rver="0.64"
rdir="${rname}-portable-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://gameoftrees.org/releases/portable/${rfile}"
rsha256="5887573b7687c2786985ab0f684db160a88092b048bc8c4dcfd6c76a1dda2fe2"
rreqs="libressl"

. "${cwrecipe}/got/got.sh.common"
