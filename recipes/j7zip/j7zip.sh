rname="j7zip"
rver="4.43_alpha2"
rdir="J7zip_${rver}"
rfile="${rdir}.zip"
rurl="http://prdownloads.sourceforge.net/p7zip/${rfile}"
rsha256="00073579f56f18f45169bb861dbaa16826f221c1f34f0cff6c861fbd3cb3f656"
rreqs="busybox"

. "${cwrecipe}/common.sh"

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
  pushd \"${rbdir}\" >/dev/null 2>&1
  mkdir -p \"${ridir}\"
  rm -f \"${ridir}/JZip.jar\"
  cp dist/J7Zip.jar \"${ridir}\"
  echo '#!/bin/sh' > \"${ridir}/${rname}\"
  echo 'java -jar \"${rtdir}/current/J7Zip.jar\" \"\${@}\"' >> \"${ridir}/${rname}\"
  chmod 755 \"${ridir}/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current\"' > \"${rprof}\"
}
"
