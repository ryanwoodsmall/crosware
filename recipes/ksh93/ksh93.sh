#
# XXX - rename to bare ksh w/o 93? probably not...
# XXX - rename to ksh2020? probably
# XXX - need VISUAL=emacs ???
# XXX - EDITOR=???
# XXX - meson is a mess
# XXX - this is no longer supported. crap
#

rname="ksh93"
rver="2020.0.0"
rdir="${rname%%93}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/att/ast/releases/download/${rver}/${rfile}"
rsha256="3d6287f9ad13132bf8e57a8eac512b36a63ccce2b1e4531d7a946c5bf2375c63"
rreqs="meson ninja muslfts bash busybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  local m=\$(\${CC} -dumpmachine)
  pushd \"${rbdir}\" >/dev/null 2>&1
  echo -n > cross.ini
  echo '[binaries]' >> cross.ini
  echo \"ld = 'bfd'\" >> cross.ini
  echo \"c = '\${m}-gcc'\" >> cross.ini
  echo \"ar = '\${m}-ar'\" >> cross.ini
  echo \"as = '\${m}-as'\" >> cross.ini
  echo \"cpp = '\${m}-cpp'\" >> cross.ini
  echo \"strip = '\${m}-strip'\" >> cross.ini
  echo '[properties]' >> cross.ini
  echo \"c_args = '-I${cwsw}/muslfts/current/include'\" >> cross.ini
  echo \"c_link_args = '-L${cwsw}/muslfts/current/lib -lfts -static'\" >> cross.ini
  cat cross.ini > native.ini
  rm -rf build
  env \
    CXXFLAGS= CFLAGS= CC= CXX= LD= AR= STRIP= CPP= AS= CPPFLAGS= LDFLAGS= \
    PATH=\"${cwsw}/ccache/current/bin:${cwsw}/python3/current/bin:${cwsw}/statictoolchain/current/bin:${cwsw}/bash/current/bin:${cwsw}/busybox/current/bin:${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin\" \
      \"${cwsw}/meson/current/bin/meson\" setup --prefix \"${ridir}\" --default-library static --cross-file cross.ini --native-file native.ini build \"${rbdir}\"
  popd >/dev/null 2>&1
  unset m
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \"${cwsw}/ninja/current/bin/ninja\" -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  rm -f \"${ridir}/bin/ksh*\"
  \"${cwsw}/ninja/current/bin/ninja\" -C build install
  mv \"${ridir}/bin/ksh\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/ksh\"
  strip --strip-all \"${ridir}/bin/${rname}\" \"${ridir}/bin/shcomp\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
