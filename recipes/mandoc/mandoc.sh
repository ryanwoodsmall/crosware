#
# XXX - conditionally check one of our less
#     if which -a less | grep -q ${cwsw} ; then
#       if ! $(which -a less | grep ${cwsw} | head -1) --version |& grep -qE '^less [0-9]+' ; then
#         ...
#       fi
#     fi
#
rname="mandoc"
rver="1.14.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://mandoc.bsd.lv/snapshots/${rfile}"
rsha256="8bf0d570f01e70a6e124884088870cbed7537f36328d512909eb10cd53179d9c"
rreqs="make zlib busybox"

. "${cwrecipe}/common.sh"

eval "
function cwreqs_${rname}() {
  rreqs=\"${rreqs}\"
  if command -v less &>/dev/null ; then
    if ! less --version |& tr '\\t' ' ' | tr -s ' ' | head -1 | grep -qE '^less [0-9]+ ' ; then
      rreqs=\"less ${rreqs}\"
    fi
  else
    rreqs=\"less ${rreqs}\"
  fi
  echo \"\${rreqs}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/env -i make/s/env -i/env/g' configure
  {
    echo PREFIX=\"\$(cwidir_${rname})\"
    echo WWWPREFIX=\"\$(cwidir_${rname})/www\"
    echo HTDOCDIR=\"\$(cwidir_${rname})/www/htdocs\"
    echo CGIBINDIR=\"\$(cwidir_${rname})/www/htdocs/cgi-bin\"
    echo BUILD_CGI=1
    echo INSTALL_LIBMANDOC=1
    echo UTF8_LOCALE=en_US.UTF-8
    echo HAVE_WCHAR=1
  } > configure.local
  cat cgi.h.example > cgi.h
  sed -i '/MAN_DIR/s#/man#${cwsw}/manpages/current/share/man#g' cgi.h
  env PATH=\"\$(echo ${cwsw}/{ccache{4,},statictoolchain,less{,minimal},${rreqs// /,}}/current/bin | tr ' ' ':')\" \
    ./configure
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"\$(echo ${cwsw}/{ccache{4,},statictoolchain,less{,minimal},${rreqs// /,}}/current/bin | tr ' ' ':')\" \
    make CFLAGS=\"\${CFLAGS} -I${cwsw}/zlib/current/include\" LDFLAGS=\"-L${cwsw}/zlib/current/lib -static\" CPPFLAGS=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"\$(echo ${cwsw}/{ccache{4,},statictoolchain,less{,minimal},${rreqs// /,}}/current/bin | tr ' ' ':')\" \
    make install CFLAGS=\"\${CFLAGS} -I${cwsw}/zlib/current/include\" LDFLAGS=\"-L${cwsw}/zlib/current/lib -static\" CPPFLAGS=
  local s
  for s in 1 3 5 7 8 ; do
    cwmkdir \"\$(cwidir_${rname})/man/man\${s}\"
    install -m 0644 *.\${s} \"\$(cwidir_${rname})/man/man\${s}/\"
  done
  unset s
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
