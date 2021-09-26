rname="mandoc"
rver="1.14.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://mandoc.bsd.lv/snapshots/${rfile}"
rsha256="8bf0d570f01e70a6e124884088870cbed7537f36328d512909eb10cd53179d9c"
rreqs="make zlib busybox less manpages"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/env -i make/s/env -i/env/g' configure
  {
    echo 'PREFIX=\"${ridir}\"'
    echo 'WWWPREFIX=\"${ridir}/www\"'
    echo 'HTDOCDIR=\"${ridir}/www/htdocs\"'
    echo 'CGIBINDIR=\"${ridir}/www/htdocs/cgi-bin\"'
    echo 'BUILD_CGI=1'
    echo 'INSTALL_LIBMANDOC=1'
    echo 'UTF8_LOCALE=en_US.UTF-8'
    echo 'HAVE_WCHAR=1'
  } > configure.local
  cat cgi.h.example > cgi.h
  sed -i '/MAN_DIR/s#/man#${cwsw}/manpages/current/share/man#g' cgi.h
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
  local s
  for s in 1 3 5 7 8 ; do
    cwmkdir \"${ridir}/man/man\${s}\"
    install -m 0644 *.\${s} \"${ridir}/man/man\${s}/\"
  done
  unset s
  cwmkdir \"${cwsw}/manpages/current/share/man\"
  #echo \"${cwsw}/manpages/current/share/man\" > \"${cwsw}/manpages/current/share/man/manpath.conf\"
  echo \"/man\" > \"${cwsw}/manpages/current/share/man/manpath.conf\"
  ln -sf \"${cwsw}/manpages/current/share/man\" \"${ridir}/www/htdocs/man\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
