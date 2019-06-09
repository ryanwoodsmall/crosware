rname="git"
rver="2.22.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.kernel.org/pub/software/scm/${rname}/${rfile}"
rsha256="159e4b599f8af4612e70b666600a3139541f8bacc18124daf2cbe8d1b934f29f"
rreqs="make bzip2 zlib openssl curl expat pcre2 perl gettexttiny libssh2 groff busybox less"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${cwdl}/${rname}/${rfile}\" \"${rsha256}\"
  cwfetchcheck \"${rurl//${rname}-${rver}/${rname}-manpages-${rver}}\" \"${cwdl}/${rname}/${rfile//${rname}-${rver}/${rname}-manpages-${rver}}\" \"4e2cfda33d8e86812bfcdb907478d1144412ce472c32edd0219b3c0201c7ee3a\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"\${cwsw}/curl/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} \
      --with-curl \
      --with-expat \
      --with-libpcre2 \
      --with-openssl \
      --with-perl=${cwsw}/perl/current/bin/perl \
      --without-iconv \
      --without-python \
      --without-tcltk \
        CC=\"\${CC}\" \
        CXX=\"\${CXX}\" \
        CFLAGS=\"\${CFLAGS}\" \
        CXXFLAGS=\"\${CXXFLAGS}\" \
        LDFLAGS=\"\${LDFLAGS}\" \
        LIBS='-lcurl -lssh2 -lssl -lcrypto -lz'
  sed -i.ORIG 's/-lcurl/-lcurl -lssh2 -lssl -lcrypto -lz/g' Makefile
  grep -ril sys/poll\\.h ${rbdir}/ \
  | grep \\.h\$ \
  | xargs sed -i.ORIG 's#sys/poll\.h#poll.h#g'
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} NO_GETTEXT=1 NO_ICONV=1 NO_MSGFMT_EXTENDED_OPTIONS=1
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} install NO_GETTEXT=1 NO_ICONV=1 NO_MSGFMT_EXTENDED_OPTIONS=1
  cwmkdir \"${ridir}/etc\"
  cwmkdir \"${ridir}/share/man\"
  tar -C \"${ridir}/share/man\" -Jxf \"${cwdl}/${rname}/${rfile//${rname}-${rver}/${rname}-manpages-${rver}}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
