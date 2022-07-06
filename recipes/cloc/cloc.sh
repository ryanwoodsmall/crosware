rname="cloc"
rver="1.94"
rdir="${rname}-${rver}"
rfile="${rdir}.pl"
rurl="https://github.com/AlDanial/${rname}/releases/download/v${rver}/${rfile}"
rsha256="093517cadb868af6968cfe0fb3a23a46ce527622acecd4518a73eace7ae5a9bc"
rreqs="perl"

. "${cwrecipe}/common.sh"

for f in extract configure make ; do
eval "
function cw${f}_${rname}() {
  true
}
"
done
unset f

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${ridir}/bin\"
  install -m 0755 \"${rdlfile}\" \"${ridir}/bin/\"
  ln -sf \"${rfile}\" \"${ridir}/bin/${rname}.pl\"
  ln -sf \"${rfile}\" \"${ridir}/bin/${rname}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
