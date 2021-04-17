rname="socatlibressl"
rver="$(cwver_socat)"
rdir="$(cwdir_socat)"
rfile="$(cwfile_socat)"
rdlfile="$(cwdlfile_socat)"
rurl="$(cwurl_socat)"
rsha256=""
rreqs="make libressl netbsdcurses"
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
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --enable-openssl \
    --enable-readline \
    --disable-libwrap \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include -I${cwsw}/netbsdcurses/current/include/readline -I${cwsw}/libressl/current/include\" \
      LDFLAGS=\"-L${cwsw}/libressl/current/lib -L${cwsw}/netbsdcurses/current/lib\" \
      LIBS=\"-lreadline -lcurses -lterminfo -lssl -lcrypto\" \
      PKG_CONFIG_LIBDIR= \
      PKG_CONFIG_PATH=
  echo '#define NETDB_INTERNAL (-1)' >> compat.h
  sed -i 's#netinet/if_ether#linux/if_ether#g' sysincludes.h
  cwmkdir \"${ridir}/bin\"
  ln -sf ${rname%libressl} \"${ridir}/bin/${rname}\"
  ln -sf ${rname%libressl} \"${ridir}/bin/${rname%libressl}-libressl\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir%libressl}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir%libressl}libressl/current/bin\"' >> \"${rprof}\"
}
"
