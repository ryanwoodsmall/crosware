rname="lz4"
rver="1.10.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/lz4/lz4/archive/${rfile}"
rsha256="537512904744b35e232912055ccf8ec66d768639ff3abe5788d90d792ec5f48b"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG 's/ln -s/ln -sf/g' Makefile.inc
  sed -i 's/ln -sff/ln -sf/g' Makefile.inc
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make -j${cwmakejobs} ${rlibtool} {PREFIX,prefix}=\"\$(cwidir_${rname})\" BUILD_SHARED=no
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool} {PREFIX,prefix}=\"\$(cwidir_${rname})\" BUILD_SHARED=no
  popd &>/dev/null
}
"


eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
