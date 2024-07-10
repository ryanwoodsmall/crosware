rname="gdbm"
rver="1.24"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="695e9827fdf763513f133910bc7e6cfdb9187943a4fec943e57449723d2b8dbf"
rreqs="make sed configgit netbsdcurses readlinenetbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-nls \
    --enable-libgdbm-compat \
    --with-readline \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LIBS='-lreadline -lcurses -lterminfo -static -s' \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  install -m 755 \"\$(cwidir_${rname})/bin/gdbmtool\" \"\$(cwidir_${rname})/bin/gdbmtool-readline\"
  make clean || true
  make distclean || true
  rm -f \"\$(cwidir_${rname})/bin/gdbmtool\"
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --disable-nls --enable-libgdbm-compat --without-readline \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  make -j${cwmakejobs} ${rlibtool}
  make install ${rlibtool}
  install -m 755 \"\$(cwidir_${rname})/bin/gdbmtool\" \"\$(cwidir_${rname})/bin/gdbmtool-minimal\"
  ln -sf gdbmtool-readline \"\$(cwidir_${rname})/bin/gdbmtool\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
