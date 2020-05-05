rname="bsdheaders"
rver="4529301bbe70688dfd94e6e0a61bc9078292848a"
rdir="bsd-headers-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/bonsai-linux/bsd-headers/archive/${rfile}"
rsha256=""
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${rtdir}\"
}
"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  true
}
"

eval "
function cwmakeinstall_${rname}() {
  rm -rf \"${ridir}/machine\"
  ln -sf sys \"${ridir}/machine\"
}
"
