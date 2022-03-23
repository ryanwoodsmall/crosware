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
rver="0.68"
rdir="${rname}-portable-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://gameoftrees.org/releases/portable/${rfile}"
rsha256="465cc6805f284caf3283fbd2ad4f33258543a01a2640566ac5cdccbbb58748bc"
rreqs="libressl"

if ! $(command -v ssh &>/dev/null) ; then
  rreqs="${rreqs} opensshlibressl"
fi

. "${cwrecipe}/got/got.sh.common"
