rname="diffutils"
rver="3.12"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/diffutils/${rfile}"
rsha256="5be181b27ec38aad2450080661a64e4a1752bb29b7d5052bf0a02a70f623f9b2"
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
