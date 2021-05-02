rname="cloc"
rver="1.90"
rdir="${rname}-${rver}"
rfile="${rdir}.pl"
rurl="https://github.com/AlDanial/${rname}/releases/download/v${rver}/${rfile}"
rsha256="28c3863b1bd39a21defb307c794949ea4f247af1e9177e18c7aa21435a92e740"
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
