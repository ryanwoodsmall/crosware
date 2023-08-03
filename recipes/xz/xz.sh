rname="xz"
rver="5.4.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://tukaani.org/${rname}/${rfile}"
rurl="https://github.com/tukaani-project/xz/releases/download/v${rver}/${rfile}"
rsha256="aae39544e254cfd27e942d35a048d592959bd7a79f9a624afb0498bb5613bdf8"
rreqs="make gettexttiny slibtool patch"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-doc \
    --disable-nls \
      LIBTOOL=\"${cwsw}/slibtool/current/bin/slibtool-static -all-static\" \
      LDFLAGS=-static \
      CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
