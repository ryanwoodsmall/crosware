#
# XXX - module failures
#       build zlib/curses/readline/openssl/bzip2 with -fPIC
#
# Failed to build these modules:
# _bsddb
# _sqlite3
# _tkinter
# dbm
# gdbm
# nis
#

rname="python2"
rver="2.7.15"
rdir="Python-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.python.org/ftp/python/${rver}/${rfile}"
rsha256="22d9b1ac5b26135ad2b8c2901a9413537e08749a753356ee913c84dbd2df5574"
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
