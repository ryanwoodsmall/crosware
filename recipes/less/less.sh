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
# XXX - manually define USE_TERMCAP?
#
rname="less"
rver="692"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="http://www.greenwoodsoftware.com/less/${rfile}"
#rurl="https://ftp.gnu.org/pub/gnu/less/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/less/${rfile}"
rsha256="61300f603798ecf1d7786570789f0ff3f5a1acf075a6fb9f756837d166e37d14"
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
  echo '#undef TPARM_VARARGS' >> defines.h
  echo '#define TPARM_VARARGS 1' >> defines.h
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
