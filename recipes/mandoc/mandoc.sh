rname="mandoc"
rver="1.14.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://mandoc.bsd.lv/snapshots/${rfile}"
rsha256="8219b42cb56fc07b2aa660574e6211ac38eefdbf21f41b698d3348793ba5d8f7"
rreqs="make zlib busybox less"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/env -i make/s/env -i/env/g' configure
  sed -i '/^PREFIX/s#^PREFIX=.*#PREFIX=${ridir}#g' configure
  sed -i '/^WWWPREFIX/s#^WWWPREFIX=.*#WWWPREFIX=${ridir}/www#g' configure
  sed -i '/^BUILD_CGI=/s/BUILD_CGI=.*/BUILD_CGI=1/g' configure
  sed -i '/^HTDOCDIR=/s#HTDOCDIR=.*#HTDOCDIR=${ridir}/www/htdocs#g' configure
  sed -i '/^CGIBINDIR=/s#CGIBINDIR=.*#CGIBINDIR=${ridir}/www/htdocs/cgi-bin#g' configure
  cat cgi.h.example > cgi.h
  env PATH=\"${cwsw}/ccache/current/bin:${cwsw}/statictoolchain/current/bin:${cwsw}/less/current/bin:${cwsw}/busybox/current/bin:${cwsw}/make/current/bin\" \
    ./configure
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/ccache/current/bin:${cwsw}/statictoolchain/current/bin:${cwsw}/less/current/bin:${cwsw}/busybox/current/bin:${cwsw}/make/current/bin\" \
    make CFLAGS=\"\${CFLAGS} \${CPPFLAGS}\" LDFLAGS=\"\${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/ccache/current/bin:${cwsw}/statictoolchain/current/bin:${cwsw}/less/current/bin:${cwsw}/busybox/current/bin:${cwsw}/make/current/bin\" \
    make install
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
