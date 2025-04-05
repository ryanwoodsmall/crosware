#
# XXX - attr 2.5.x releases?
#

rname="attr"
rver="2.4.48"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://download.savannah.nongnu.org/releases/${rname}/${rfile}"
rsha256="5ead72b358ec709ed00bbf7a9eaef1654baad937c001c044fe8b74c57f5324e7"
rreqs="bootstrapmake slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --disable-nls
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
