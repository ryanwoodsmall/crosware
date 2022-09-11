rname="lshsftpserver"
rver="2.1"
rdir="lsh-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/pub/gnu/lsh/${rfile}"
rsha256="8bbf94b1aa77a02cac1a10350aac599b7aedda61881db16606debeef7ef212e3"
rreqs="configgit bootstrapmake nettleminimal"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cd src/sftp/
  env PATH=\"${cwsw}/nettleminimal/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      CPPFLAGS=\"-I${cwsw}/nettleminimal/current/include\" \
      LDFLAGS=\"-L${cwsw}/nettleminimal/current/lib -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"${cwsw}/nettleminimal/current/lib/pkgconfig\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cd src/sftp/
  env PATH=\"${cwsw}/nettleminimal/current/bin:\${PATH}\" \
    make -j${cwmakejobs} ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cd src/sftp/
  env PATH=\"${cwsw}/nettleminimal/current/bin:\${PATH}\" \
    make install ${rlibtool}
  rm -f \"\$(cwidir_${rname})/bin/lsftp\"
  rm -f \"\$(cwidir_${rname})/share/man/man1/lsftp.1\" || true
  rmdir \"\$(cwidir_${rname})/bin\"
  rmdir \"\$(cwidir_${rname})/share/man/man1\" || true
  popd >/dev/null 2>&1
}
"
