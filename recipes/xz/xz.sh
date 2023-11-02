rname="xz"
rver="5.4.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://tukaani.org/${rname}/${rfile}"
rurl="https://github.com/tukaani-project/xz/releases/download/v${rver}/${rfile}"
rsha256="135c90b934aee8fbc0d467de87a05cb70d627da36abe518c357a873709e5b7d6"
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
