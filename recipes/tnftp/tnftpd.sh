rname="tnftpd"
rver="20200704"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftpd-20200704.tar.gz"
rsha256="92de915e1b4b7e4bd403daac5d89ce67fa73e49e8dda18e230fa86ee98e26ab7"
rreqs="make configgit byacc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --enable-ipv6 \
    --without-pam \
      YACC=\"${cwsw}/byacc/current/bin/byacc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  rm -rf \"${ridir}/sbin\"
  make install
  test -e \"${ridir}/sbin/${rname}\" || ln -sf \"${rtdir}/current/libexec\" \"${ridir}/sbin\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
