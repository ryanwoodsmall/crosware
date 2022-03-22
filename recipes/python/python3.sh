#
# XXX - enable readline tab completion/history in pythonrc
# XXX - conditionally set PYTHONSTARTUP in profile.d file
# XXX - example at https://gist.github.com/ryanwoodsmall/72b60ec679e4a1680c7eb7639694afd1
# XXX - full shared: add "--enable-shared" and set LDFLAGS=\"\${LDFLAGS//-static/} -Wl,-rpath,${rtdir}/current/lib\"
# XXX - uuid support is in e2fsprogs
# XXX - move to libressl to avoid perl dep in openssl?
# XXX - shared build should enable venv to work
# XXX - "minimal" variant: libressl (no perl prereq), netbsdcurses+readline, dbm/gdbm/ndbm (via gdbm), sqlite, libffi, ...
# XXX - sabotage patch for netbsd-curses https://github.com/sabotage-linux/sabotage/blob/06a4a815/KEEP/python2710-curses.patch
# XXX - standalone builds, crib?: https://github.com/indygreg/python-build-standalone
# XXX - ninja/meson cruft is ugly, need real separation
#
rname="python3"
rver="3.7.13"
rdir="Python-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.python.org/ftp/python/${rver}/${rfile}"
rsha256="99f106275df8899c3e8cb9d7c01ce686c202ef275953301427194693de5bef84"
rreqs="make bzip2 zlib ncurses readline openssl gdbm sqlite bdb47 expat libffi xz utillinux pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-ensurepip=install \
    --with-dbmliborder=gdbm:bdb \
    --with-system-{expat,ffi} \
      LDFLAGS=\"\${LDFLAGS//-static/}\" \
      CFLAGS='-fPIC' \
      CXXFLAGS='-fPIC' \
      LIBS='-lssl -lcrypto -lz -lncurses -lncursesw -lffi -llzma -lexpat'
  echo >> Modules/Setup.local
  echo 'readline readline.c -lreadline -lncurses -lncursesw' >> Modules/Setup.local
  echo '_ssl _ssl.c -DUSE_SSL -lssl -lcrypto -lz' >> Modules/Setup.local
  echo '_curses _cursesmodule.c -lncurses -lncursesw' >> Modules/Setup.local
  echo '_curses_panel _curses_panel.c -lpanel -lpanelw -lncurses -lncursesw' >> Modules/Setup.local
  #echo '_uuid _uuidmodule.c -luuid' >> Modules/Setup.local
  #echo \"dbm dbmmodule.c -lgdbm_compat -I${cwsw}/gdbm/current/include\" >> Modules/Setup.local
  sed -i.ORIG 's#/usr/include#/no/usr/include#g' setup.py
  local sld
  sld=\"\${LDFLAGS//-L}\"
  sld=\"\${sld//-static}\"
  sld=\"'\$(echo \${sld} | tr ' ' '\n' | grep ^/ | xargs echo | sed \"s/ /','/g\")'\"
  sed -i \"/system_lib_dirs =/s#= \[.*#= \[\${sld}\]#\" setup.py
  unset sld
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} \
    CFLAGS='-fPIC' \
    CXXFLAGS'=-fPIC' \
    LDFLAGS=\"\${LDFLAGS//-static/}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install \
    CFLAGS='-fPIC' \
    CXXFLAGS='-fPIC' \
    LDFLAGS=\"\${LDFLAGS//-static/}\"
  for p in ninja meson ; do
    if \$(cwcheckinstalled \${p}) ; then
      cwlinkdir_${rname}
      cwgenprofd_${rname}
      cwmarkinstall_${rname}
      cwinstall_\${p}
    fi
  done
  unset p
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
