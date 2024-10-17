#
# XXX - libcurl, libarchive, etc.
#
rname="muon"
rver="0.3.1"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/annacrombie/muon/archive/refs/tags/${rfile}"
rsha256="14b175b29c4390a69c1d9b5758b4689f0456c749822476af67511f007be2e503"
rreqs="samurai pkgconf"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/bin | tr ' ' ':'):\${PATH}\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      ./bootstrap.sh build
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/bin | tr ' ' ':'):\${PATH}\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      \"\$(cwbdir_${rname})/build/muon\" setup \
        -Dprefix=\"\$(cwidir_${rname})\" \
        -Dstatic=true \
        -Dlibpkgconf=enabled \
        -Dreadline=bestline \
        -D{docs,libarchive,libcurl,tracy}=disabled \
        -Dwebsite=false \
         build
  \"${cwsw}/samurai/current/bin/samu\" -C build
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  \"\$(cwbdir_${rname})/build/muon\" -C build install
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
