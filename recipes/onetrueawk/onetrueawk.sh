#
# XXX - YACC is now officially set as bison, bison requires perl, etc. - too big
# XXX - i.e. byacc is probably going to break at some point, then awk will indirectly require perl. the humanity
#
rname="onetrueawk"
rver="20261106"
rdir="${rname#onetrue}-${rver}"
rfile="${rver}.tar.gz"
#rfile="${rver}.zip"
#rurl="https://github.com/onetrueawk/awk/archive/${rfile}"
rurl="https://github.com/onetrueawk/awk/archive/refs/tags/${rfile}"
rsha256="1b354fe6fa0089a959ef912085e7a064236d15a7d3c9e6ce86456c3b87d3f464"
rreqs="make byacc"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

#eval "
#function cwfetch_${rname}() {
#  cwfetch \"${rurl}\" \"${rdlfile}\"
#}
#"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat makefile > makefile.ORIG
  sed -i 's/-o maketab/-o maketab -static -Wl,-static/g' makefile
  sed -i 's/gcc/\$(CC)/g' makefile
  sed -i 's/-lm/-lm -static/g' makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make YACC=\"${cwsw}/byacc/current/bin/byacc -d -b awkgram\" {HOST,}CC=\"\${CC} -Wl,-static\" CPPFLAGS= LDFLAGS=-static
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})/bin\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  \$(\${CC} -dumpmachine)-strip --strip-all a.out
  install -m 0755 a.out \"\$(cwidir_${rname})/bin/awk\"
  ln -sf \"${rtdir}/current/bin/awk\" \"\$(cwidir_${rname})/bin/${rname}\"
  install -m 0644 awk.1 \"\$(cwidir_${rname})/share/man/man1/\"
  ln -sf \"${rtdir}/current/share/man/man1/awk.1\" \"\$(cwidir_${rname})/share/man/man1/${rname}.1\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
