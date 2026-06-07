rname="direvent"
rver="5.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/direvent/${rfile}"
rsha256="0e16c0b4b3e6f7673e9b4f31d81ab01236ad22f83538512f3b2f58f9f96fdcb7"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-nls \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
