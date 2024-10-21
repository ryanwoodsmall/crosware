rname="ttinfo"
rver="ba19dab7c97757cc671d5cf3670990d5d38b3892"
rdir="${rname}-${rver}"
rfile="${rname}.c"
rurl="https://raw.githubusercontent.com/troglobit/ttinfo/${rver}/${rfile}"
rsha256="86ada63e59452b1736cbe3f4c22781b19aed54e0353d951722ebc0d764c2c835"
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \$(cwidir_${rname})/bin
  \${CC} \${CFLAGS} -o \$(cwidir_${rname})/bin/${rname} \$(cwdlfile_${rname}) -static -s
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
