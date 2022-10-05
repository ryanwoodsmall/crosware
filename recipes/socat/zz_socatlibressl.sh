rname="socatlibressl"
rver="$(cwver_socat)"
rdir="$(cwdir_socat)"
rfile="$(cwfile_socat)"
rdlfile="$(cwdlfile_socat)"
rurl="$(cwurl_socat)"
rsha256=""
rreqs="make libressl netbsdcurses readlinenetbsdcurses"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

local f
for f in clean extract fetch ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%libressl}
  }
  "
done
unset f

# XXX - non-patch versions of alpine fixes
# XXX - ugly symlinks
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --enable-openssl \
    --enable-readline \
    --disable-libwrap \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      LIBS=\"-lreadline -lcurses -lterminfo -lssl -lcrypto\" \
      PKG_CONFIG_LIBDIR= \
      PKG_CONFIG_PATH=
  echo '#define NETDB_INTERNAL (-1)' >> compat.h
  sed -i 's#netinet/if_ether#linux/if_ether#g' sysincludes.h
  cwmkdir \"\$(cwidir_${rname})/bin\"
  ln -sf ${rname%libressl} \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf ${rname%libressl} \"\$(cwidir_${rname})/bin/${rname%libressl}-libressl\"
  if [[ ${karch} =~ ^arm ]] ; then
    sed -i.ORIG s/Gethostbyname/gethostbyname/g xio-ip.c
  fi
  echo '#undef HAVE_GETPROTOBYNUMBER_R' >> config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir%libressl}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir%libressl}libressl/current/bin\"' >> \"${rprof}\"
}
"
