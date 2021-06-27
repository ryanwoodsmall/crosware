#
# XXX - pthread workaround - musl-specific?
# XXX - without: "mc: cannot use LinuxThreads as pthread library; see /usr/local/crosware/software/plan9port/current/src/libthread/README.Linux"
# XXX - in-place build; INSTALL -b/INSTALL -c may be a better fit here - build in ${cwtop}/builds/, then tar/untar in ${cwtop}/software/${rname}
# XXX - alpine build, may need libucontext patch (and libucontext recipe) https://git.alpinelinux.org/aports/tree/testing/plan9port?h=master
#

rname="plan9port"
rver="70cc6e5ba7798b315c3fb3aae19620a01604a459"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/9fans/${rname}/archive/${rfile}"
rsha256="baa355fd18fbb9a8e92c3f767d2d64642d587424e9f0272e4f4032a1f08232c9"
rreqs="busybox toybox"
rprof="${cwetcprofd}/zz_zz_${rname}.sh"
rbdir="${cwsw}/${rname}/${rdir}"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  cwmkdir \"${ridir}\"
  cwextract \"${rdlfile}\" \"${rtdir}\" >\"${ridir}/${rname}_extract.out\" 2>&1
}
"

eval "
function cwclean_${rname}() {
  true
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's,^PATH=,PATH=${cwsw}/ccache/current/bin:${cwsw}/statictoolchain/current/bin:${cwsw}/busybox/current/bin:${cwsw}/toybox/current/bin:,g' INSTALL
  sed -i.ORIG '/^LDFLAGS/s/=/=-static/g' src/mkhdr
  sed -i.ORIG '/</s,1024,0,g' src/libthread/pthread.c
  grep -ril 'sys/termios\.h' . | xargs sed -i.ORIG 's,sys/termios\.h,termios.h,g' || true
  find src/cmd -name mk\* -exec grep -l 'LD -o' {} + | xargs sed -i.ORIG 's,LD ,LD \$LDFLAGS ,g' || true
  if ! \$(which perl >/dev/null 2>&1) ; then
    mv dist/manweb{,.ORIG}
    head -1 dist/manweb.ORIG > dist/manweb
    echo true >> dist/manweb
    chmod 755 dist/manweb
  fi
  echo WSYSTYPE=nowsys > LOCAL.config
  echo CC9=\${CC} >> LOCAL.config
  echo CC9FLAGS=-Wl,-static >> LOCAL.config
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  true
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  time busybox ash ./INSTALL 2>&1 | tee ${rname}_build.out
  find bin/ -type f -exec toybox file {} + \
  | grep ELF \
  | cut -f1 -d: \
  | xargs \$(\${CC} -dumpmachine)-strip --strip-all \
    || true
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export PLAN9=\"${rtdir}/current\"' > \"${rprof}\"
  echo 'append_path \"${cwsw}/bison/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/byacc/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/flex/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/reflex/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"\${PLAN9}/bin\"' >> \"${rprof}\"
}
"
