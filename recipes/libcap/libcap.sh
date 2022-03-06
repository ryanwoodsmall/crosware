rname="libcap"
rver="2.55"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/${rfile}"
rsha256="b92817960bc5a725b34927493e48a6b74f26b6202269bdf0734e344c7777ccfb"
rreqs="make perl attr"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make lib=lib prefix=\"${ridir}\" GOLANG=no
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cd libcap
  make install-static lib=lib prefix=\"${ridir}\" GOLANG=no
  cd -
  cd progs
  make install lib=lib prefix=\"${ridir}\" GOLANG=no
  cd -
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
