#
# XXX - options from https://github.com/svaarala/duktape/blob/master/Makefile
#

rname="duktape"
rver="2.4.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/svaarala/${rname}/releases/download/v${rver}/${rfile}"
rsha256="86a89307d1633b5cedb2c6e56dc86e92679fc34b05be551722d8cc69ab0771fc"
rreqs="linenoise"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \${CC} -fPIC -Os -c -o src/${rname}.{o,c}
  \${CC} -fPIC -Os -c -o extras/console/duk_console.{o,c} -I./src
  \${CC} -fPIC -Os -c -o extras/print-alert/duk_print_alert.{o,c} -I./src
  \${CC} -fPIC -Os -c -o extras/module-duktape/duk_module_duktape.{o,c} -I./src
  ar rcs lib${rname}.a src/${rname}.o
  ar rcs lib${rname}_console.a src/${rname}.o extras/console/duk_console.o
  ar rcs lib${rname}_print_alert.a src/${rname}.o extras/print-alert/duk_print_alert.o
  ar rcs lib${rname}_module_duktape.a src/${rname}.o extras/module-duktape/duk_module_duktape.o
  \${CC} examples/cmdline/duk_cmdline.c \
    -o duk \
    -g \
    -DDUK_CMDLINE_FANCY \
    -DDUK_CMDLINE_CONSOLE_SUPPORT \
    -DDUK_CMDLINE_PRINTALERT_SUPPORT \
    -DDUK_CMDLINE_MODULE_SUPPORT \
    -DDUK_CMDLINE_FILEIO \
    -I./src -I./extras/console -I./extras/print-alert -I./extras/module-duktape \
    -L. -l${rname} -l${rname}_console -l${rname}_print_alert -l${rname}_module_duktape \
    -I\"${cwsw}/linenoise/current/include\" -L\"${cwsw}/linenoise/current/lib\" -llinenoise \
    -static
  \${CC} -I./src examples/eval/eval.c -o duk-eval -L. -l${rname} -static
  strip --strip-all duk{,-eval}
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
  install -m 644 lib${rname}*.a \"${ridir}/lib/\"
  install -m 644 src/${rname}.h \"${ridir}/include/\"
  install -m 644 src/duk_config.h \"${ridir}/include/\"
  install -m 644 extras/console/duk_console.h \"${ridir}/include/\"
  install -m 644 extras/print-alert/duk_print_alert.h \"${ridir}/include/\"
  install -m 644 extras/module-duktape/duk_module_duktape.h \"${ridir}/include/\"
  install -m 755 duk{,-eval} \"${ridir}/bin/\"
  ln -sf \"${rtdir}/current/bin/duk\" \"${ridir}/bin/${rname}\"
  #echo '#!/usr/bin/env bash' > \"${ridir}/bin/${rname}\"
  #echo 'rlwrap \"${rtdir}/current/bin/duk\" \"\${@}\"' >> \"${ridir}/bin/${rname}\"
  #chmod 755 \"${ridir}/bin/${rname}\"
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
