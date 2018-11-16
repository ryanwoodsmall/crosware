rname="jruby"
rver="9.2.4.0"
rdir="${rname}-${rver}"
rfile="${rname}-dist-${rver}-bin.tar.gz"
rurl="https://repo1.maven.org/maven2/org/${rname}/${rname}-dist/${rver}/${rfile}"
rsha256="b9638c82c85d89f6e8b2da1b876ac235bb9ed47f2163b3c851f0496c9bd58a0c"
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
  cwmkdir \"${rtdir}\"
  cwextract \"${cwdl}/${rname}/${rfile}\" \"${rtdir}\"
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
