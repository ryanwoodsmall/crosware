rname="wolfmqtt"
rver="1.12.0"
rdir="${rname//mqtt/MQTT}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="16262b52c770b2c1a66cbe95bb0bcfb8b2a18e564bfffe90f5ba6db9b7c77d74"
rreqs="make wolfssl configgit toybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
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
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  mkdir -p \"${ridir}/bin\"
  for i in \$(find examples/ -type f -exec \"${cwsw}/toybox/current/bin/toybox\" file {} + | awk -F: '/ELF.*executable/{print \$1}') ; do
    n=\"\$(basename \${i})\"
    install -m 0755 \"\${i}\" \"${ridir}/bin/${rname}-\${n}\"
  done
  unset i n
  sed -i 's,${ridir},${rtdir}/current,g' \"${ridir}/bin/${rname}-config\"
  sed -i 's,-lwolfssl,-L${cwsw}/wolfssl/current/lib -lwolfssl,g' \"${ridir}/bin/${rname}-config\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
