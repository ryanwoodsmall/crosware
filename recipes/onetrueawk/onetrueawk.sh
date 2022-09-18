#
# XXX - YACC is now officially set as bison, bison requires perl, etc. - too big
# XXX - i.e. byacc is probably going to break at some point, then awk will indirectly require perl. the humanity
#

rname="onetrueawk"
rver="9e248c317b88470fc86aa7c988919dc49452c88c"
rdir="${rname#onetrue}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/${rname}/awk/archive/${rfile}"
rsha256=""
rreqs="make byacc"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cat makefile > makefile.ORIG
  sed -i 's/-o maketab/-o maketab -static -Wl,-static/g' makefile
  sed -i 's/gcc/\$(CC)/g' makefile
  sed -i 's/-lm/-lm -static/g' makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make YACC=\"${cwsw}/byacc/current/bin/byacc -d -b awkgram\" {HOST,}CC=\"\${CC} -Wl,-static\" CPPFLAGS= LDFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  \$(\${CC} -dumpmachine)-strip --strip-all a.out
  install -m 0755 a.out \"\$(cwidir_${rname})/bin/awk\"
  ln -sf \"${rtdir}/current/bin/awk\" \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 0644 awk.1 \"\$(cwidir_${rname})/share/man/man1/\"
  ln -sf \"${rtdir}/current/share/man/man1/awk.1\" \"\$(cwidir_${rname})/share/man/man1/${rname}.1\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
