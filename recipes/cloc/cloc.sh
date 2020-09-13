rname="cloc"
rver="1.88"
rdir="${rname}-${rver}"
rfile="${rdir}.pl"
rurl="https://github.com/AlDanial/${rname}/releases/download/${rver}/${rfile}"
rsha256="2c833258be31a5350fc95b50d11054a0de3c12027e527dde542fbfad70306909"
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
