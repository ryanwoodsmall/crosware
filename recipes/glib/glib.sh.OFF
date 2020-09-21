rname="glib"
rver="2.58.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="http://ftp.gnome.org/pub/gnome/sources/glib/${rver%.*}/${rfile}"
rsha256="8f43c31767e88a25da72b52a40f3301fefc49a665b56dc10ee7cc9565cbe7481"
rreqs="gettexttiny libffi make perl pkgconfig python2 zlib autoconf automake libtool slibtool m4"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cat > gtk-doc.make <<EOF
EXTRA_DIST =
CLEANFILES =
EOF
  touch INSTALL
  env PATH=\"${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH}\" \
    autoreconf -fiv -I${cwsw}/libtool/current/share/aclocal -I${cwsw}/pkgconfig/current/share/aclocal
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-pcre=internal \
    --disable-libmount \
    --disable-gtk-doc \
    --disable-compile-warnings \
    --disable-fam \
    --with-python=\"${cwsw}/python2/current/bin/python2.7\"
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
