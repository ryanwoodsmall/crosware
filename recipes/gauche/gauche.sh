#
# XXX - dbm - gdbm is used for gdbm/ndbm/odbm; sdbm supports ndbm, and bdb supports ndbm/odbm
# XXX - dedicated slib
# XXX - no gc on riscv64 yet
# XXX - broken on arm 32-bit...
#   (cd util; make default)
#   make[2]: Entering directory '/usr/local/crosware/builds/Gauche-0.9.11/ext/util'
#   "../../src/gosh" -ftest "../../src/precomp" -e -P -o util--match ../../libsrc/util/match.scm
#   "list.c", line 798 (Scm__GetExtendedPairDescriptor): Assertion failed: (z->hiddenTag&0x7) == 0x7
#   make[2]: *** [Makefile:26: util--match.c] Error 1
#

rname="gauche"
rver="0.9.12"
rdir="${rname//g/G}-${rver}"
rfile="${rdir}.tgz"
rurl="https://github.com/shirok/${rname//g/G}/releases/download/release${rver//./_}/${rfile}"
rsha256="b4ae64921b07a96661695ebd5aac0dec813d1a68e546a61609113d7843f5b617"
rreqs="make libressl mbedtls zlib gdbm"

. "${cwrecipe}/common.sh"

if [[ ${karch} =~ ^(arm|riscv64) ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"recipe ${rname} does not support architecture ${karch}\"
}
"
fi

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --enable-ipv6 \
    --enable-multibyte=utf-8 \
    --enable-threads=pthreads \
    --with-ca-bundle=\"${cwetc}/ssl/cert.pem\" \
    --with-dbm=gdbm,ndbm,odbm \
    --with-local=\"\$(echo ${cwsw}/{${rreqs// /,}}/current | tr ' ' ':')\" \
    --with-tls=axtls,mbedtls \
    --with-zlib=\"${cwsw}/zlib/current\" \
      CFLAGS='-fPIC' \
      CXXFLAGS='-fPIC' \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib)\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LIBS='-lgdbm_compat -lgdbm' \
      PKG_CONFIG_LIBDIR= \
      PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  echo '#!/bin/sh' > \"\$(cwidir_${rname})/bin/${rname}\"
  echo 'export GAUCHE_READ_EDIT=yes' >> \"\$(cwidir_${rname})/bin/${rname}\"
  echo 'env GAUCHE_READ_EDIT=yes \"${rtdir}/current/bin/gosh\" \"\${@}\"' >> \"\$(cwidir_${rname})/bin/${rname}\"
  chmod 755 \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
