#
# XXX - gitiles instance, sha256 inconsistent
#

rname="htermutils"
rver="2b42e027b1d123eb4fdd4debb62a79ad471af212"
rdir="${rname}-${rver}"
rfile="etc.tar.gz"
rurl="https://chromium.googlesource.com/apps/libapps/+archive/${rver}/hterm/${rfile}"
rsha256=""
rreqs="busybox"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}/${rdir}\"
}
"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  true
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  mkdir -p \"${ridir}/bin\"
  mkdir -p \"${ridir}/share\"
  install -m 0755 *.sh \"${ridir}/bin/\"
  install -m 0644 *.el *.vim \"${ridir}/share/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
