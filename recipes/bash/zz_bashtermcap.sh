rname="bashtermcap"
rver="$(cwver_bash)"
rdir="$(cwdir_bash)"
rbdir="$(cwbdir_bash)"
rfile="$(cwfile_bash)"
rdlfile="$(cwdlfile_bash)"
rurl="$(cwurl_bash)"
rsha256="$(cwsha256_bash)"
rreqs="bootstrapmake patch"
rpfile="${cwrecipe}/bash/bash.patches"

. "${cwrecipe}/common.sh"

eval "function cwfetchpatches_${rname}() { cwfetchpatches_bash ; }"

eval "
function cwfetch_${rname}() {
  cwfetch_bash
  cwfetch_termcap
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  cwextract \"\$(cwdlfile_termcap)\" \"\$(cwbdir_${rname})\"
}
"

eval "
function cwpatch_${rname}() {
  cwpatch_bash
  pushd \"\$(cwbdir_${rname})/lib/termcap\" >/dev/null 2>&1
  sed -i.ORIG \"s,/etc/termcap,${cwetc}/termcap,g\" termcap.c
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure \
    --prefix=\"\$(cwidir_${rname})\" \
    --disable-nls \
    --disable-separate-helpfiles \
    --enable-readline \
    --without-curses \
    --enable-static-link \
    --without-bash-malloc \
      LDFLAGS=-static \
      {CPPFLAGS,PKG_CONFIG_{LIBDIR,PATH}}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})/lib/termcap\" >/dev/null 2>&1
  make
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})/lib/termcap\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/include\"
  cwmkdir \"\$(cwidir_${rname})/lib\"
  cwmkdir \"\$(cwidir_${rname})/etc\"
  install -m 644 termcap.h \"\$(cwidir_${rname})/include/\"
  install -m 644 libtermcap.a \"\$(cwidir_${rname})/lib/\"
  install -m 644 \"\$(cwbdir_${rname})/\$(cwdir_termcap)/termcap.src\" \"${cwetc}/termcap\"
  install -m 644 \"\$(cwbdir_${rname})/\$(cwdir_termcap)/termcap.src\" \"\$(cwidir_${rname})/etc/\"
  ln -sf termcap.src \"\$(cwidir_${rname})/etc/termcap\"
  popd >/dev/null 2>&1
}
"
