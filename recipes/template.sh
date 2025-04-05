rname="name"
rver="1.2.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="http://fake.url/${rname}/${rfile}"
rdlfile="${cwdl}/${rname}/${rfile}"
rsha256="123456..."
rprof="${cwetcprofd}/${rname}.sh"
rbdir="${cwbuild}/${rdir}"
rtdir="${cwsw}/${rname}"
ridir="${rtdir}/${rdir}"
rreqs="fakereq1 fakereq2"

. "${cwrecipe}/common.sh"

#
# notes
#
# the "crosware install pkgname" command will run a function it finds corresponding to:
#
#  cwinstall_pkgname
#
# uninstall will do the same, albeit with cwuninstall_pkgname
#
# quoting may be tricky depending on required expansion time
# toybox and busybox have somewhat complicated expansion setups
#
# a completely self-contained custom install function is all that's necessary for a simple recipe
# configure/make/make install *should* work out of the box with only the ^r vars above and the common.sh source
#
# the following functions are defined in common.sh, hopefully with sane defaults
# functions can be defined on a per-recipe basis
# functions in a recipe file override those from common.sh, on a case-by-case basis
#
#  cwcheckreqs_${rname}
#  cwclean_${rname}
#  cwconfigure_${rname}
#  cwfetch_${rname}
#  cwgenprofd_${rname}
#  cwinstall_${rname}
#  cwmakeinstall_${rname}
#  cwmake_${rname}
#  cwmarkinstall_${rname}
#  cwuninstall_${rname}
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
  pushd "${cwbuild}" &>/dev/null
  custom
  clean
  commands
  popd &>/dev/null
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
  pushd "${rbdir}" &>/dev/null
  ./configure --prefix="${ridir}" --custom-flag
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" &>/dev/null
  make -custom...
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" &>/dev/null
  make install DESTDIR=...
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path "${rtdir}/current/bin"' > ${rprof}
}
"

eval "
function cwinstall_${rname}() {
  cwclean_${rname}
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwextract "${rdlfile}" "${cwbuild}"
  cwconfigure_${rname}
  cwmake_${rname}
  cwmakeinstall_${rname}
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
  cwclean_${rname}
}
"
