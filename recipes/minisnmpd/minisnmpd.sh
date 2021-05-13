rname="minisnmpd"
rver="1.6"
rdir="${rname//is/i-s}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/${rdir%-*}/releases/download/v${rver}/${rfile}"
rsha256="77bc704a4ed4fdc386e2ba2e972d9457564c84abef7e9af5de5a2a231e5a9efe"
rreqs="make pkgconfig libconfuse"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG s,sys/sysinfo,linux/sysinfo,g linux.c
  ./configure ${cwconfigureprefix} --with-config --without-systemd
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
