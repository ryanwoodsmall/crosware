#
# XXX - xz 5.4.x is released, need to test compat
#
rname="xz"
rver="5.2.10"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://tukaani.org/${rname}/${rfile}"
rsha256="eb7a3b2623c9d0135da70ca12808a214be9c019132baaa61c9e1d198d1d9ded3"
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
