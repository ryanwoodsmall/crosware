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
# XXX - no more pregenerated autotools
# XXX - move this to meson (muon!): https://github.com/rkd77/elinks/issues/335
#

# XXX - small, libressl+zlib for now
# XXX again, now requires autotools...
rp="minimal"
rname="elinks"
rver="0.19.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/rkd77/elinks/releases/download/v${rver}/${rfile}"
rsha256="a993a4870cadce60abbc724cf6a5c2a80f6be9020243b9e5ce075c16c6665c04"
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
