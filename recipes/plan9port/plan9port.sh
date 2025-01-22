#
# XXX - pthread workaround - musl-specific?
# XXX - without: "mc: cannot use LinuxThreads as pthread library; see /usr/local/crosware/software/plan9port/current/src/libthread/README.Linux"
# XXX - in-place build; INSTALL -b/INSTALL -c may be a better fit here - build in ${cwtop}/builds/, then tar/untar in ${cwtop}/software/${rname}
# XXX - alpine build, may need libucontext patch (and libucontext recipe) https://git.alpinelinux.org/aports/tree/testing/plan9port?h=master
# XXX - generate a tree of html files like so...
#   ( cd ${cwsw}/plan9port/current/ ; ${cwsw}/tree/current/bin/tree -F -f -P '*\.html' -H $(pwd | sed s,${cwtop},,g) | tee tree.html )
#

rname="plan9port"
rver="61e362add9e1485bec1ab8261d729016850ec270"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/9fans/${rname}/archive/${rfile}"
rsha256="b86ed10afe0c469fa4c477527f0a3bcfe79b83c1d14a30b2e9f83d674295e455"
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
  sed -i.ORIG '/^LDFLAGS/s/=/=-static/g' src/mkhdr
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
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  time busybox ash ./INSTALL 2>&1 | tee ${rname}_build.out
  find bin/ -type f -exec toybox file {} + \
  | grep ELF \
  | cut -f1 -d: \
  | xargs \$(\${CC} -dumpmachine)-strip --strip-all \
    || true
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
