rname="lua"
rver="5.3.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.lua.org/ftp/${rfile}"
rsha256="fc5fd69bb8736323f026672b1b7235da613d7177e72558893a0bdcd320466d60"
rreqs="bootstrapmake"
rdlfile="${cwdl}/${rname}/${rfile}"

. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
