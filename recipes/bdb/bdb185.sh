#
# XXX - hacky, utilize red hat patches and pull some random bits from the nvi179 .h files
# XXX - works well enough for an ndbm provider for e.g. gauche
# XXX - segfaults after a ### of entries; not sure if not 64-bit safe, arch-dependent, libbsd interplay, etc.
#

rname="bdb185"
rver="1.85"
rdir="db.${rver}"
rfile="db1-${rver}-8.src.rpm"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname%%185}/${rfile}"
rsha256="fa5721b24f36279ea4c0225a721476d2492601ae3cdc053c712f781928fb526e"
rreqs="make busybox libbsd pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  local bb=\"${cwsw}/busybox/current/bin/busybox\"
  rm -rf \"${rdir}\" \"${rname}\"
  cwmkdir \"${cwbuild}/${rname}\"
  cd \"${cwbuild}/${rname}\"
  \${bb} rpm2cpio < \"${rdlfile}\" | \${bb} cpio -divm
  cd -
  tar -zxf \"${rname}/${rdir}.tar.gz\"
  cp ${rname}/*.patch \"${rbdir}\"
  rm -rf \"${rname}/\"
  unset bb
  popd >/dev/null 2>&1
}
"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local bb=\"${cwsw}/busybox/current/bin/busybox\"
  for p in db.${rver}{,.{s390,nodebug}}.patch ; do
    \${bb} patch -p1 < \${p}
  done
  find . -type f | xargs grep -l sys/cdefs | xargs sed -i s,sys/cdefs,bsd/sys/cdefs,g
  find . -type f | xargs grep -l sys/queue | xargs sed -i s,sys/queue,bsd/sys/queue,g
  for f in include/db.h PORT/linux/include/compat.h ; do
    cat \${f} > \${f}.ORIG
    cat>\${f}<<EOF
#undef __PMT
#undef __P
#define __PMT(protos) protos
#define __P __PMT
EOF
    cat \${f}.ORIG >> \${f}
    rm -f \${f}.ORIG
  done
  cd PORT/linux
  ln -sf ../../include/queue.h include/bdbqueue.h
  sed -i '/sys\\/queue/a#include <bdbqueue.h>' \$(realpath include/mpool.h)
  sed -i '/:.*LIBDBSO/s,LIBDBSO,LIBDB,g' Makefile
  sed -i 's,-ldb,-ldb -lbsd -static,g' Makefile
  unset bb p
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}/PORT/linux\" >/dev/null 2>&1
  make CC=\"\${CC} \${CFLAGS} -D_GNU_SOURCE -D_BSD_SOURCE \$(pkg-config --{cflags,libs} libbsd)\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}/PORT/linux\" >/dev/null 2>&1
  for d in bin include lib ; do
    cwmkdir \"${ridir}/\${d}\"
  done
  install -m 755 db_dump185 \"${ridir}/bin/\"
  install -m 644 \$(realpath include/{bdbqueue,db,mpool,ndbm}.h) \"${ridir}/include/\"
  install -m 644 libdb.a \"${ridir}/lib/\"
  ln -sf libdb.a \"${ridir}/lib/libndbm.a\"
  popd >/dev/null 2>&1
}
"
