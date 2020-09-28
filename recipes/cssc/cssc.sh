rname="cssc"
rver="1.4.1"
rdir="CSSC-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="d1bed0c80246ee4cd49d0aa45307c075d0876fe531057bb1c8b28f5330d651ef"
rreqs="make sed configgit"

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
