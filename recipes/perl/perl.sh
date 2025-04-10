#
# XXX - sysroot should be recreated at build time in ${rtdir}/sysroot
# XXX - ... or sysroot virtual recipe. yeah, that
# XXX - sysroot creation should be moved to statictoolchain recipe!!!
# XXX - this is more of a perlminimal or perlstatic recipe - useful for bootstrapping openssl
# XXX - add perlopenssl and/or perllibressl for more featureful/shared builds for e.g. cpan+gitweb
# XXX - need a real minimal recipe
#

rname="perl"
rver="5.36.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.cpan.org/src/5.0/${rfile}"
rsha256="f2a1ad88116391a176262dd42dfc52ef22afb40f4c0e9810f15d561e6f1c726a"
rreqs="make toybox busybox byacc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  local sttop=\"${cwsw}/statictoolchain/current\"
  local starch=\"\$(\${CC} -dumpmachine)\"
  local stbin=\"\${sttop}/bin\"
  local stinc=\"\${sttop}/\${starch}/include\"
  local stlib=\"\${sttop}/\${starch}/lib\"
  mkdir -p sysroot/usr
  ln -sf \${stbin} sysroot/usr/bin
  ln -sf \${stinc} sysroot/usr/include
  ln -sf \${stlib} sysroot/usr/lib
  ln -sf \${stbin} sysroot/bin
  ln -sf \${stlib} sysroot/lib
  ./Configure -des \
    -Dinstallusrbinperl='undef' \
    -Dso='none' \
    -Ddlext='none' \
    -Dusedl='n' \
    -Dprefix=\"\$(cwidir_${rname})\" \
    -Dsysroot=\"\${PWD}/sysroot\" \
    -Dlibc=\"\${stlib}/libc.a\" \
    -Dcc=\"\${CC} \${CFLAGS} \${LDFLAGS}\"
  popd &>/dev/null
}
"

# XXX - adapt "oldversion" linkage to be more generic
eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  for ov in 5.32.1 5.34.1 5.36.0 ; do
    pushd \"${rtdir}\" &>/dev/null
    test -e \"${rname}-\${ov}\" \
      && mv \"${rname}-\${ov}\" \"${rname}-\${ov}.PRE-\${TS}\" \
      || true
    ln -sf \"\$(cwidir_${rname})\" \"${rname}-\${ov}\"
    cd \"\$(cwidir_${rname})/bin\"
    ln -sf \"${rname}\$(cwver_${rname})\" \"${rname}\${ov}\"
    cd \"\$(cwidir_${rname})/lib\"
    ln -sf \"\$(cwver_${rname})\" \"\${ov}\"
    cd \"\$(cwidir_${rname})/lib/site_perl\"
    ln -sf \"\$(cwver_${rname})\" \"\${ov}\"
    popd &>/dev/null
  done
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
