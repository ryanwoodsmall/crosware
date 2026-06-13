#
# XXX - reliance on busybox and bash probably makes this bigger than normal w/pkgconf + embedded samurai
#
rname="muonminimal"
rver="$(cwver_muon)"
rdir="$(cwdir_muon)"
rfile="$(cwfile_muon)"
rdlfile="$(cwdlfile_muon)"
rurl="$(cwurl_muon)"
rsha256="$(cwsha256_muon)"
rreqs="samurai bashtiny busybox"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

for f in clean fetch extract ; do
  eval "function cw${f}_${rname}() { cw${f}_${rname%%minimal} ; }"
done
unset f

eval "
function  cwpatch_${rname}() {
  : cwpatch_${rname%%minimal}
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat meson.build > meson.build.MINIMAL
  sed -i '/subdir.*doc/s,^,#,' meson.build
  sed -i '/subdir.*tests/s,^,#,' meson.build
  cat src/external/meson.build > src/external/meson.build.MINIMAL
  sed -i \"/pkgconfig_impls.*exec/s|, 'exec'||g\" src/external/meson.build
  cat src/script/options/global.meson > src/script/options/global.meson.MINIMAL
  sed -i \"/'libpkgconf'/s|'.*'|'null', 'auto'|g\" src/script/options/global.meson
  sed -i \"s,'pkg-config','no-default-pkg-config',g\" src/script/options/global.meson
  sed -i \"s,/usr/local,\$(cwidir_${rname}),g\" src/script/options/global.meson
  cat src/compilers.c > src/compilers.c.MINIMAL
  sed -i 's,/lib,/no-default-lib,g' src/compilers.c
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset CPPFLAGS PKG_CONFIG_{LIBDIR,PATH}
    export PATH=\"\$(echo ${cwsw}/{ccache{4,},statictoolchain,${rreqs// /,}}/current/bin | tr ' ' ':')\"
    export C{,XX}FLAGS=\"\${CFLAGS} -g0 -Os -Wl,-s\"
    export LDFLAGS='-static -s'
    bash ./bootstrap.sh build
  )
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset CPPFLAGS PKG_CONFIG_{LIBDIR,PATH}
    export PATH=\"\$(echo ${cwsw}/{ccache{4,},statictoolchain,${rreqs// /,}}/current/bin | tr ' ' ':')\"
    export C{,XX}FLAGS=\"\${CFLAGS} -g0 -Os -Wl,-s\"
    export LDFLAGS='-static -s'
    \"\$(cwbdir_${rname})/build/muon-bootstrap\" setup \
      -Dprefix=\"\$(cwidir_${rname})\" \
      -Dbuildtype=minsize \
      -Denv.NINJA=samu \
      -Dstatic=true \
      -Dreadline=builtin \
      -Doptimization=s \
      -D{libarchive,libcurl,libpkgconf,man-pages,meson-{docs,tests},samurai,tracy,ui,website}=disabled \
      -Dmuon.pkgconfig=null \
       build
    \"${cwsw}/samurai/current/bin/samu\" -C build
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset CPPFLAGS PKG_CONFIG_{LIBDIR,PATH}
    export PATH=\"\$(echo ${cwsw}/{ccache{4,},statictoolchain,${rreqs// /,}}/current/bin | tr ' ' ':')\"
    export C{,XX}FLAGS=\"\${CFLAGS} -g0 -Os -Wl,-s\"
    export LDFLAGS='-static -s'
    cwmkdir \"\$(cwidir_${rname})/bin\"
    rm -f \$(cwidir_${rname})/bin/muon{,minimal}
    \"\$(cwbdir_${rname})/build/muon\" -C build install
    mv \$(cwidir_${rname})/bin/{muon,${rname}}
    ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/muon\"
  )
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir%%minimal}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"

# vim: set ft=bash:
