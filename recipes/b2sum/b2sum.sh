rname="b2sum"
rver="2407e7a40a2650872c5a2100498960662ea22464"
rdir="${rname}-${rver}"
rfile="${rname}.c"
rurl="https://raw.githubusercontent.com/blake2/blake2/${rver}/b2sum/${rfile}"
rsha256="6a11a2f7a5f135a683277c2187e94ce80a92c98a8dee2cb25d873ecabc63e06f"
rreqs="libb2"

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

cwcopyfunc "cwfetch_${rname}" "cwfetch_${rname}_real"

eval "
function cwfetch_${rname}() {
  cwfetch_${rname}_real
  cwfetchcheck \
    \"\$(cwurl_${rname} | sed 's,\\.c\$,.1,g')\" \
    \"\$(cwdlfile_${rname} | sed 's,\\.c\$,.1,g')\" \
    'ee40fdf8264ddde36ece45000afd81cdcd6c7ea9241c429bf2a8fc86de8c1d5a'
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \$(cwidir_${rname})/bin
  \${CC} -I${cwsw}/libb2/current/include/ -L${cwsw}/libb2/current/lib/ \$(cwdlfile_${rname}) -o \$(cwidir_${rname})/bin/${rname} -lb2 -Wl,-static -Wl,-s -g0 -static
  cwmkdir \$(cwidir_${rname})/share/man/man1
  install -m 0644 \"\$(cwdlfile_${rname} | sed 's,\\.c\$,.1,g')\" \$(cwidir_${rname})/share/man/man1/
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
