rname="tig"
rver="2.6.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jonas/tig/releases/download/${rdir}/${rfile}"
rsha256="5adeabdcd93aa0423d618da8b878b53482bef6e0e9e1fe224acc0f18031fe91e"
rreqs="make ncurses readline git pkgconfig pcre2"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    --with-ncurses \
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
