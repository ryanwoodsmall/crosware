#
# URLs:
# - up-to-date fork used here: https://github.com/jaydg/sdbm
# - original: https://github.com/davidar/sdbm
#

rname="sdbm"
rver="8199251b4dbf882adcc175e07985da442a47796b"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="c700f0059ba84e50afb180a63c412ccf3b558142f1a0be014125a860f1899c83"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat sdbm.h > sdbm.h.ORIG
  echo '#include <fcntl.h>' > sdbm.h
  echo >> sdbm.h
  cat sdbm.h.ORIG >> sdbm.h
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make CC=\"\${CC} \${CFLAGS}\" LDFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/include\"
  cwmkdir \"${ridir}/lib\"
  cwmkdir \"${ridir}/share/doc\"
  cwmkdir \"${ridir}/share/man/man1\"
  cwmkdir \"${ridir}/share/man/man3\"
  install -m 755 db{a,d,e,u} \"${ridir}/bin/\"
  install -m 644 sdbm.h \"${ridir}/include/\"
  install -m 644 libsdbm.a \"${ridir}/lib/\"
  install -m 644 CHANGES COMPARE readme.ms readme.txt \"${ridir}/share/doc/\"
  install -m 644 dbe.1 \"${ridir}/share/man/man1/\"
  install -m 644 sdbm.3 \"${ridir}/share/man/man3/\"
  ln -sf sdbm.h \"${ridir}/include/ndbm.h\"
  ln -sf libsdbm.a \"${ridir}/lib/libndbm.a\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
