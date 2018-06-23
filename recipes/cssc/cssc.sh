rname="cssc"
rver="1.4.0"
rdir="CSSC-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="30146f96c26c2a4c6b742bc8a498993ec6ea9f289becaaf566866488600b2994"
rreqs="make sed"

. "${cwrecipe}/common.sh"

# XXX - testutils dir breaks on arm 32b
eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG '/^SUBDIRS/ s/testutils//g' Makefile.{am,in}
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --enable-binary
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
