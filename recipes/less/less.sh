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
# XXX - add -I to search case insensitively?
# XXX - add -X to leave content on screen after exit?
#
rname="less"
rver="679"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="http://www.greenwoodsoftware.com/less/${rfile}"
#rurl="https://ftp.gnu.org/pub/gnu/less/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/less/${rfile}"
rsha256="9b68820c34fa8a0af6b0e01b74f0298bcdd40a0489c61649b47058908a153d78"
rreqs="make netbsdcurses busybox toybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
      LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -static\" \
      LIBS=\"-lcurses -lterminfo\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'export LESS=\"-i -F -L -Q -R\"' >> \"${rprof}\"
  echo 'export PAGER=\"less \${LESS}\"' >> \"${rprof}\"
  echo 'export MANPAGER=\"less \${LESS}\"' >> \"${rprof}\"
  echo 'alias less=\"less \${LESS}\"' >> \"${rprof}\"
}
"
