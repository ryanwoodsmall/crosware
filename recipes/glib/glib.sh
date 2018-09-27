rname="glib"
rver="2.56.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="http://ftp.gnome.org/pub/gnome/sources/glib/2.56/${rfile}"
rsha256="a9a4c5b4c81b6c75bc140bdf5e32120ef3ce841b7413214ecf5f987acec74cb2"
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
