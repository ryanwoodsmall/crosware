rname="loksh"
rver="7.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/dimkr/${rname}/releases/download/${rver}/${rfile}"
rsha256="0c70706b2ae960af035d73d3bb5f30030286e9ebe9855363dccadb85f901adf0"
rreqs="ncurses samurai muon"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/bin | tr ' ' ':'):\${PATH}\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      \"${cwsw}/muon/current/bin/muon\" setup -Dprefix=\"\$(cwidir_${rname})\" -Ddefault_library=static -Dwarning_level=0 build
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  \"${cwsw}/samurai/current/bin/samu\" -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  cwmkdir \"\$(cwidir_${rname})/share/doc\"
  find \$(cwidir_${rname})/bin/ ! -type d | grep 'sh$' | xargs rm -f || true
  \"${cwsw}/muon/current/bin/muon\" -C build install
  mv \"\$(cwidir_${rname})/bin/ksh\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/ksh\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/sh\"
  find \"\$(cwidir_${rname})/bin/\" -type f | xargs \$(\${CC} -dumpmachine)-strip --strip-all || true
  install -m 644 *.1 \"\$(cwidir_${rname})/share/man/man1/\"
  install -m 644 CONTRIBUTORS LEGAL NOTES PROJECTS README README.md \"\$(cwidir_${rname})/share/doc/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
