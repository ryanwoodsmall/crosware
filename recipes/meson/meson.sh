#
# XXX - ugh
#
rname="meson"
rver="1.2.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/mesonbuild/meson/releases/download/${rver}/${rfile}"
rsha256="4533a43c34548edd1f63a276a42690fce15bde9409bcf20c4b8fa3d7e4d7cac1"
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
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local p3d=\"${cwsw}/python3/current\"
  local p3v=\"\$(env PATH=\"\${p3d}/bin:\${PATH}\" python3 -V 2>&1 | cut -f2 -d' ')\"
  local p3p=\"\$(cwidir_${rname})/lib/python\${p3v%.*}/site-packages\"
  env PYTHONPATH=\"\${p3p}\" \
    \"\${p3d}/bin/python3\" setup.py install --force --prefix=\"\$(cwidir_${rname})\"
  env PYTHONPATH=\"\${p3p}\" \
    \"\${p3d}/bin/python3\" setup.py install --force --prefix=\"\${p3d}\"
  unset p3d p3v p3p
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
