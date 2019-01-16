rname="mpfr"
rver="3.1.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="761413b16d749c53e2bfd2b1dfaa3b027b0e793e404b90b5fbaeef60af6517f5"
rreqs="make gmp"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --enable-{static,shared}{,=yes} LDFLAGS=\"\${LDFLAGS//-static/}\" CFLAGS=\"-fPIC\" CXXFLAGS=\"-fPIC\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
