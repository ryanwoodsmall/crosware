#
# XXX - 20260613 - ugh
# XXX   - remove ncurses support
# XXX   - inhibit environment and use a stripped-down muon without pkg-config support
# XXX   - always make loksh last of the ksh providers
# XXX - 20260614 - ncurses was a miscompilation issue
# XXX   - it was pulling in weird system components on raspbian
# XXX   - fixed by limiting build environment, which will become default at some point
# XXX   - keep this as lokshsmall, add ncurses w/regular muon+pkgconf back in as loksh
#
rname="loksh"
rver="7.9"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/dimkr/${rname}/releases/download/${rver}/${rfile}"
rsha256="9cd50a5d5023c1886ef70dfe7334cebec4f4c6a9548f15d01a04732038e9ac0f"
rreqs="samurai muonminimal bashtiny busybox"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset CPPFLAGS PKG_CONFIG_{LIBDIR,PATH}
    export PATH=\"\$(echo ${cwsw}/{ccache{4,},statictoolchain,${rreqs// /,}}/current/bin | tr ' ' ':')\"
    export LDFLAGS=-static
    \"${cwsw}/muonminimal/current/bin/muon\" setup -Dprefix=\"\$(cwidir_${rname})\" -Ddefault_library=static -Dwarning_level=0 build
  )
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    export PATH=\"\$(echo ${cwsw}/{ccache{4,},statictoolchain,${rreqs// /,}}/current/bin | tr ' ' ':')\"
    \"${cwsw}/samurai/current/bin/samu\" -C build
  )
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
  \"${cwsw}/muonminimal/current/bin/muon\" -C build install
  mv \"\$(cwidir_${rname})/bin/ksh\" \"\$(cwidir_${rname})/bin/${rname}\"
  \"\$(\${CC} -dumpmachine)-strip\" --strip-all \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/ksh\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/sh\"
  install -m 644 *.1 \"\$(cwidir_${rname})/share/man/man1/\"
  install -m 644 CONTRIBUTORS LEGAL NOTES PROJECTS README README.md \"\$(cwidir_${rname})/share/doc/\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/ksh93/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${cwsw}/mksh/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/oksh/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"

# vim: set ft=bash:
