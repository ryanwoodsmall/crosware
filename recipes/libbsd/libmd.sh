rname="libmd"
rver="1.0.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://libbsd.freedesktop.org/releases/${rfile}"
rsha256="e14eeb931cf85330f95ff822262d3033125488dfb2f867441e36e2d2c4a34c71"
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
