#
# XXX - libcurl, libarchive, etc.
# XXX - 2025/11/02 - require pkgconfig, something is screwy
#     - getting a core dump on bootstrap using only pkgconf
#     - UGHHHHHHHHHHHHHHHHHH
# XXX - need to fix path to pkg-config -> pkgconf
# XXX - see muonminimal for some funky config stuff
# XXX - 0.6.0 broke something with my config, copy_file succeeds on "muon ... install" and dump fails?
#     - fix_rpaths is breaking?
#     - ovewrite src/platform/posix/rpath_fixer.c with src/platform/null/rpath_fixer.c
#
rname="muon"
rver="0.6.0"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/annacrombie/muon/archive/refs/tags/${rfile}"
rsha256="5300e58c4b4d43e3026856004c79d746075aaa9d9e66d76ba9f32ce249495b81"
rreqs="samurai pkgconf"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat src/platform/posix/rpath_fixer.c > src/platform/posix/rpath_fixer.c.MINIMAL
  cat src/platform/null/rpath_fixer.c > src/platform/posix/rpath_fixer.c
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/bin | tr ' ' ':'):\${PATH}\" \
    PKG_CONFIG=\"${cwsw}/pkgconf/current/bin/pkgconf\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    C{,XX}FLAGS=\"\${CFLAGS} -DBOOTSTRAP_NO_SAMU\" \
      ./bootstrap.sh build-boot
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/bin | tr ' ' ':'):\${PATH}\" \
    PKG_CONFIG=\"${cwsw}/pkgconf/current/bin/pkgconf\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    C{,XX}FLAGS=\"\${CFLAGS}\" \
      \"\$(cwbdir_${rname})/build-boot/muon-bootstrap\" -v setup \
        -Dprefix=\"\$(cwidir_${rname})\" \
        -Dstatic=true \
        -Dlibpkgconf=enabled \
        -Dreadline=builtin \
        -D{libarchive,libcurl,man-pages,meson-{docs,tests},tracy,website}=disabled \
         build
  env C{,XX}FLAGS=\"\${CFLAGS}\" \"${cwsw}/samurai/current/bin/samu\" -C build
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  \"\$(cwbdir_${rname})/build/muon\" -v -C build install
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

# vim: set ft=bash:
