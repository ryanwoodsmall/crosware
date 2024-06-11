#
# XXX - git-svn mirror more reliablabe that sourceforge at this point?
# XXX - https://github.com/snipsnipsnip/tinyscheme
# XXX - rlwrap broke somewhere, repeats keypresses, ugh - screen reset sometimes fixes?
#
rname="tinyscheme"
rver="1.42"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/${rname}/files/${rname}/${rdir}/${rfile}/download"
rsha256="17b0b1bffd22f3d49d5833e22a120b339039d2cfda0b46d6fc51dd2f01b407ad"
rreqs="make rlwrap"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/^SYS_LIBS=/s/$/ -static/g' makefile
  sed -i.ORIG '/putstr.*prompt/s/;/;fflush(stdout);/g' scheme.c
  sed -i 's#init.scm#${rtdir}/current/share/${rname}/init.scm#g' scheme.c
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  strip --strip-all scheme
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/${rname}\"
  install -m 0755 scheme \"\$(cwidir_${rname})/bin/${rname}.bin\"
  install -m 0644 init.scm \"\$(cwidir_${rname})/share/${rname}/init.scm\"
  echo '#!/usr/bin/env bash' > \"\$(cwidir_${rname})/bin/${rname}\"
  echo 'rlwrap -C ${rname} -pYellow -m -M .scm -q\\\" \"${rtdir}/current/bin/${rname}.bin\" \"\${@}\"' >> \"\$(cwidir_${rname})/bin/${rname}.rlwrap\"
  ln -sf ${rname}.rlwrap \"\$(cwidir_${rname})/bin/${rname}\"
  chmod 755 \$(cwidir_${rname})/bin/${rname}{,.rlwrap}
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
