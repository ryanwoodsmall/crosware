rname="glib"
rver="2.56.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.acc.umu.se/pub/gnome/sources/${rname}/2.56/${rfile}"
rsha256="ecef6e17e97b8d9150d0e8a4b3edee1ac37331213b8a2a87a083deea408a0fc7"
rreqs="gettexttiny libffi make perl pkgconfig python2 zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-pcre=internal \
    --disable-libmount \
    --disable-gtk-doc \
    --disable-compile-warnings \
    --disable-fam \
    --with-python=python2.7
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
