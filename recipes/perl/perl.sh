rname="perl"
rver="5.26.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.cpan.org/src/5.0/${rfile}"
rsha256="572f9cea625d6062f8a63b5cee9d3ee840800a001d2bb201a41b9a177ab7f70d"
rreqs="make toybox busybox byacc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  local sttop=\"\$(realpath \$(dirname \$(realpath \$(which \${CC})))/..)\"
  local stinc="\${sttop}/\${CC//-gcc/}/include"
  local stbin="\${sttop}/bin"
  local stlib="\${sttop}/\${CC//-gcc/}/lib"
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
    -Dsysroot="\${PWD}/sysroot" \
    -Dlibc="\${stlib}/libc.a" \
    -Dcc=\"\${CC} \${CFLAGS} \${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
