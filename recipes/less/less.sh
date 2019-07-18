#
# to rebuild from autotoolsless github:
#   reqs:
#     nroff autoconf automake libtool perl
#   configure:
#     find . -name \*.VER | sed 's/\.VER//g' | xargs make -f Makefile.aut funcs.h
#     grep -ril /usr/bin/perl . | xargs sed -i 's#/usr/bin/perl#/usr/bin/env perl#g'
#     libtoolize
#     autoreconf -fiv .
#     ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts}
#

rname="less"
rver="550"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.greenwoodsoftware.com/${rname}/${rfile}"
rsha256="6a53639f08d7ed05b6e104b82c32193f79ac01a3eddb20e114e1c261948bd57b"
rreqs="make ncurses sed"

. "${cwrecipe}/common.sh"

# XXX - add -R for default pager?
eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'export PAGER=\"less -Q -L\"' >> \"${rprof}\"
  echo 'export MANPAGER=\"less -R -Q -L\"' >> \"${rprof}\"
  echo 'alias less=\"less -Q -L\"' >> \"${rprof}\"
}
"
