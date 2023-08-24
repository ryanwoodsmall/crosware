#
# XXX - probably need a separate "luashared" recipe so MOST of this only has to be done once. ugh.
# XXX - separate luarocks recipe...
# XXX - lib{readline,history}.so stuff needs work...
# XXX - luarocks is pretty dependent on shared libs for ffi, etc.; probably _only_ useful for readline here
#
rname="fennel"
rfennelver="1.3.1"
# "vendor" a recent/system version of lua (needs to be shared)
rluaver="$(cwver_lua)"
# append lua version to fennel version so they kinda move in lockstep
rver="${rfennelver}-${rluaver}"
rdir="${rname}-${rfennelver}"
rfile="${rdir}"
rurl="https://fennel-lang.org/downloads/${rfile}"
rsha256="40a64d31a69803213d0e56f839814d5a13ae6fc40cc435b0c3be294e2ccda1ca"
rreqs="make netbsdcurses readlinenetbsdcurses"
rprof="${cwetcprofd}/zz_${rname}.sh"
# no separate recipe for luarocks for now
rluarocksver="3.9.2"

# XXX - luarocks need a real wget... libressl/gnutlsminimal are smallest!
if ! wget --version 2>&1 | grep -q 'GNU Wget' ; then
  rreqs+=" wgetlibressl"
fi

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetch_lua
  cwfetch \"https://luarocks.org/releases/luarocks-${rluarocksver}.tar.gz\" \"${cwdl}/luarocks/luarocks-${rluarocksver}.tar.gz\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_lua)\" \"\$(cwbdir_${rname})\"
  cwextract \"${cwdl}/luarocks/luarocks-${rluarocksver}.tar.gz\" \"\$(cwbdir_${rname})\"
}
"

eval "
function cwmakeinstall_readline_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  mkdir libreadline
  cd libreadline
  cwscriptecho \"creating a fat libreadline.so from...\"
  for l in ${cwsw}/readlinenetbsdcurses/current/lib/libreadline.a ${cwsw}/netbsdcurses/current/lib/libcurses.a ${cwsw}/netbsdcurses/current/lib/libterminfo.a ; do
    echo - \$l
    cp \$l .
    \${AR} x \$l
  done
  unset l
  \${AR} -r libreadline.a *.o
  cwcreatesharedlib \$(cwbdir_${rname})/libreadline/libreadline.a \$(cwidir_${rname})/lib/libreadline.so
  cd -
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_lua_${rname}() {
  pushd \"\$(cwbdir_${rname})/\$(cwdir_lua)\" >/dev/null 2>&1
  (
    unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS PKG_CONFIG_{LIBDIR,PATH}
    local COMPFLAGS
    COMPFLAGS+=\" -fPIC \"
    COMPFLAGS+=\" -Wl,-rpath-link,${rtdir}/current/lib \"
    COMPFLAGS+=\" -Wl,-rpath,${rtdir}/current/lib \"
    COMPFLAGS+=\" -I\$(cwidir_${rname})/include \"
    COMPFLAGS+=\" -L\$(cwidir_${rname})/lib \"
    for r in {readline,}netbsdcurses ; do
      COMPFLAGS+=\" -I${cwsw}/\${r}/current/include \"
    done
    unset r
    sed -i.ORIG \"s#^INSTALL_TOP=.*#INSTALL_TOP= \$(cwidir_${rname})#g\" Makefile
    sed -i.ORIG '/#define LUA_ROOT/s,^.*,#define LUA_ROOT \"'\$(cwidir_${rname})/'\",g' src/luaconf.h
    sed -i.ORIG \"/^CC=/s#gcc# \${CC} \${COMPFLAGS} #g\" src/Makefile
    unset COMPFLAGS
    make linux-readline
    make install
    for l in lua{,c,rocks{,-admin}} ; do
      ln -sf \$l \$(cwidir_${rname})/bin/${rname}-\$l
    done
    unset l
    cwcreatesharedlib \$(cwidir_${rname})/lib/liblua.{a,so}
  )
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_luarocks_${rname}() {
  pushd \"\$(cwbdir_${rname})/luarocks-${rluarocksver}\" >/dev/null 2>&1
  (
    unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS PKG_CONFIG_{LIBDIR,PATH}
    env \
      PATH=\"\$(cwidir_${rname})/bin:\${PATH}\" \
      LD_LIBRARY_PATH=\"\$(cwidir_${rname})/lib\" \
        ./configure \
          --prefix=\"\$(cwidir_${rname})\" \
          --with-lua=\"\$(cwidir_${rname})\" \
          --force-config
    env \
      PATH=\"\$(cwidir_${rname})/bin:\${PATH}\" \
      LD_LIBRARY_PATH=\"\$(cwidir_${rname})/lib\" \
        make install
    env \
      PATH=\"\$(cwidir_${rname})/bin:\${PATH}\" \
      LD_LIBRARY_PATH=\"\$(cwidir_${rname})/lib\" \
        \$(cwidir_${rname})/bin/luarocks install readline {HISTORY,READLINE}_DIR=$cwsw/readlinenetbsdcurses/current
  )
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmakeinstall_readline_${rname}
  cwmakeinstall_lua_${rname}
  cwmakeinstall_luarocks_${rname}
  cwmkdir \$(cwidir_${rname})/bin
  install -m 755 \$(cwdlfile_${rname}) \$(cwidir_${rname})/bin/\$(cwfile_${rname})
  ln -sf \$(cwfile_${rname}) \$(cwidir_${rname})/bin/${rname}
  sed -i 's,^#!/usr/bin/env.*,#!${rtdir}/current/bin/lua,' \$(cwidir_${rname})/bin/\$(cwfile_${rname})
  rm -rf \$(cwidir_${rname})/${rname}-bin
  cwmkdir \$(cwidir_${rname})/${rname}-bin
  cd \$(cwidir_${rname})/${rname}-bin
  ln -sf ../bin/${rname}-* ./
  ln -sf ../bin/${rname} ./${rname}
  cd -
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/${rname}-bin\"' > \"${rprof}\"
}
"
