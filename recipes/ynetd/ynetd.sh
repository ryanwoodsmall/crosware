rname="ynetd"
rver="b524d23a6221d6efba39cd1bd58e34300ca7ddc2"
rdir="${rname}-${rver}"
rfile="${rname}.c"
rurl="https://raw.githubusercontent.com/johnsonjh/${rname}/${rver}/${rfile}"
rsha256="ec7509dec7737da54f8b18e1b5ba935d657f9f016c36cfc9ac08f9952373226f"
rreqs=""

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
  cwmkdir \"${ridir}/sbin\"
  \${CC} \${CFLAGS} -Os -Wl,-s -std=c99 -pedantic -Wall -Wextra -DNDEBUG \"${rdlfile}\" -o \"${ridir}/sbin/${rname}\" -static
  \$(\${CC} -dumpmachine)-strip \"${ridir}/sbin/${rname}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
