rname="wolfmqtt"
rver="1.13.0"
rdir="${rname//mqtt/MQTT}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="0132c47fba7001430b71cf96d6280ac44c8bf86d5242be8c591934e8d84a63b0"
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
