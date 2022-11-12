#
# XXX - libbsd+libmd? server/client seem to work but not sure what else it would proivde
#
rname="opensshminimal"
rver="$(cwver_openssh)"
rdir="$(cwdir_openssh)"
rfile="$(cwfile_openssh)"
rdlfile="$(cwdlfile_openssh)"
rurl="$(cwurl_openssh)"
rsha256="$(cwsha256_openssh)"
rreqs="bootstrapmake zlib netbsdcurses libeditnetbsdcurses"

. "${cwrecipe}/common.sh"

for f in clean fetch extract ; do
eval "
function cw${f}_${rname}() {
  cw${f}_${rname%minimal}
}
"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-security-key \
    --sysconfdir=\"${cwetc}/openssh\" \
    --with-libedit=\"${cwsw}/libeditnetbsdcurses/current\" \
    --with-mantype=man \
    --with-privsep-path=\"${cwtmp}/empty\" \
    --without-openssl \
    --without-pie \
    --without-security-key-builtin \
      CFLAGS=\"\${CFLAGS} -Wl,-s -Os\" \
      CXXFLAGS=\"\${CXXFLAGS} -Wl,-s -Os\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-lz -ledit -lcurses -lterminfo'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf ssh \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf ssh \"\$(cwidir_${rname})/bin/openssh\"
  ln -sf ssh \"\$(cwidir_${rname})/bin/openssh-ssh\"
  ln -sf scp \"\$(cwidir_${rname})/bin/openssh-scp\"
  ln -sf sftp \"\$(cwidir_${rname})/bin/openssh-sftp\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir%minimal}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir%minimal}/current/sbin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
