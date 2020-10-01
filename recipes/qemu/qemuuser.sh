#
# XXX - rename to qemu-${ARCH}-static like debian/ubuntu
# XXX - register: https://raw.githubusercontent.com/qemu/qemu/master/scripts/qemu-binfmt-conf.sh
#

rname="qemuuser"
rver="5.1.0"
rdir="${rname%%user}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://download.qemu.org/${rfile}"
rsha256="c9174eb5933d9eb5e61f541cd6d1184cd3118dfe4c5c4955bc1bdc4d390fa4e5"
rreqs="make glib pixman patch python3"
rpfile="${cwrecipe}/${rname%%user}/${rname%%user}.patches"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's,sys/signal,signal,g' include/qemu/osdep.h
  ./configure \
    --prefix=\"${ridir}\" \
    --static \
    --disable-pie \
    --enable-linux-user \
    --disable-system \
    --disable-docs \
    --cc=\"\${CC}\" \
    --host-cc=\"\${CC}\" \
    --cxx=\"\${CXX}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} CPP=\"\${CC}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool} CPP=\"\${CC} -E\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
