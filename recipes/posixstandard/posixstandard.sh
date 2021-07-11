rname="posixstandard"
rver="v4-2018"
rdir="sus${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://pubs.opengroup.org/onlinepubs/9699919799/download/${rfile}"
rsha256="ee82765d476be8906be80948a75dd6cb561f14f680fa83b7215337a4950b4735"
rreqs=""

. "${cwrecipe}/common.sh"

for f in configure make makeinstall clean ; do
eval "
function cw${f}_${rname}() {
  true
}
"
done
unset f

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${rtdir}\"
}
"
