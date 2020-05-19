rname="cloc"
rver="1.86"
rdir="${rname}-${rver}"
rfile="${rdir}.pl"
rurl="https://github.com/AlDanial/${rname}/releases/download/${rver}/${rfile}"
rsha256="b6b70b0abecd33e302e0b7808bc82671582cde1896359e295b2a7a229876e0c0"
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
