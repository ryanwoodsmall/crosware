#
# XXX - enable readline tab completion/history in pythonrc
# XXX - conditionally set PYTHONSTARTUP in profile.d file
# XXX - example at https://gist.github.com/ryanwoodsmall/72b60ec679e4a1680c7eb7639694afd1
#
# Failed to build these modules:
#  _tkinter - tcl/tk, gui
#  bsddb185 - backwards compat
#  dl - deprecated
#  imageop - deprecated
#  nis - no yp/nis/nis+ with musl
#  sunaudiodev - deprecated
#

rname="python2"
rver="2.7.17"
rdir="Python-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.python.org/ftp/python/${rver}/${rfile}"
rsha256="4d43f033cdbd0aa7b7023c81b0e986fd11e653b5248dac9144d508f11812ba41"
rreqs="make bzip2 zlib ncurses readline openssl gdbm sqlite bdb47"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-ensurepip=install \
    --with-dbmliborder=gdbm:bdb \
    LDFLAGS=\"\${LDFLAGS//-static/}\" CPPFLAGS=\"\${CPPFLAGS}\" CFLAGS='-fPIC' CXXFLAGS='-fPIC'
  echo >> Modules/Setup.local
  echo 'readline readline.c -lreadline -lncurses' >> Modules/Setup.local
  echo '_ssl _ssl.c -DUSE_SSL -lssl -lcrypto -lz' >> Modules/Setup.local
  #echo \"dbm dbmmodule.c -lgdbm_compat -I${cwsw}/gdbm/current/include\" >> Modules/Setup.local
  sed -i.ORIG 's#/usr/include#/no/usr/include#g' setup.py
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
