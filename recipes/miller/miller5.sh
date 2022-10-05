rname="miller5"
rver="5.10.3"
rdir="${rname%5}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/johnkerl/miller/releases/download/v${rver}/${rfile}"
rsha256="bbab4555c2bc207297554b0593599ea2cd030a48ad1350d00e003620e8d3c0ea"
rreqs="make sed flex"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i 's/-g -pg//g' c/Makefile.am c/Makefile.in
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  ln -sf mlr \"${ridir}/bin/mlr5\"
  ln -sf mlr \"${ridir}/bin/${rname}\"
  ln -sf mlr \"${ridir}/bin/${rname%5}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
