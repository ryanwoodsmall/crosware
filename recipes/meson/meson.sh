rname="meson"
rver="0.52.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/mesonbuild/meson/releases/download/${rver}/${rfile}"
rsha256="d60f75f0dedcc4fd249dbc7519d6f3ce6df490033d276ef1cf27453ef4938d32"
rreqs="python3 ninja"

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
  local p3d=\"${cwsw}/python3/current\"
  local p3v=\"\$(env PATH=\"\${p3d}/bin:\${PATH}\" python3 -V 2>&1 | cut -f2 -d' ')\"
  local p3p=\"${ridir}/lib/python\${p3v%.*}/site-packages\"
  cwmkdir \"\${p3p}\"
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PYTHONPATH=\"\${p3p}\" \
    python3 setup.py install --force --prefix=\"${ridir}\"
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
