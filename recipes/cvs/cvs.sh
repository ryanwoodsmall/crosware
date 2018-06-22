rname="cvs"
rver="1.11.23"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://ftp.gnu.org/non-gnu/${rname}/source/stable/${rver}/${rfile}"
rsha256="400f51b59d85116e79b844f2d5dbbad4759442a789b401a94aa5052c3d7a4aa9"
rreqs="make sed zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG 's/^getline /getline_OFF /g' lib/getline.c 
  sed -i.ORIG '/getline __PROTO/ s/getline /getline_OFF /g' lib/getline.h 
  ./configure ${cwconfigureprefix} --with-ssh 
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
