#
# XXX - debian gitlab instance, not sure SHA-256 will always be the same for archive...
# XXX - pull bundle from repo? https://repo.or.cz/nvi.git
#
rname="nvi"
rver="1.81.6-20"
rdir="${rname}-debian-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://salsa.debian.org/debian/${rname}/-/archive/debian/${rver}/${rfile}"
rsha256="48744c8d9a4004fd8760f2ca842d56e8d96f298da1fb7cd1fab5ce2bc4cb9820"
rreqs="make netbsdcurses bdb47 configgit slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  local p
  for p in \$(cat debian/patches/series) ; do
    patch -p1 < debian/patches/\${p}
  done
  unset p
  cd build.unix
  sed -i.ORIG 's,/usr/tmp,/usr/tmp ${cwtop}/tmp,g' ../dist/configure
  ../dist/configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --program-prefix=n \
    --with-db=system \
    --disable-gtk \
    --disable-motif \
    --disable-perlinterp \
    --disable-tclinterp \
    --disable-dynamic-loading \
    --without-x \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include -I${cwsw}/bdb47/current/include\" \
      LDFLAGS=\"-static -L${cwsw}/netbsdcurses/current/lib -L${cwsw}/bdb47/current/lib\" \
      LIBS='-lcurses -lterminfo -ldb -static' \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})/build.unix\" &>/dev/null
  make -j${cwmakejobs} ${rlibtool}
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})/build.unix\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  rm -f \$(cwidir_${rname})/bin/{nex,nvi,nview}
  make install-strip ${rlibtool}
  ln -sf ${rname} \"\$(cwidir_${rname})/bin/nex\"
  ln -sf ${rname} \"\$(cwidir_${rname})/bin/nview\"
  popd &>/dev/null
}
"
eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
