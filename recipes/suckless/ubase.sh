# should use git but jgit is slow
# https://github.com/ryanwoodsmall/suckless-misc/blob/master/rpm/SPECS/ubase.spec
rname="ubase"
rver="604b66ae8b4005d89eed1cbab45a64cb57e75390"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://git.suckless.org/${rname}/snapshot/${rfile}"
rsha256="0a8cf4e93b4a8137df91ef8544a2ef6889427d6ebb764622115fc2c52f833649"
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
