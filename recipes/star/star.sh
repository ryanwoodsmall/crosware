rname="star"
rver="1.5.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://sourceforge.net/projects/s-tar/files/${rfile}/download"
rsha256="070342833ea83104169bf956aa880bcd088e7af7f5b1f8e3d29853b49b1a4f5b"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  chmod 644 autoconf/xconfig.h.in
  echo '#define HAVE_DLERROR 1' >> autoconf/xconfig.h.in
  echo '#define HAVE_USLEEP 1' >> autoconf/xconfig.h.in
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make GMAKE_NOWARN=true
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make GMAKE_NOWARN=true INS_BASE=/ DEST_DIR=\"${ridir}\" install
  ln -sf \"${rname}\" \"${ridir}/bin/pax\"
  rm -f \"${ridir}/bin/tar\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
