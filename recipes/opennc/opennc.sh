rname="opennc"
rver="1.89"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
#rurl="http://systhread.net/coding/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="b75684ae80c1635f06a6aff56ff142c128abbfeec0fdcc979679c1cc7e6e6ecd"
rreqs="gettexttiny glib libbsd make pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make CC=\"\${CC}\" CFLAGS=\"\${CFLAGS} \$(pkg-config --cflags libbsd-overlay)\" LIBS=\"\$(pkg-config --libs glib-2.0 libbsd-overlay) -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  install -D -m 755 nc \"${ridir}/bin/${rname}\"
  ln -sf \"${ridir}/bin/${rname}\" \"${ridir}/bin/nc\"
  install -D -m 644 nc.1 \"${ridir}/share/man/man1/${rname}.1\"
  ln -sf \"${ridir}/share/man/man1/${rname}.1\" \"${ridir}/share/man/man1/nc.1\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
