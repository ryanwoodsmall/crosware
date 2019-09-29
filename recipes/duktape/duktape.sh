#
# XXX - linenoise
# XXX - options from https://github.com/svaarala/duktape/blob/master/Makefile
#

rname="duktape"
rver="2.4.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/svaarala/${rname}/releases/download/v${rver}/${rfile}"
rsha256="86a89307d1633b5cedb2c6e56dc86e92679fc34b05be551722d8cc69ab0771fc"
rreqs="rlwrap"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env CFLAGS= CXXFLAGS= CPPFLAGS= LDFLAGS= \${CC} -fPIC -Os -c -o src/${rname}.{o,c}
  env CFLAGS= CXXFLAGS= CPPFLAGS= LDFLAGS= \${CC} -fPIC -Os -g -c -o src/${rname}{d.o,.c} 
  ar rcs lib${rname}.a src/${rname}.o
  ar rcs lib${rname}d.a src/${rname}d.o
  env CFLAGS= CXXFLAGS= CPPFLAGS= LDFLAGS= \${CC} -I./src examples/cmdline/duk_cmdline.c -o duk -L. -l${rname} -static
  strip --strip-all duk
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local d
  for d in bin include lib ; do
    cwmkdir \"${ridir}/\${d}\"
  done
  unset d
  install -m 644 lib${rname}{,d}.a \"${ridir}/lib/\"
  install -m 644 src/${rname}.h src/duk_config.h \"${ridir}/include/\"
  install -m 755 duk \"${ridir}/bin/\"
  echo '#!/usr/bin/env bash' > \"${ridir}/bin/${rname}\"
  echo 'rlwrap \"${rtdir}/current/bin/duk\" \"\${@}\"' >> \"${ridir}/bin/${rname}\"
  chmod 755 \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
