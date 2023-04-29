rname="lua"
rluaver="53"
rvn="${rname}${rluaver}"
rver="$(cwver_${rvn})"
rdir="$(cwdir_${rvn})"
rfile="$(cwfile_${rvn})"
rsha256="$(cwsha256_${rvn})"
rdlfile="$(cwdlfile_${rvn})"

. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"

unset rluaver rvn
