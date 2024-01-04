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
rp="minimal"
rname="elinks"
rver="0.17.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/rkd77/elinks/releases/download/v${rver}/${rfile}"
rsha256="58c73a6694dbb7ccf4e22cee362cf14f1a20c09aaa4273343e8b7df9378b330e"
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
