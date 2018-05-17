rname="glib"
rver="2.56.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="http://ftp.gnome.org/pub/gnome/sources/glib/2.56/${rfile}"
rsha256="40ef3f44f2c651c7a31aedee44259809b6f03d3d20be44545cd7d177221c0b8d"
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
