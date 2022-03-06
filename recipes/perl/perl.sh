#
# XXX - sysroot should be recreated at build time in ${rtdir}/sysroot
# XXX - sysroot creation should be moved to statictoolchain recipe!!!
#

rname="perl"
rver="5.28.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.cpan.org/src/5.0/${rfile}"
rsha256="afc9c1d661597ae14d9e883c5071092bed73f60c3109b294823ea01aca705114"
rreqs="make toybox busybox byacc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
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
    -Dprefix="${ridir}" \
    -Dsysroot=\"\${PWD}/sysroot\" \
    -Dlibc=\"\${stlib}/libc.a\" \
    -Dcc=\"\${CC} \${CFLAGS} \${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
