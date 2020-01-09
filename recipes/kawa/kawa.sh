#
# XXX - ugh, get old script from kawa 3.0 since it's not in the 3.1 zip and bootstrapping sucks
#

rname="kawa"
rver="3.1"
rdir="${rname}-${rver}"
rfile="${rdir}.zip"
rurl="ftp://ftp.gnu.org/pub/gnu/${rname}/${rfile}"
rsha256="c4c3abb5d4f3eab526299150e073685f29e5416fa4f9b025e06d31ce17d1c739"
# we need unzip, use the busybox version
rreqs="busybox"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \"${rurl//3.1/3.0}\" \"${rdlfile//3.1/3.0}\" \"63116eec4b2b2dd8fae0b30127639aa42ad7a7430c4970d3fd76b42a148e423c\"
}
"

eval "
function cwmakeinstall_${rname}() {
  cwextract \"${rdlfile}\" \"${rtdir}\"
  cwextract \"${rdlfile//3.1/3.0}\" \"${ridir}\"
  install -m 0755 \"${ridir}/${rdir//3.1/3.0}/bin/${rname}\" \"${ridir}/bin/${rname}\"
  rm -rf \"${ridir}/${rdir//3.1/3.0}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export KAWA_HOME=\"${rtdir}/current\"' > \"${rprof}\"
  echo 'append_path \"\${KAWA_HOME}/bin\"' >> \"${rprof}\"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwsourceprofile
  cwcheckreqs_${rname}
  cwmakeinstall_${rname}
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
