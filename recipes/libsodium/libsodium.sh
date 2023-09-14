#
# XXX - this probably needs to be the -stable release, but the archive appears to change w/additions
# XXX - could just download every build but that precludes cache and known-good sha-256, ugh
#
rname="libsodium"
rver="1.0.19"
rdir="${rname}-${rver}"
rbdir="${cwbuild}/${rname}-stable"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jedisct1/${rname}/releases/download/${rver}-RELEASE/${rfile}"
rsha256="018d79fe0a045cca07331d37bd0cb57b2e838c51bc48fd837a1472e50068bbea"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
