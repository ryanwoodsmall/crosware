#
# XXX - default to libressl since this is a portable version of an openbsd project!
# XXX - should this switch to default openssl, with libressl variant like... everything else?
# XXX - netbsdcurses has issues
# XXX - need a mirror in github?
# XXX - /usr/bin/ssh path is hardcoded in lib/dial.c as GOT_DIAL_PATH_SSH with execv used by default
# XXX - would a git<->http(s) proxy be possible with libgit2? hmm...
# XXX - git interop (with .cvsignore+.gitignore)
#   mkdir blah
#   got clone blah@blah:blah.git blah/.git
#   got checkout -E .git .
#   # edit
#   got add blah
#   got commit -m blah
#   got send
#   # do changes in git
#   got fetch -a -t origin
#   got update -b origin/master
#   got rebase master
#   # edit
#   got commit -m msg
#   got send
#
rname="got"
rver="0.118.1"
rdir="${rname}-portable-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://gameoftrees.org/releases/portable/${rfile}"
rsha256="77c138791ede6fa9c535078711ff7bed49fe54d86c186b0820cba65cb09ba650"
rreqs="libressl"

. "${cwrecipe}/got/got.sh.common"
