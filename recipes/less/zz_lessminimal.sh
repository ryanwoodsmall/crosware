rname="lessminimal"
rver="$(cwver_less)"
rdir="$(cwdir_less)"
rfile="$(cwfile_less)"
rdlfile="$(cwdlfile_less)"
rurl="$(cwurl_less)"
rsha256="$(cwsha256_less)"
rreqs="bootstrapmake bashtermcap"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_less)\" >/dev/null 2>&1
  cat configure > configure.ORIG
  sed -i '/^TERMLIBS=/s,=,=-ltermcap,' configure
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    ac_cv_header_termcap_=yes \
    CC=\"\${CC} -g0 -Os -Wl,-s\" \
    CFLAGS=\"\${CFLAGS} -g0 -Os -Wl,-s\" \
    CPPFLAGS=\"-I${cwsw}/bashtermcap/current/include\" \
    LDFLAGS=\"-L${cwsw}/bashtermcap/current/lib -static\" \
    LIBS='-ltermcap' \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

# note prepend_ - swap order of "real" vs minimal
eval "
function cwgenprofd_${rname}() {
  echo -n > \"${rprof}\"
  echo 'prepend_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
  echo 'prepend_path \"${cwsw}/${rname%minimal}/current/bin\"' >> \"${rprof}\"
  echo 'export LESS=\"-i -F -L -Q -R\"' >> \"${rprof}\"
  echo 'export PAGER=\"less \${LESS}\"' >> \"${rprof}\"
  echo 'export MANPAGER=\"less \${LESS}\"' >> \"${rprof}\"
  echo 'alias less=\"less \${LESS}\"' >> \"${rprof}\"
}
"
