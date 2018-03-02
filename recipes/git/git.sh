rname="git"
rver="2.16.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.kernel.org/pub/software/scm/${rname}/${rfile}"
rsha256="9acc4339b7a2ab484eea69d705923271682b7058015219cf5a7e6ed8dee5b5fb"
rreqs="make bzip2 zlib openssl curl expat pcre2 perl gettexttiny"

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
      LIBS='-lssl -lcrypto -lz'
  sed -i.ORIG 's/-lcurl/-lcurl -lssl -lcrypto/g' Makefile
  for h in \$(grep -ril sys/poll\\.h ${rbdir}/ | grep \\.h\$) ; do
    sed -i.ORIG 's#sys/poll\.h#poll.h#g' \${h}
  done
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
