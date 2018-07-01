# XXX - shared by default, not messing with building static for now

rname="p7zip"
rver="16.02"
rdir="${rname}_${rver}"
rfile="${rdir}_src_all.tar.bz2"
rurl="http://prdownloads.sourceforge.net/${rname}/${rfile}"
rsha256="5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG \"s#=/usr/local#=${ridir}#g\" install.sh makefile.common
  sed -i.ORIG \"s#^CC=gcc#CC=\${CC}#g\" makefile.*
  sed -i.ORIG \"s#^CXX=g++#CXX=\${CXX}#g\" makefile.*
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
