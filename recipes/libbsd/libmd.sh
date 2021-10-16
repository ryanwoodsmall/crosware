#
# XXX - safe to enable pkg-config bits *only*?
#

rname="libmd"
rver="1.0.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://libbsd.freedesktop.org/releases/${rfile}"
rsha256="f51c921042e34beddeded4b75557656559cf5b1f2448033b4c1eec11c07e530f"
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
