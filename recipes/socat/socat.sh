#
# XXX - funky int64/uint64 formatting stuff on 32-bit. ugh
#
rname="socat"
rver="1.7.4.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="http://www.dest-unreach.org/${rname}/download/${rfile}"
rsha256="c8273b30e933be0ad8d509ae75e19ecedf1a60081bb942ed36f2dd8950de3d58"
rreqs="make openssl netbsdcurses zlib"

. "${cwrecipe}/common.sh"

# XXX - non-patch versions of alpine fixes
#  https://git.alpinelinux.org/cgit/aports/tree/main/socat
eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --enable-openssl \
    --enable-readline \
    --disable-libwrap \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include -I${cwsw}/netbsdcurses/current/include/readline -I${cwsw}/openssl/current/include -I${cwsw}/zlib/current/include\" \
      LDFLAGS=\"-L${cwsw}/openssl/current/lib -L${cwsw}/netbsdcurses/current/lib -L${cwsw}/zlib/current/lib -static\" \
      LIBS=\"-lreadline -lcurses -lterminfo -lssl -lcrypto -lz\"
  echo '#define NETDB_INTERNAL (-1)' >> compat.h
  sed -i 's#netinet/if_ether#linux/if_ether#g' sysincludes.h
  if [[ ${uarch} =~ ^(i.86|armv) ]] ; then
    cat config.h > config.h.ORIG
    sed -i '/HAVE_BASIC_UINT64_T/s/ 8 / 6 /g' config.h
    sed -i '/HAVE_BASIC_INT64_T/s/ 7 / 5 /g' config.h
    diff -Naur config.h{.ORIG,} || true
  fi
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
