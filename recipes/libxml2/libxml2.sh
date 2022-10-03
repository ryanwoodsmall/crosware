rname="libxml2"
rver="2.10.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://download.gnome.org/sources/${rname}/${rver%.*}/${rfile}"
rsha256="2dd33110ea778676de14bea4999ee1173c4ca55d5ff1452bca224e06f0152595"
rreqs="make xz zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-ftp \
    --with-legacy \
    --without-python
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include/${rname}\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
