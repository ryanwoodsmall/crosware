rname="itsatty"
rver="master"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/ryanwoodsmall/${rname}/archive/${rfile}"
rsha256=""
rreqs="make socat"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${cwdl}/${rname}/${rfile}\"
}
"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make install prefix=\"${ridir}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
