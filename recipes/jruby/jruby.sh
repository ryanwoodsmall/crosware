rname="jruby"
rver="9.3.8.0"
rdir="${rname}-${rver}"
rfile="${rname}-dist-${rver}-bin.tar.gz"
rurl="https://repo1.maven.org/maven2/org/${rname}/${rname}-dist/${rver}/${rfile}"
rsha256="674a4d1308631faa5f0124d01d73eb1edc89346ee7de21c70e14305bd61b46df"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwmake_${rname}"
cwstubfunc "cwconfigure_${rname}"

eval "
function cwmakeinstall_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${rtdir}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
