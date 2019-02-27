rname="git"
rver="2.21.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.kernel.org/pub/software/scm/${rname}/${rfile}"
rsha256="8ccb1ce743ee991d91697e163c47c11be4bf81efbdd9fb0b4a7ad77cc0020d28"
rreqs="make bzip2 zlib openssl curl expat pcre2 perl gettexttiny libssh2 groff busybox less"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${cwdl}/${rname}/${rfile}\" \"${rsha256}\"
  cwfetchcheck \"${rurl//${rname}-${rver}/${rname}-manpages-${rver}}\" \"${cwdl}/${rname}/${rfile//${rname}-${rver}/${rname}-manpages-${rver}}\" \"2f68dc24931c0d05f70167d9ffe6c33ef6b0b6c75b92301ddcda55b9b0f5ec51\"
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
