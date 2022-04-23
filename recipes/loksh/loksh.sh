rname="loksh"
rver="7.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/dimkr/${rname}/releases/download/${rver}/${rfile}"
rsha256="ab7d274a057b83bc64643664094031126641aa91ee440a96765279991aab6938"
rreqs="ncurses pkgconfig python3 meson ninja git"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"\$(echo -n ${cwsw}/{python3,meson,ninja}/current/bin | tr ' ' ':'):\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" setup --prefix=\"${ridir}\" build \"${rbdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"\$(echo -n ${cwsw}/{python3,meson,ninja}/current/bin | tr ' ' ':'):\${PATH}\" \
    \"${cwsw}/ninja/current/bin/ninja\" -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  find ${ridir}/bin/ ! -type d | grep 'sh$' | xargs rm -f
  env PATH=\"\$(echo -n ${cwsw}/{python3,meson,ninja}/current/bin | tr ' ' ':'):\${PATH}\" \
    \"${cwsw}/ninja/current/bin/ninja\" -C build install
  mv \"${ridir}/bin/ksh\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/ksh\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/sh\"
  find \"${ridir}/bin/\" -type f | xargs \$(\${CC} -dumpmachine)-strip --strip-all
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
