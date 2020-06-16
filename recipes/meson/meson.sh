rname="meson"
rver="0.54.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/mesonbuild/meson/releases/download/${rver}/${rfile}"
rsha256="f2bdf4cf0694e696b48261cdd14380fb1d0fe33d24744d8b2df0c12f33ebb662"
rreqs="python3 ninja"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  find . -type f -exec touch '{}' +
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  true
}
"

eval "
function cwmakeinstall_${rname}() {
  local p3d=\"${cwsw}/python3/current\"
  local p3v=\"\$(env PATH=\"\${p3d}/bin:\${PATH}\" python3 -V 2>&1 | cut -f2 -d' ')\"
  local p3p=\"${ridir}/lib/python\${p3v%.*}/site-packages\"
  cwmkdir \"\${p3p}\"
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PYTHONPATH=\"\${p3p}\" \
    \"\${p3d}/bin/python3\" setup.py install --force --prefix=\"${ridir}\"
  find \${p3p}/ -maxdepth 1 -mindepth 1 -name '${rname}*' | while read -r p ; do
    ln -sf \"\${p}\" \"\${p3d}/lib/python\${p3v%.*}/site-packages/\"
  done
  popd >/dev/null 2>&1
  unset p3d p3v p3p
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
