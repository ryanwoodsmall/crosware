rname="jruby"
rver="9.3.7.0"
rdir="${rname}-${rver}"
rfile="${rname}-dist-${rver}-bin.tar.gz"
rurl="https://repo1.maven.org/maven2/org/${rname}/${rname}-dist/${rver}/${rfile}"
rsha256="94a7a8b3beeac2253a8876e73adfac6bececb2b54d2ddfa68f245dc81967d0c1"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwcheckreqs_${rname}
  cwsourceprofile
  cwextract \"\$(cwdlfile_${rname})\" \"${rtdir}\"
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
