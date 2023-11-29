#
# XXX - look at alpine: https://git.alpinelinux.org/aports/tree/main/sqlite/APKBUILD
# XXX - and at ALL the options... https://sqlite.org/compile.html
# XXX - editline? probably not, libeditminimal though?
# XXX - unofficial looking linenoise support?
# XXX - custom make install builds w/readline and bare; configure/build twice is slow/wasteful
#

rname="sqlite"
rver="3440200"
rdir="${rname}-autoconf-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.sqlite.org/2023/${rfile}"
rsha256="1c6719a148bc41cf0f2bbbe3926d7ce3f5ca09d878f1246fcc20767b175bb407"
rreqs="make netbsdcurses readlinenetbsdcurses zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG s/termcap/terminfo/g configure
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --enable-readline \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    LIBS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -lreadline -lcurses -lterminfo -lz -static\"
  popd >/dev/null 2>&1
}
"

#eval "
#function cwmakeinstall_${rname}() {
#  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
#  make install ${rlibtool}
#  make clean || true
#  make distclean || true
#  install -m 755 \"\$(cwidir_${rname})/bin/sqlite3\" \"\$(cwidir_${rname})/bin/sqlite3-readline\"
#  rm -f \"\$(cwidir_${rname})/bin/sqlite3\"
#  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --disable-readline --disable-editline \
#    CPPFLAGS=\"-I${cwsw}/\" \
#    LDFLAGS=\"-L${cwsw}/zlib/current/lib -static\" \
#    LIBS=\"-L${cwsw}/zlib/current/lib -lz -static\"
#  make -j${cwmakejobs} ${rlibtool}
#  make install ${rlibtool}
#  install -m 755 \"\$(cwidir_${rname})/bin/sqlite3\" \"\$(cwidir_${rname})/bin/sqlite3-minimal\"
#  ln -sf sqlite3-readline \"\$(cwidir_${rname})/bin/sqlite3\"
#  popd >/dev/null 2>&1
#}
#"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
