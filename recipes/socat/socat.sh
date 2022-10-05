#
# XXX - simple ptp tunnel over dtls
#   server:
#     px5g selfsigned -newkey rsa:2048 -keyout server.key -out server.crt -subj /CN=server
#     socat -d -d openssl-dtls-server:8444,cert=server.crt,key=server.key,cafile=client.crt,fork,reuseaddr tun:192.168.123.1/24,tun-name=tun0,iff-up
#   client:
#     px5g selfsigned -newkey rsa:2048 -keyout client.key -out client.crt -subj /CN=client
#     socat -d -d openssl-dtls-client:server:8444,cert=client.crt,key=client.key,cafile=server.crt tun:192.168.123.2/24,tun-name=tun0,iff-up
rname="socat"
rver="1.7.4.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="http://www.dest-unreach.org/${rname}/download/${rfile}"
rsha256="d47318104415077635119dfee44bcfb41de3497374a9a001b1aff6e2f0858007"
rreqs="make openssl netbsdcurses readlinenetbsdcurses zlib"

. "${cwrecipe}/common.sh"

# XXX - non-patch versions of alpine fixes
#  https://git.alpinelinux.org/cgit/aports/tree/main/socat
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --enable-openssl \
    --enable-readline \
    --disable-libwrap \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      LIBS=\"-lreadline -lcurses -lterminfo -lssl -lcrypto -lz\"
  echo '#define NETDB_INTERNAL (-1)' >> compat.h
  sed -i 's#netinet/if_ether#linux/if_ether#g' sysincludes.h
  echo '#undef HAVE_GETPROTOBYNUMBER_R' >> config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
