#
# XXX - quick/dirty, need openssl variant?
#
rname="oauthsign"
rver="24May2018"
rdir="oauth_sign"
rfile="${rdir}_${rver}.tar.gz"
rurl="https://acme.com/software/oauth_sign/${rfile}"
rsha256="213fa77e3f6a15b9164eead728d67299a0c9a34bec4aaf1a1b27df0a64f38e04"
ridir="${cwsw}/${rname}/${rdir}_${rver}"
rreqs="bootstrapmake libressl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat Makefile > Makefile.ORIG
  sed -i \"s,/usr/local,\$(cwidir_${rname}),g\" Makefile
  sed -i '/^CFLAGS/s|$| -Wl,-static -I${cwsw}/libressl/current/include|g' Makefile
  sed -i '/^LDFLAGS/s|$| -L${cwsw}/libressl/current/lib -static|g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwidir_${rname})/{bin,include,lib,man/man1}
  make install
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
