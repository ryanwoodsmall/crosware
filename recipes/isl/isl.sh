rname="isl"
rver="0.21"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
#rurl="https://gcc.gnu.org/pub/gcc/infrastructure/${rfile}"
#rurl="http://isl.gforge.inria.fr/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="d18ca11f8ad1a39ab6d03d3dcb3365ab416720fcb65b42d69f34f51bf0a0e859"
rreqs="make gmp mpfr mpc configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
