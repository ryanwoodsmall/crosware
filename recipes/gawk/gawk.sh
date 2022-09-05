rname="gawk"
rver="5.2.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="e4ddbad1c2ef10e8e815ca80208d0162d4c983e6cca16f925e8418632d639018"
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
