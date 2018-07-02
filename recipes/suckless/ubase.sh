# should use git but jgit is slow
# https://github.com/ryanwoodsmall/suckless-misc/blob/master/rpm/SPECS/ubase.spec
rname="ubase"
rver="4f5837147a14e0fb8ec1a2a46a9c4045bdb75696"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://git.suckless.org/${rname}/snapshot/${rfile}"
rsha256="e8e0048ba8d383369f97fc7f340b7d82c0127342357aaf5f488675e1b786d75c"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i '/^PREFIX/d' config.mk
  sed -i '/^CC/d' config.mk
  sed -i '/^AR/d' config.mk
  sed -i '/^LDFLAGS/d' config.mk
  echo "CC = \${CC}" >> config.mk
  echo "AR = \${AR}" >> config.mk
  echo "LDFLAGS = \${LDFLAGS}" >> config.mk
  echo "PREFIX = ${ridir}" >> config.mk
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make ubase-box
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make ubase-box-install
  popd >/dev/null 2>&1
}
"
