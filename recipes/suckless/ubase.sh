rname="ubase"
rver="604b66ae8b4005d89eed1cbab45a64cb57e75390"
rdir="${rname}-${rver}"
rurl="https://git.suckless.org/${rname}"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="make"
rbdir="${cwbuild}/${rname}"
rfile=""
rsha256=""

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cd \"${cwbuild}\"
  rm -rf \"${rname}\"
  jgit clone \"${rurl}\"
  cd \"${rname}\"
  jgit checkout \"${rver}\"
}
"

eval "
function cwextract_${rname}() {
  cwscriptecho \"cwextract_${rname} noop\"
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
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
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make ${rname}-box
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make ${rname}-box-install
  popd >/dev/null 2>&1
}
"
