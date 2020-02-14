rname="cloc"
rver="1.84"
rdir="${rname}-${rver}"
rfile="${rdir}.pl"
rurl="https://github.com/AlDanial/${rname}/releases/download/${rver}/${rfile}"
rsha256="a54e28d17f1097267663a46f1afaabc0b6127a8e3869dd6e557e334e9c5b5f74"
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
