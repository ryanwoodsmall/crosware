rname="nettleminimal"
rver="$(cwver_nettle)"
rdir="$(cwdir_nettle)"
rbdir="$(cwbdir_nettle)"
rfile="$(cwfile_nettle)"
rdlfile="$(cwdlfile_nettle)"
rurl="$(cwurl_nettle)"
rsha256="$(cwsha256_nettle)"
rreqs="bootstrapmake"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

for f in clean fetch make ; do
  eval "function cw${f}_${rname}() { cw${f}_nettle ; }"
done

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --libdir=\"\$(cwidir_${rname})/lib\" \
    --disable-assembler \
    --disable-documentation \
    --disable-openssl \
    --enable-mini-gmp \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"
