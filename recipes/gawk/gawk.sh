rname="gawk"
rver="5.2.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="3c1fce1446b4cbee1cd273bd7ec64bc87d89f61537471cd3e05e33a965a250e9"
rreqs="bootstrapmake sed"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-extensions \
    --disable-mpfr \
    --disable-nls \
    --disable-pma \
    --without-readline
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
