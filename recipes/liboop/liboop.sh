rname="liboop"
rver="1.0.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://ftp.lysator.liu.se/pub/${rname}/${rfile}"
rsha256="56af16ad65e7397dadc8268e37ff6f67431db390c60c75e21a33e12b0e0d17e0"
rreqs="make netbsdcurses readlinenetbsdcurses configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --without-adns \
    --without-glib \
    --without-libwww \
    --without-tcl \
    --with-readline \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\" \
      LIBS=\"-lreadline -lcurses -lterminfo -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  rm -f \"\$(cwidir_${rname})/lib/pkgconfig/${rname}-glib2.pc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
