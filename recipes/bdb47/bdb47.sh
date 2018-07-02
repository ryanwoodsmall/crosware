rname="bdb47"
rver="4.7.25.NC"
rdir="db-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://download.oracle.com/berkeley-db/${rfile}"
rsha256="cd39c711023ff44c01d3c8ff0323eef7318660772b24f287556e6bf676a12535"
rreqs="make"
rbdir="${cwbuild}/${rdir}/build_unix"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ../dist/configure ${cwconfigureprefix} ${cwconfigurelibopts} --enable-compat185 --enable-cxx
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
