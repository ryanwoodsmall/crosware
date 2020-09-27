#
# XXX - uses a fork of https://github.com/RoguelikeRestorationProject/rogue5.4
# XXX - https://github.com/nealey/rogue has a makefile, no autotools
# XXX - git snapshot, sha256sum may change, need to tag
#
rname="rogue"
rver="5.4-9d0dcccc8ec82454bd4d4310f4638985a4726d83"
rdir="${rname}${rver}"
rfile="${rver##*-}.zip"
rurl="https://github.com/ryanwoodsmall/${rname}${rver%%-*}/archive/${rfile}"
rsha256="6f9a7e03fe9ee6ffdb3be3f0bb7adab73d52e4041cae36a548dfb9718cf5ce3f"
rreqs="make ncurses configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --enable-wizardmode \
    --enable-scorefile=${rtdir}/rogue.scr \
    --enable-lockfile=${rtdir}/rogue.lck
  echo '#include <sys/types.h>' >> config.h
  echo '#define NCURSES_INTERNALS 1' >> config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
