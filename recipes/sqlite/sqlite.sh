#
# XXX - look at alpine: https://git.alpinelinux.org/aports/tree/main/sqlite/APKBUILD
# XXX - and at ALL the options... https://sqlite.org/compile.html
# XXX - editline? probably not, libeditminimal though?
# XXX - unofficial looking linenoise support?
# XXX - custom make install builds w/readline and bare; configure/build twice is slow/wasteful
# XXX - minimal/tiny variant?
#
rname="sqlite"
rver="3470200"
rdir="${rname}-autoconf-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.sqlite.org/2024/${rfile}"
rsha256="f1b2ee412c28d7472bc95ba996368d6f0cdcf00362affdadb27ed286c179540b"
rreqs="make netbsdcurses readlinenetbsdcurses zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG s/termcap/terminfo/g configure
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --enable-readline \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    LIBS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -lreadline -lcurses -lterminfo -lz -static\" \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  install -m 755 \"\$(cwidir_${rname})/bin/sqlite3\" \"\$(cwidir_${rname})/bin/sqlite3-readline\"
  make clean || true
  make distclean || true
  rm -f \"\$(cwidir_${rname})/bin/sqlite3\"
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --disable-readline --disable-editline \
    CPPFLAGS=\"-I${cwsw}/zlib/current/include\" \
    LDFLAGS=\"-L${cwsw}/zlib/current/lib -static\" \
    LIBS=\"-L${cwsw}/zlib/current/lib -lz -static\" \
    PKG_CONFIG_{LIBDIR,PATH}=
  make -j${cwmakejobs} ${rlibtool}
  make install ${rlibtool}
  install -m 755 \"\$(cwidir_${rname})/bin/sqlite3\" \"\$(cwidir_${rname})/bin/sqlite3-minimal\"
  ln -sf sqlite3-readline \"\$(cwidir_${rname})/bin/sqlite3\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
