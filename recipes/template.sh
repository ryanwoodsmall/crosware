rname="name"
rver="1.2.3"
rurl="http://fake.url/${rname}/${rname}-${rver}.tar.bz2"
rfile="$(basename ${rurl})"
rdir="${rfile//.tar.bz2/}"
rsha256="123456..."
rprof="${cwetcprofd}/${rname}.sh"

. "${cwrecipe}/common.sh"

#
# notes
#
# the "crosware install pkgname" command will run a function it finds corresponding to:
#
#  cwinstall_pkgname
#
# the following functions are defined in common.sh, hopefully with sane defaults
# functions can be defined on a per-recipe basis
# functions in a recipe file override those from common.sh, on a case-by-case basis
#
#  cwclean_${rname}
#  cwfetch_${rname}
#  cwconfigure_${rname}
#  cwmake_${rname}
#  cwmakeinstall_${rname}
#  cwgenprofd_${rname}
#  cwinstall_${rname}
#
# any function from bin/crosware can be used
# these may be useful
#
#  cwfetch
#  cwchecksha256sum
#  cwfetchcheck
#  cwextract
#  ...
#

#
# full examples
#

eval "
function cwclean_${rname}() {
  pushd "${cwbuild}" >/dev/null 2>&1
  custom
  clean
  commands
  popd >/dev/null 2>&1
}
"

eval "
function cwfetch_${rname}() {
  wget custom
  curl fetch
  jgit.sh commands
}
"

eval "
function cwconfigure_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  ./configure --prefix="${cwsw}/${rname}/${rdir}" --custom-flag
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  make -custom...
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  make install DESTDIR=...
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo "\\\# ${rname}" > "${rprof}"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwclean_${rname}
  cwextract "${cwdl}/${rfile}" "${cwbuild}"
  cwconfigure_${rname}
  cwmake_${rname}
  cwmakeinstall_${rname}
  cwlinkdir "${rdir}" "${cwsw}/${rname}"
  cwgenprofd_${rname}
  cwclean_${rname}
}
"
