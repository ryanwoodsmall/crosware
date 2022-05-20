rname="colorizedlogs"
rver="2.6"
rdir="colorized-logs-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/kilobyte/colorized-logs/archive/refs/tags/${rfile}"
rsha256="d209d9fb45f5332ba4792624746f2bbbbcf425e6539fa69657e9602e2bee6570"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  echo > config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  for a in ansi2html ansi2txt ttyrec2ansi ; do
    echo \${a}
    \${CC} \${a}.c -o \${a} -static -Os -Wl,-s -Wl,-static
  done
  echo pipetty
  echo '#define HAVE_PTY_H 1' >> config.h
  echo '#define HAVE_FUNC_OPENPTY 1' >> config.h
  \${CC} pipetty.c signals.c -o pipetty -static -Os -Wl,-s -Wl,-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man1\"
  for a in ansi2html ansi2txt ttyrec2ansi pipetty ; do
    install -m 755 \${a} \"${ridir}/bin/\${a}\"
    install -m 644 \${a}.1 \"${ridir}/share/man/man1/\${a}.1\"
  done
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
