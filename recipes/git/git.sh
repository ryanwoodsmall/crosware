rname="git"
rver="2.16.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.kernel.org/pub/software/scm/${rname}/${rfile}"
rsha256="6e69b0e9c487e5da52a14d4829f0b6a28b2c18a0bb6fb67c0dc8b5b5658bd532"
rreqs="make bzip2 zlib openssl curl expat pcre2 perl gettexttiny libssh2"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-curl \
    --with-expat \
    --with-libpcre2 \
    --with-openssl \
    --with-perl=${cwsw}/perl/current/bin/perl \
    --without-python \
    --without-tcltk \
      CC=\"\${CC}\" \
      CXX=\"\${CXX}\" \
      CFLAGS=\"\${CFLAGS}\" \
      CXXFLAGS=\"\${CXXFLAGS}\" \
      LDFLAGS=\"\${LDFLAGS}\" \
      LIBS='-lssl -lcrypto -lz -lssh2'
  sed -i.ORIG 's/-lcurl/-lcurl -lssl -lcrypto -lssh2/g' Makefile
  grep -ril sys/poll\\.h ${rbdir}/ \
  | grep \\.h\$ \
  | xargs sed -i.ORIG 's#sys/poll\.h#poll.h#g'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
