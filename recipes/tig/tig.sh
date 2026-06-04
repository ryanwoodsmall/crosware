rname="tig"
rver="2.6.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jonas/tig/releases/download/${rdir}/${rfile}"
rsha256="99d4a0fdd3d93547ebacfe511195cb92e4f75b91644c06293c067f401addeb3e"
rreqs="make ncurses readline git pkgconfig pcre2"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    --with-pcre
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  local m=0
  for m in 1 5 7 ; do
    cwmkdir \$(cwidir_${rname})/share/man/man\${m}
    install -m 0644 doc/*.\${m} \$(cwidir_${rname})/share/man/man\${m}/
  done
  unset m
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
