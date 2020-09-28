rname="gawk"
rver="5.1.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="cf5fea4ac5665fd5171af4716baab2effc76306a9572988d5ba1078f196382bd"
rreqs="bootstrapmake sed"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-extensions \
    --disable-mpfr \
    --disable-nls \
    --without-readline
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
