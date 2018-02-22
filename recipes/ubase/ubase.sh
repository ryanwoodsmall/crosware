# should use git but jgit is slow
# https://github.com/ryanwoodsmall/suckless-misc/blob/master/rpm/SPECS/ubase.spec
rname="ubase"
rver="55795531f03ccb5a41cf80fd564b862c103252cc"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://git.suckless.org/${rname}/snapshot/${rfile}"
rsha256="cd5f5346fe4cc5b8e486532202e80f75ee46144d33b2678b133b137d5e4fa8d2"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="jgitsh static-toolchain make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  sed -i '/^PREFIX/d' config.mk
  sed -i '/^CC/d' config.mk
  sed -i '/^AR/d' config.mk
  sed -i '/^LDFLAGS/d' config.mk
  echo "CC = \${CC}" >> config.mk
  echo "AR = \${AR}" >> config.mk
  echo "LDFLAGS = \${LDFLAGS}" >> config.mk
  echo "PREFIX = ${cwsw}/${rname}/${rdir}" >> config.mk
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname}/current/bin\"' > "${rprof}"
}
"

eval "
function cwmake_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  make ubase-box
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  make ubase-box-install
  popd >/dev/null 2>&1
}
"
