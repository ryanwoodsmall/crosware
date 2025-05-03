rname="loksh"
rver="7.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/dimkr/${rname}/releases/download/${rver}/${rfile}"
rsha256="4b3a18c1baa6b21acc241eedbd5c81fda026dbfd24bb91eb2c19fdb4c5a27e1d"
rreqs="ncurses samurai muon"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/bin | tr ' ' ':'):\${PATH}\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      \"${cwsw}/muon/current/bin/muon\" setup -Dprefix=\"\$(cwidir_${rname})\" -Ddefault_library=static -Dwarning_level=0 build
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  \"${cwsw}/samurai/current/bin/samu\" -C build
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
