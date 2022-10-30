rname="jo"
rver="1.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jpmens/${rname}/releases/download/${rver}/${rfile}"
rsha256="74c3032f0650bbaf69c17ef71ba3240e51262963843cdc8452d4e917ab8e8656"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
