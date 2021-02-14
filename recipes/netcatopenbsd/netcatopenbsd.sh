#
# XXX - gitlab instance, not sure SHA-256 will always be the same for archive...
# XXX - for git archive:
#  rver="6c331794cf0bc6b609b5cd15c581ac0ea0a30b27"
#  rurl="https://salsa.debian.org/debian/netcat-openbsd/-/archive/${rver}/${rfile}"
#

rname="netcatopenbsd"
rver="1.203-2"
rdir="netcat-openbsd-debian-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://salsa.debian.org/debian/netcat-openbsd/-/archive/debian/${rver}/${rfile}"
rsha256="ef58398dbeb2ab290e30b45870e8967c8a1484ce5092daaad8c68ca2e0a9321a"
rreqs="make libbsd pkgconfig libmd"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \"https://github.com/libressl-portable/portable/raw/a7f031ba55ac4a69263000357eb7f6d7fb88101a/apps/nc/compat/base64.c\" \"${cwdl}/${rname}/base64.c\" \"503fbd88a48a0f255b9f0620db18ebb58be8ea088d51da3f9b825785b344be86\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  for p in \$(cat debian/patches/series) ; do
    patch -p1 < debian/patches/\${p}
  done
  sed -i.ORIG 's/in6\\.h/in.h/g' {netcat,socks}.c
  sed -i 's#netinet/in\\.h#netinet/ip.h#g;s#linux/in\\.h#netinet/ip.h#g' {netcat,socks}.c
  cp \"${cwdl}/${rname}/base64.c\" .
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    \${CC} -o ${rname} base64.c netcat.c atomicio.c socks.c \$(pkg-config --cflags libbsd) \$(pkg-config --libs libbsd) -L${cwsw}/libmd/current/lib -lmd -static
  \$(\${CC} -dumpmachine)-strip --strip-all ${rname}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man1\"
  install -m 0755 ${rname} \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/netcat-openbsd-debian\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/netcat-openbsd\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/nc\"
  install -m 0644 nc.1 \"${ridir}/share/man/man1/${rname}.1\"
  ln -sf ${rname}.1 \"${ridir}/share/man/man1/netcat-openbsd-debian.1\"
  ln -sf ${rname}.1 \"${ridir}/share/man/man1/netcat-openbsd.1\"
  ln -sf ${rname}.1 \"${ridir}/share/man/man1/nc.1\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
