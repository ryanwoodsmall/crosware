rname="njsquickjs"
rver="$(cwver_njs)"
rdir="$(cwdir_njs)"
rfile="$(cwfile_njs)"
rdlfile="$(cwdlfile_njs)"
rurl="$(cwurl_njs)"
rsha256="$(cwsha256_njs)"
rreqs="libressl quickjs"

. "${cwrecipe}/nginx/njs.sh.common"

for f in clean fetch extract make ; do
  eval "function cw${f}_${rname}() {
    cw${f}_${rname%quickjs}
  }"
done

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwpatch_${rname%%quickjs}
  cat auto/quickjs > auto/quickjs.ORIG
  echo -n > auto/quickjs
  : echo 'set -x' > auto/quickjs
  cat auto/quickjs.ORIG >> auto/quickjs
  sed -i s,/usr/include/quickjs,${cwsw}/quickjs/current/include/quickjs,g auto/quickjs
  sed -i s,/usr/lib/quickjs,${cwsw}/quickjs/current/lib/quickjs,g auto/quickjs
  sed -i s,-lquijs,-lquickjs,g auto/quickjs
  : sed -i 's,\\.lto,,g' auto/quickjs
  : sed -i 's,-I${cwsw}/quickjs/current/include/quickjs/,-I${cwsw}/quickjs/current/include/quickjs/ -I${cwsw}/quickjs/current/include/,g' auto/quickjs
  : sed -i 's,-L${cwsw}/quickjs/current/lib/quickjs/,-L${cwsw}/quickjs/current/lib/quickjs/ -L${cwsw}/quickjs/current/lib/,g' auto/quickjs
  : echo 'set +x' >> auto/quickjs
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure \
    --cc-opt=\"\${CFLAGS} \$(echo -I${cwsw}/{${rreqs// /,}}/current/include -I${cwsw}/quickjs/current/include/quickjs)\" \
    --ld-opt=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib -L${cwsw}/quickjs/current/lib/quickjs) -static\" \
    --with-quickjs
  popd &>/dev/null
}
"
