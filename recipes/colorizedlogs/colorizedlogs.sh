rname="colorizedlogs"
rver="2.7"
rdir="colorized-logs-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/kilobyte/colorized-logs/archive/refs/tags/${rfile}"
rsha256="1fb97c9c90efd739f03dabd8cf5825c2afc95d1f1e0d6cacf62d53a8c540b3df"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  echo > config.h
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  for a in ansi2html ansi2txt ttyrec2ansi ; do
    echo \${a}
    \${CC} \${a}.c -o \${a} -static -Os -Wl,-s -Wl,-static
  done
  echo pipetty
  echo '#define HAVE_PTY_H 1' >> config.h
  echo '#define HAVE_FUNC_OPENPTY 1' >> config.h
  \${CC} pipetty.c signals.c -o pipetty -static -Os -Wl,-s -Wl,-static
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  for a in ansi2html ansi2txt ttyrec2ansi pipetty ; do
    install -m 755 \${a} \"\$(cwidir_${rname})/bin/\${a}\"
    install -m 644 \${a}.1 \"\$(cwidir_${rname})/share/man/man1/\${a}.1\"
  done
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
