#
# XXX - can't use cwfixupconfig_${rname} here due to weird layout of dist/build/etc.
#

rname="bdb47"
rver="4.7.25.NC"
rdir="db-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://download.oracle.com/berkeley-db/${rfile}"
rsha256="cd39c711023ff44c01d3c8ff0323eef7318660772b24f287556e6bf676a12535"
rreqs="make configgit"
rbdir="${cwbuild}/${rdir}/build_unix"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cd ../dist/
  mv config.guess{,.ORIG}
  mv config.sub{,.ORIG}
  install -m 0755 ${cwsw}/configgit/current/config.sub config.sub
  install -m 0755 ${cwsw}/configgit/current/config.guess config.guess
  cd \"${rbdir}\"
  ../dist/configure ${cwconfigureprefix} ${cwconfigurelibopts} --enable-compat185 --enable-cxx
  popd >/dev/null 2>&1
}
"

eval "
function cwclean_${rname}() {
  pushd "${cwbuild}" >/dev/null 2>&1
  rm -rf "${cwbuild}/${rdir}"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
