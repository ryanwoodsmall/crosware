#
# XXX - build against shared gc
#   remove slibtool req
#   configure:
#     ./configure ${cwconfigureprefix} \
#       LIBS='-L${cwsw}/gc/current/lib -lgc' \
#       CFLAGS=\"\${CFLAGS//-Wl,-static/} -Wl,-rpath=${cwsw}/gc/current/lib\" \
#       CXXFLAGS=\"\${CXXFLAGS//-Wl,-static/} -Wl,-rpath=${cwsw}/gc/current/lib\" \
#       LDFLAGS=\"\${LDFLAGS//-static/}\"
#   make:
#     make -j${cwmakejobs} || make -j${cwmakejobs}
#

rname="guile"
rver="2.2.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="fc3073f12d43650e643dc0111730b73a9fa11f131b9b72f66d01e82d83e685a7"
rreqs="make sed gawk gmp libtool slibtool pkgconfig libffi gc readline ncurses libunistring"

. "${cwrecipe}/common.sh"

if [[ ${karch} =~ ^(i.86|armv) ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"recipe ${rname} does not support architecture ${karch}\"
}
"
fi

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
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
