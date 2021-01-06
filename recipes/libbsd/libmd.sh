rname="libmd"
rver="1.0.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://libbsd.freedesktop.org/releases/${rfile}"
rsha256="dc66b8278f82e7e1bf774fbd4bc83a0348e8f27afa185b2c2779cfcb3da25013"
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
