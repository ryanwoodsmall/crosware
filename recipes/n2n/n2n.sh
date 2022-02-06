#
# XXX - dev branch has miniupnp and/or libnatpmp support for hole punching/nat traversal/etc.
#

rname="n2n"
rver="3.1.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/n2n/${rfile}"
rsha256="64f5ff537f1c380932517998b81cc18570ee77185aefc68f55de5ecff53ab2c2"
rreqs="make openssl zstd libpcap libcap libnl"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's/-lpcap/-lpcap -lpcap -lnl-3 -lnl-genl-3/g' configure tools/Makefile.in
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-openssl \
    --with-zstd
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} \
    CC=\"\${CC} \${CFLAGS} -Wl,-s \${CPPFLAGS} -I${cwsw}/libpcap/current/include/pcap\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install PREFIX=\"${ridir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
