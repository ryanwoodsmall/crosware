rname="wolfmqtt"
rver="1.18.0"
rdir="${rname//mqtt/MQTT}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="a673c5520a0a0bc25be2edce9ce51431f3c0639db84911fafc9c18b922779077"
rreqs="make wolfssl configgit toybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --enable-all \
    --with-libwolfssl-prefix=\"${cwsw}/wolfssl/current\" \
      PKG_CONFIG_{LIBDIR,PATH}= \
      CPPFLAGS=\"-I${cwsw}/wolfssl/current/include\" \
      LDFLAGS=\"-L${cwsw}/wolfssl/current/lib -static -s\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  mkdir -p \"\$(cwidir_${rname})/bin\"
  for i in \$(find examples/ -type f -exec \"${cwsw}/toybox/current/bin/toybox\" file {} + | awk -F: '/ELF.*executable/{print \$1}') ; do
    n=\"\$(basename \${i})\"
    install -m 0755 \"\${i}\" \"\$(cwidir_${rname})/bin/${rname}-\${n}\"
  done
  unset i n
  sed -i \"s,\$(cwidir_${rname}),${rtdir}/current,g\" \"\$(cwidir_${rname})/bin/${rname}-config\"
  sed -i 's,-lwolfssl,-L${cwsw}/wolfssl/current/lib -lwolfssl,g' \"\$(cwidir_${rname})/bin/${rname}-config\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
