#
# XXX - libcurl, libarchive, etc.
#
rname="muon"
rver="0.2.0"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/annacrombie/muon/archive/refs/tags/${rfile}"
rsha256="d73db1be5388821179a25a15ba76fd59a8bf7c8709347a4ec2cb91755203f36c"
rreqs="samurai pkgconf"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/bin | tr ' ' ':'):\${PATH}\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      ./bootstrap.sh build
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/bin | tr ' ' ':'):\${PATH}\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      \"\$(cwbdir_${rname})/build/muon\" setup \
        -Dprefix=\"\$(cwidir_${rname})\" \
        -Dstatic=true \
        -D{bestline,libpkgconf}=enabled \
        -D{docs,libarchive,libcurl,tracy}=disabled \
        -Dwebsite=false \
         build
  \"${cwsw}/samurai/current/bin/samu\" -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  \"\$(cwbdir_${rname})/build/muon\" -C build install
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
