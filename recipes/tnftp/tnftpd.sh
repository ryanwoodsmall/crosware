rname="tnftpd"
rver="20231001"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.netbsd.org/pub/NetBSD/misc/tnftp/${rfile}"
rsha256="24a51bd2e5818ddb8c2479df9c8175a78dd8a5ef49ee3ab09f5f39c35069826e"
rreqs="make configgit byacc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --enable-ipv6 \
    --without-pam \
      YACC=\"${cwsw}/byacc/current/bin/byacc\" \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  rm -rf \"\$(cwidir_${rname})/sbin\"
  make install
  test -e \"\$(cwidir_${rname})/sbin/${rname}\" || ln -sf \"${rtdir}/current/libexec\" \"\$(cwidir_${rname})/sbin\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
