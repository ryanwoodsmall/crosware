#
# XXX - pthread workaround - musl-specific?
# XXX - without: "mc: cannot use LinuxThreads as pthread library; see /usr/local/crosware/software/plan9port/current/src/libthread/README.Linux"
# XXX - in-place build; INSTALL -b/INSTALL -c may be a better fit here - build in ${cwtop}/builds/, then tar/untar in ${cwtop}/software/${rname}
# XXX - alpine build, may need libucontext patch (and libucontext recipe) https://git.alpinelinux.org/aports/tree/testing/plan9port?h=master
# XXX - generate a tree of html files like so...
#     ( cd ${cwsw}/plan9port/current/ ; ${cwsw}/tree/current/bin/tree -F -f -P '*\.html' -H $(pwd | sed s,${cwtop},,g) | tee tree.html )
# XXX - need to figure out default NAMESPACE stuff...
# XXX - abortive attempt at an rlwrap-ed shell (9rc) below
#
# XXX - plumber is crashing on aarch64, at least? and verified on x86_64
#

rname="plan9port"
rver="e5cc7c8e39c894f2ad8c7c800acfd299f1b512fa"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/9fans/plan9port/archive/${rfile}"
rsha256="f8eeb31dc8c3fdd4f1eba89262df7b01fe8869e82030ce9e1dec8d661f7590d2"
rreqs="busybox toybox"
rprof="${cwetcprofd}/zz_zz_${rname}.sh"
rbdir="${cwsw}/${rname}/${rdir}"

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwextract_${rname}() {
  cwmkdir \"\$(cwidir_${rname})\"
  cwextract \"\$(cwdlfile_${rname})\" \"${rtdir}\" &> \"\$(cwidir_${rname})/${rname}_extract.out\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG 's,^PATH=,PATH=${cwsw}/ccache/current/bin:${cwsw}/statictoolchain/current/bin:${cwsw}/busybox/current/bin:${cwsw}/toybox/current/bin:,g' INSTALL
  sed -i.ORIG '/^LDFLAGS/s/=/=-static/' src/mkhdr
  sed -i.ORIG '/</s,1024,0,g' src/libthread/pthread.c
  grep -ril 'sys/termios\.h' . | xargs sed -i.ORIG 's,sys/termios\.h,termios.h,g' || true
  find src/cmd -name mk\* -exec grep -l 'LD -o' {} + | xargs sed -i.ORIG 's,LD ,LD \$LDFLAGS ,g' || true
  if ! command -v perl &>/dev/null ; then
    cwscriptecho ''
    cwscriptecho 'disabling manweb'
    cwscriptecho ''
    sleep 1
    mv dist/manweb{,.ORIG}
    head -1 dist/manweb.ORIG > dist/manweb
    echo true >> dist/manweb
    chmod 755 dist/manweb
  fi
  echo WSYSTYPE=nowsys > LOCAL.config
  echo CC9=\${CC} >> LOCAL.config
  echo CC9FLAGS=-Wl,-static >> LOCAL.config
  echo 'egrep=\"grep -E\"' >> LOCAL.config
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  time busybox ash ./INSTALL |& tee ${cwtop}/tmp/${TS}_${rname}_build.out
  #find bin/ -type f -exec toybox file {} + \
  #| grep ELF \
  #| cut -f1 -d: \
  #| xargs \$(\${CC} -dumpmachine)-strip --strip-all \
  #  || true
  # rm -f \"\$(cwidir_${rname})/bin/9rc\"
  # touch \"\$(cwidir_${rname})/bin/9rc\"
  # echo -n > \"\$(cwidir_${rname})/bin/9rc\"
  # printf '#/usr/bin/env bash\\n' | tee -a \"\$(cwidir_${rname})/bin/9rc\"
  # printf '${rtdir}/current/bin/9 namespace &>/dev/null || export NAMESPACE=\"/tmp/ns.\${USER}.:0\"\\n' | tee -a \"\$(cwidir_${rname})/bin/9rc\"
  # printf 'rlwrap -C 9rc -c -r -- ${rtdir}/current/bin/9 rc \"\${@}\"\\n' | tee -a \"\$(cwidir_${rname})/bin/9rc\"
  # chmod 755 \"\$(cwidir_${rname})/bin/9rc\"
  popd &>/dev/null
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
