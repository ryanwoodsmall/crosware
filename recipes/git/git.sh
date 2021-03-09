#
# XXX - mandoc with/instead of groff?
#

rname="git"
rver="2.30.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.kernel.org/pub/software/scm/${rname}/${rfile}"
rsha256="41f7d90c71f9476cd387673fcb10ce09ccbed67332436a4cc58d7af32c355faa"
rreqs="make bzip2 zlib openssl curl expat pcre2 perl gettexttiny libssh2 groff busybox less cacertificates"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \"${rurl//${rname}-${rver}/${rname}-manpages-${rver}}\" \"${rdlfile//${rname}-${rver}/${rname}-manpages-${rver}}\" \"5e64ace225e6dd0749b09c7adce765a538a922699c8997421ee255c3165e2aaa\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
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
  cwextract \"${rdlfile//${rname}-${rver}/${rname}-manpages-${rver}}\" \"${ridir}/share/man\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
