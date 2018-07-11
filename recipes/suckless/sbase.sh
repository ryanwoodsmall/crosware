# should use git instead, but jgit is slow
# https://github.com/ryanwoodsmall/suckless-misc/blob/master/rpm/SPECS/sbase.spec
rname="sbase"
rver="7441770cfd70bbd3caafd6cf035dd74a860741ae"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://git.suckless.org/${rname}/snapshot/${rfile}"
rsha256="0d8e661630713b519aa83664dc98cd6c5f54b3bc1a81a87f654140b35588fd5b"
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
  make sbase-box
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  make sbase-box-install
  popd >/dev/null 2>&1
}
"
