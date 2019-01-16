rname="mpc"
rver="1.0.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="617decc6ea09889fb08ede330917a00b16809b8db88c29c31bfbb49cbf88ecc3"
rreqs="make gmp mpfr"

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
