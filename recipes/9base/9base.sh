# should use git but jgit is slow
# https://github.com/ryanwoodsmall/suckless-misc/blob/master/rpm/SPECS/9base.spec
rname="9base"
rver="09e95a2d6f8dbafc6601147b2f5f150355813be6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://git.suckless.org/${rname}/snapshot/${rfile}"
rsha256="2a7d31a11cb68cd75a7720141cea26f053421064e2230e206c227efbe343d2d8"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="static-toolchain make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  grep -ril /usr/local/plan9 . \
  | grep -v '\.git' \
  | xargs sed -i "s#/usr/local/plan9#${cwsw}/${rname}/${rdir}#g"
  sed -i '/^PREFIX/d' config.mk
  sed -i '/^CC/d' config.mk
  echo "CC = \${CC}" >> config.mk
  echo "PREFIX = ${cwsw}/${rname}/${rdir}" >> config.mk
  if [[ $(uname -m) =~ x86_64 ]] ; then
    sed -i '/^OBJTYPE/d' config.mk
    echo "OBJTYPE = x86_64" >> config.mk
  elif [[ $(uname -m) =~ a(arch|rm) ]] ; then
    sed -i '/^OBJTYPE/d' config.mk
    echo "OBJTYPE = arm" >> config.mk
  fi
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export PLAN9=\"${cwsw}/${rname}/current\"' > "${rprof}"
  echo 'append_path \"\${PLAN9}/bin\"' >> "${rprof}"
}
"
