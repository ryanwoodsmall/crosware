#
# XXX - libcurl, libarchive, etc.
# XXX - 2025/11/02 - require pkgconfig, something is screwy
#   - getting a core dump on bootstrap using only pkgconf
#   - UGHHHHHHHHHHHHHHHHHH
# XXX - need to fix path to pkg-config -> pkgconf
# XXX - see muonminimal for some funky config stuff
# XXX - 0.6.0 broke something with my config, copy_file succeeds on "muon ... install" and dump fails?
#
rname="muon"
rver="0.5.0"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/annacrombie/muon/archive/refs/tags/${rfile}"
rsha256="565c1b6e1e58f7e90d8813fda0e2102df69fb493ddab4cf6a84ce3647466bee5"
rreqs="samurai pkgconf"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/bin | tr ' ' ':'):\${PATH}\" \
    PKG_CONFIG=\"${cwsw}/pkgconf/current/bin/pkgconf\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    CFLAGS=\"\${CFLAGS} -DBOOTSTRAP_NO_SAMU\" \
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
      \"\$(cwbdir_${rname})/build-boot/muon-bootstrap\" -v setup \
        -Dprefix=\"\$(cwidir_${rname})\" \
        -Dstatic=true \
        -Dlibpkgconf=enabled \
        -Dreadline=builtin \
        -D{libarchive,libcurl,man-pages,meson-{docs,tests},tracy,website}=disabled \
         build
  \"${cwsw}/samurai/current/bin/samu\" -C build
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
