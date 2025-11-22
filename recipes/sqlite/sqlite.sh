#
# XXX - look at alpine: https://git.alpinelinux.org/aports/tree/main/sqlite/APKBUILD
# XXX - and at ALL the options... https://sqlite.org/compile.html
# XXX - editline? probably not, libeditminimal though?
# XXX - minimal/tiny variant?
# XXX - separate out linenoise variant, make that minimal?
# XXX - clean this up!
# XXX - ORIGIN / REPLICA - sqlite3_rsync?
# XXX - extra tools (sqldiff, sqlite3_analyze, ...) need full source code .zip
#
rname="sqlite"
rver="3510000"
rdir="${rname}-autoconf-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.sqlite.org/2025/${rfile}"
rsha256="42e26dfdd96aa2e6b1b1be5c88b0887f9959093f650d693cb02eb9c36d146ca5"
rreqs="make netbsdcurses readlinenetbsdcurses zlib"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetch_linenoise
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  cwextract \"\$(cwdlfile_linenoise)\" \"\$(cwbdir_${rname})\"
}
"

eval "
function cwmakeinstall_${rname}_readline() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    export CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\"
    export LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\"
    export LIBS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -lreadline -lcurses -lterminfo -lz -static\"
    export PKG_CONFIG_{LIBDIR,PATH}=
    ./configure ${cwconfigureprefix} --disable-shared --with-readline-ldflags=\"\${LDFLAGS} \${LIBS}\" --with-readline-cflags=\"\${CPPFLAGS}\"
    make -j${cwmakejobs} ${rlibtool}
  )
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 sqlite3 \"\$(cwidir_${rname})/bin/sqlite3-readline\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}_linenoise() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make clean || true
  (
    export CPPFLAGS=\"-I${cwsw}/zlib/current/include\"
    export LDFLAGS=\"-L${cwsw}/zlib/current/lib -static\"
    export LIBS=\"-L${cwsw}/zlib/current/lib -lz -static\"
    export PKG_CONFIG_{LIBDIR,PATH}=
    ./configure ${cwconfigureprefix} --disable-shared --disable-readline --disable-editline --with-linenoise=\"\$(cwbdir_${rname})/\$(cwdir_linenoise)\"
    make -j${cwmakejobs} ${rlibtool}
  )
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 sqlite3 \"\$(cwidir_${rname})/bin/sqlite3-linenoise\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}_minimal() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make clean || true
  (
    export CPPFLAGS=\"-I${cwsw}/zlib/current/include\"
    export LDFLAGS=\"-L${cwsw}/zlib/current/lib -static\"
    export LIBS=\"-L${cwsw}/zlib/current/lib -lz -static\"
    export PKG_CONFIG_{LIBDIR,PATH}=
    ./configure ${cwconfigureprefix} --disable-shared --disable-readline --disable-editline
    make -j${cwmakejobs} ${rlibtool}
    : make sqldiff ${rlibtool}
    : make sqlite3_analyzer ${rlibtool}
  )
  install -m 755 sqlite3 \"\$(cwidir_${rname})/bin/sqlite3-minimal\"
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmakeinstall_${rname}_readline
  cwmakeinstall_${rname}_linenoise
  cwmakeinstall_${rname}_minimal
  make install ${rlibtool}
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
