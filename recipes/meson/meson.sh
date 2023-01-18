rname="meson"
rver="1.0.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/mesonbuild/meson/releases/download/${rver}/${rfile}"
rsha256="aa50a4ba4557c25e7d48446abfde857957dcdf58385fffbe670ba0e8efacce05"
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
