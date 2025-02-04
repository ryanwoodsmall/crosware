rname="diffutils"
rver="3.11"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/diffutils/${rfile}"
rsha256="c80a3c2bf87e252fe7d605b8ba6bf928d75a90b55f3bfcf7c4a4f337ec62fc31"
rreqs="make sed gawk"

. "${cwrecipe}/common.sh"

# XXX - sed fix from https://git.alpinelinux.org/cgit/aports/tree/main/diffutils/APKBUILD
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/gets is a/d' lib/stdio.in.h
  ./configure ${cwconfigureprefix} --disable-nls \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  cat lib/sigsegv.c > lib/sigsegv.c.ORIG
  echo '#include <config.h>' > lib/sigsegv.c
  echo '#include <sys/reg.h>' >> lib/sigsegv.c
  cat lib/sigsegv.c.ORIG >> lib/sigsegv.c
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  (
    local i
    cd \$(cwidir_${rname})/bin/
    for i in \$(find . -type f) ; do
      i=\"\$(basename \${i})\"
      test -e g\${i} || ln -s \${i} g\${i}
    done
    test -e gnudiff || ln -s diff gnudiff
  )
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
