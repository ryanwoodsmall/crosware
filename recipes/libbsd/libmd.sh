#
# XXX - safe to enable pkg-config bits *only*?
#

rname="libmd"
rver="1.0.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://libbsd.freedesktop.org/releases/${rfile}"
rsha256="5a02097f95cc250a3f1001865e4dbba5f1d15554120f95693c0541923c52af4a"
rreqs="make"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} LDFLAGS='-static' CPPFLAGS=''
  popd >/dev/null 2>&1
}
"

#eval "
#function cwgenprofd_${rname}() {
#  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
#  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
#  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
#}
#"
