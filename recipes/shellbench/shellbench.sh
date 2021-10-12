rname="shellbench"
rver="master"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/shellspec/${rname}/archive/refs/heads/${rfile}"
rsha256=""
rreqs=""

. "${cwrecipe}/common.sh"

for f in clean configure make ; do
  eval "
  function cw${f}_${rname}() {
    true
  }
  "
done
unset f

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

eval "
function cwextract_${rname}() {
  rm -rf \"${ridir}/${rdir}\" || true
  cwextract \"${rdlfile}\" \"${rtdir}\"
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${ridir}/bin\"
  ln -sf \"${rtdir}/current/${rname}\" \"${ridir}/bin/${rname}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
