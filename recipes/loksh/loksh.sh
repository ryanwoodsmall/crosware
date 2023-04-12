rname="loksh"
rver="7.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/dimkr/${rname}/releases/download/${rver}/${rfile}"
rsha256="e60bee39836432024569f44b499581ef8ebedbd8fe5b6172245e9a1af4304e9b"
rreqs="ncurses pkgconfig python3 meson ninja"
rprof="${cwetcprofd}/zz_${rname}.sh"

if ! command -v git &>/dev/null ; then
  rreqs="${rreqs} git"
fi

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"\$(echo -n ${cwsw}/{python3,meson,ninja}/current/bin | tr ' ' ':'):\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" setup --prefix=\"\$(cwidir_${rname})\" build \"\$(cwbdir_${rname})\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"\$(echo -n ${cwsw}/{python3,meson,ninja}/current/bin | tr ' ' ':'):\${PATH}\" \
    \"${cwsw}/ninja/current/bin/ninja\" -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  find \$(cwidir_${rname})/bin/ ! -type d | grep 'sh$' | xargs rm -f || true
  env PATH=\"\$(echo -n ${cwsw}/{python3,meson,ninja}/current/bin | tr ' ' ':'):\${PATH}\" \
    \"${cwsw}/ninja/current/bin/ninja\" -C build install
  mv \"\$(cwidir_${rname})/bin/ksh\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/ksh\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/sh\"
  find \"\$(cwidir_${rname})/bin/\" -type f | xargs \$(\${CC} -dumpmachine)-strip --strip-all || true
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
