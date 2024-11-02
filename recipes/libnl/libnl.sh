rname="libnl"
rver="3.11.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/thom311/libnl/releases/download/${rname}${rver//./_}/${rfile}"
rsha256="2a56e1edefa3e68a7c00879496736fdbf62fc94ed3232c0baba127ecfa76874d"
rreqs="make bison"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG 's#sys/poll.h#poll.h#g' include/netlink/netlink.h
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-silent-rules \
    --enable-cli=yes \
    --with-pic \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include/libnl3\"' >> \"${rprof}\"
  #echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
