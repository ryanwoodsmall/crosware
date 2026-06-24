#
# XXX - man pages need pod2man/perl
#     - or they're included now? i dunno
#
# XXX - add file extension detection and json mime info for StatFile?
#
# XXX - example conf:
#     Port 1080
#     Listen 192.168.123.234/24
#     Timeout 600
#     Allow 192.168.123.0/24
#     LogLevel Info
#
rname="tinyproxy"
rver="1.11.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/tinyproxy/tinyproxy/releases/download/${rver}/${rfile}"
rsha256="9bcf46db1a2375ff3e3d27a41982f1efec4706cce8899ff9f33323a8218f7592"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-{debug,manpage_support} \
    --enable-{xtinyproxy,filter,upstream,reverse,transparent} \
    --with-stathost=\"${rname}-stats.crosware\" \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  cwmkdir \$(cwidir_${rname})/share/man/man{5,8}
  install -m 0644 docs/man5/tinyproxy.conf.5 \"\$(cwidir_${rname})/share/man/man5/\"
  install -m 0644 docs/man8/tinyproxy.8 \"\$(cwidir_${rname})/share/man/man8/\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
