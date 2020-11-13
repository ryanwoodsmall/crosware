#
# XXX - rename to "gostatic"
# XXX - requires go-misc change too
# XXX - generic go recipe w/CGO enabled
# XXX - date should be moved to version?
#

rname="go"
rver="1.15.5"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="${rname}${rver}-amd64"
  rsha256="f09a64c86c91de6e920ca326b059a205aa0c555b0674a9e0cb1a14a14d7f112c"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="${rname}${rver}-386"
  rsha256="03858851d2673a2c7cc61657f39e224f974568a474ed3a6432a4564b2beb3933"
elif [[ ${karch} =~ ^aarch64 ]] ; then
  rdir="${rname}${rver}-arm64"
  rsha256="f7200022f3b10e2cd10559cc4c1f069c46bd38e647dbed3a0ad97f9b00d52767"
elif [[ ${karch} =~ ^arm ]] ; then
  rdir="${rname}${rver}-arm"
  rsha256="30bff232b9e4625be50669daf95cdedb1a3a16e74b83a47ddf97d284db88e15e"
elif [[ ${karch} =~ ^riscv64 ]] ; then
  rdir="${rname}${rver}-riscv64"
  rsha256="6ba980a4d8bbedb2b6b63f6f3f488ead655f308de7e97833b7b5ae55fc8e52ae"
else
  rdir="none"
  rsha256="none"
fi
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/20201112-${rname}${rver}/${rfile}"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${rtdir}\"
}
"

eval "
function cwinstall_${rname}() {
  cwfetch_${rname}
  cwsourceprofile
  cwextract_${rname}
  cwlinkdir_${rname}
  cwgenprofd_${rname}
  cwmarkinstall_${rname}
}
"
