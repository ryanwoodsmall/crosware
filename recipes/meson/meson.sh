rname="meson"
rver="0.63.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/mesonbuild/meson/releases/download/${rver}/${rfile}"
rsha256="3b51d451744c2bc71838524ec8d96cd4f8c4793d5b8d5d0d0a9c8a4f7c94cd6f"
rreqs="python3 ninja"

. "${cwrecipe}/common.sh"

cwstubfunc "cwmake_${rname}"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  find . -type f -exec touch '{}' +
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  local p3d=\"${cwsw}/python3/current\"
  local p3v=\"\$(env PATH=\"\${p3d}/bin:\${PATH}\" python3 -V 2>&1 | cut -f2 -d' ')\"
  local p3p=\"\$(cwidir_${rname})/lib/python\${p3v%.*}/site-packages\"
  cwmkdir \"\${p3p}\"
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PYTHONPATH=\"\${p3p}\" \
    \"\${p3d}/bin/python3\" setup.py install --force --prefix=\"\$(cwidir_${rname})\"
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
