#
# XXX - debian gitlab instance, not sure SHA-256 will always be the same for archive...
# XXX - pull bundle from repo? https://repo.or.cz/nvi.git
#

rname="nvi"
rver="1.81.6-16"
rdir="${rname}-debian-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://salsa.debian.org/debian/${rname}/-/archive/debian/${rver}/${rfile}"
rsha256="de5278be023eb932bbfe62b0333764842c65aedb2f44b8cc824761acf1801dd1"
rreqs="make netbsdcurses bdb47 configgit slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
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
      LIBS='-lcurses -lterminfo -ldb -static'
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}/build.unix\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}/build.unix\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  rm -f ${ridir}/bin/{nex,nvi,nview}
  make install-strip ${rlibtool}
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/nex\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/nview\"
  popd >/dev/null 2>&1
}
"
eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
