#
# XXX - 2.1 breaks with dsa on newer nettle
# XXX - clean up packaged nettle stuff
# XXX - move to nettleminimal?
# XXX - drop recipe? lsh is... something
#
rname="lsh"
rver="2.0.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/pub/gnu/${rname}/${rfile}"
rsha256="614b9d63e13ad3e162c82b6405d1f67713fc622a8bc11337e72949d613713091"
rreqs="make gmp liboop netbsdcurses readlinenetbsdcurses zlib configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-assembler \
    --disable-gss \
    --disable-kerberos \
    --disable-pam \
    --disable-srp \
    --disable-utmp \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      LIBS=\"-lgmp -loop -lreadline -lcurses -lterminfo -lz -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  rm -rf \"\$(cwidir_${rname})/include\"
  rm -rf \"\$(cwidir_${rname})/lib\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
