#
# XXX - pulls in its own mbedtls (old, stuck in <2.16...) and libev
#
rname="goldy"
rver="0.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/ibm-security-innovation/goldy/archive/refs/tags/${rfile}"
rsha256="3cea2d876f9b90b7dd0c03143f4aceb2d223d445db00bd43aec2ce2529af9596"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetchcheck \
    \"https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/v2.7.19.tar.gz\" \
    \"${cwdl}/mbedtls/mbedtls-2.7.19.tar.gz\" \
    \"9a6e0b0386496fae6863e41968eb308034a74008e775a533750af483a38378d0\"
  cwfetchcheck \
    \"https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/libev/libev-4.33.tar.gz\" \
    \"${cwdl}/libev/libev-4.33.tar.gz\" \
    \"507eb7b8d1015fbec5b935f34ebed15bf346bed04a11ab82b8eee848c4205aea\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  cwextract \"${cwdl}/mbedtls/mbedtls-2.7.19.tar.gz\" \"\$(cwbdir_${rname})/deps\"
  cwextract \"${cwdl}/libev/libev-4.33.tar.gz\" \"\$(cwbdir_${rname})/deps\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i /MBEDTLS/d deps/versions.mk
  echo MBEDTLS_VER=2.7.19 >> deps/versions.mk
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ( cd deps ; env LDFLAGS=-static CPPFLAGS= make build_deps )
  env LDFLAGS=-static CPPFLAGS= make V=1
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 ${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
