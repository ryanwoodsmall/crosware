#
# XXX - features
#   css/dom/other netsurf stuff
#   gnutls
#   idn
#   libbsd/libmd
#   libcurl
#   mujs
#   quickjs
#   spidermonkey
#   tre
#   ...
#

# XXX - small, libressl+zlib for now
# XXX again, now requires autotools...
rp="minimal"
rname="elinks"
rver="0.17.1.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/rkd77/elinks/releases/download/v${rver}/${rfile}"
rsha256="dc6f292b7173814d480655e7037dd68b7251303545ca554344d7953a57c4ba63"
rreqs="elinks${rp}"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${rtdir}\"
  rm -rf \"${rtdir}/current\"
  rm -rf \"\$(cwidir_${rname})\"
  ln -sf \"\$(cwidir_${rname}${rp})\" \"\$(cwidir_${rname})\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

unset rp
