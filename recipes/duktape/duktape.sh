#
# XXX - options from https://github.com/svaarala/duktape/blob/master/Makefile
# XXX - DUK_USE_ES6
# XXX - jxpretty
#

rname="duktape"
rver="2.6.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/svaarala/${rname}/releases/download/v${rver}/${rfile}"
rsha256="96f4a05a6c84590e53b18c59bb776aaba80a205afbbd92b82be609ba7fe75fa7"
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
  \${CC} -fPIC -Os -c -o extras/module-node/duk_module_node.{o,c} -I./src
  \${CC} -fPIC -Os -c -o extras/logging/duk_logging.{o,c} -I./src
  ar rcs lib${rname}.a src/${rname}.o
  ar rcs lib${rname}_console.a extras/console/duk_console.o
  ar rcs lib${rname}_print_alert.a extras/print-alert/duk_print_alert.o
  ar rcs lib${rname}_module_duktape.a extras/module-duktape/duk_module_duktape.o
  ar rcs lib${rname}_module_node.a extras/module-node/duk_module_node.o
  ar rcs lib${rname}_logging.a extras/logging/duk_logging.o
  \${CC} examples/cmdline/duk_cmdline.c \
    -o duk \
    -g \
    -DDUK_CMDLINE_FANCY \
    -DDUK_CMDLINE_CONSOLE_SUPPORT \
    -DDUK_CMDLINE_PRINTALERT_SUPPORT \
    -DDUK_CMDLINE_MODULE_SUPPORT \
    -DDUK_CMDLINE_FILEIO \
    -DDUK_CMDLINE_LOGGING_SUPPORT \
    -I./src -I./extras/console -I./extras/print-alert -I./extras/module-duktape -I./extras/logging \
    -L. -l${rname} -l${rname}_console -l${rname}_print_alert -l${rname}_module_duktape -l${rname}_logging \
    -I\"${cwsw}/linenoise/current/include\" -L\"${cwsw}/linenoise/current/lib\" -llinenoise \
    -static
  \${CC} -I./src examples/cmdline/duk_cmdline.c -o duk-min -L. -l${rname} -static
  \${CC} -I./src examples/eval/eval.c -o duk-eval -L. -l${rname} -static
  strip --strip-all duk{,-{eval,min}}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local d
  for d in bin include lib polyfills wow ; do
    cwmkdir \"${ridir}/\${d}\"
  done
  unset d
  install -m 644 lib${rname}*.a \"${ridir}/lib/\"
  install -m 644 src/${rname}.h \"${ridir}/include/\"
  install -m 644 src/duk_config.h \"${ridir}/include/\"
  install -m 644 extras/console/duk_console.h \"${ridir}/include/\"
  install -m 644 extras/print-alert/duk_print_alert.h \"${ridir}/include/\"
  install -m 644 extras/module-duktape/duk_module_duktape.h \"${ridir}/include/\"
  install -m 644 extras/module-node/duk_module_node.h \"${ridir}/include/\"
  install -m 644 extras/logging/duk_logging.h \"${ridir}/include/\"
  install -m 644 polyfills/*.js \"${ridir}/polyfills/\"
  install -m 644 mandel.js \"${ridir}/wow/\"
  install -m 755 duk{,-{eval,min}} \"${ridir}/bin/\"
  ln -sf \"${rtdir}/current/bin/duk\" \"${ridir}/bin/${rname}\"
  #echo '#!/usr/bin/env bash' > \"${ridir}/bin/${rname}\"
  #echo 'rlwrap \"${rtdir}/current/bin/duk\" \"\${@}\"' >> \"${ridir}/bin/${rname}\"
  #chmod 755 \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
  \"${ridir}/bin/duk\" \"${ridir}/wow/mandel.js\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
