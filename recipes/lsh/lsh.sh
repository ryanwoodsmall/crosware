#
# XXX - 2.1 breaks with dsa on newer nettle
# XXX - clean up packaged nettle stuff
#
rname="lsh"
rver="2.0.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/pub/gnu/${rname}/${rfile}"
rsha256="614b9d63e13ad3e162c82b6405d1f67713fc622a8bc11337e72949d613713091"
rreqs="make gmp liboop netbsdcurses zlib configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-assembler \
    --disable-gss \
    --disable-kerberos \
    --disable-pam \
    --disable-srp \
    --disable-utmp \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include -I${cwsw}/gmp/current/include -I${cwsw}/liboop/current/include -I${cwsw}/zlib/current/include\" \
      LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -L${cwsw}/gmp/current/lib -L${cwsw}/liboop/current/lib -L${cwsw}/zlib/current/lib\" \
      LIBS=\"-lgmp -loop -lreadline -lcurses -lterminfo -lz -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  rm -rf \"${ridir}/include\"
  rm -rf \"${ridir}/lib\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
