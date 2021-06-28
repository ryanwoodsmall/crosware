rname="socatminimal"
rver="$(cwver_socat)"
rdir="$(cwdir_socat)"
rfile="$(cwfile_socat)"
rdlfile="$(cwdlfile_socat)"
rurl="$(cwurl_socat)"
rsha256=""
rreqs="bootstrapmake"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

local f
for f in clean extract fetch ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%minimal}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-openssl \
    --disable-readline \
    --disable-libwrap \
    --disable-fips \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_LIBDIR= \
      PKG_CONFIG_PATH=
  echo '#define NETDB_INTERNAL (-1)' >> compat.h
  sed -i 's#netinet/if_ether#linux/if_ether#g' sysincludes.h
  cwmkdir \"${ridir}/bin\"
  ln -sf ${rname%minimal} \"${ridir}/bin/${rname}\"
  ln -sf ${rname%minimal} \"${ridir}/bin/${rname%minimal}-${rname#socat}\"
  if [[ ${karch} =~ ^arm ]] ; then
    sed -i.ORIG s/Gethostbyname/gethostbyname/g xio-ip.c
  fi
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir%minimal}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir%minimal}libressl/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
