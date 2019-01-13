rname="stunnel"
rver="5.50"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.${rname}.org/downloads/${rfile}"
rsha256="951d92502908b852a297bd9308568f7c36598670b84286d3e05d4a3a550c0149"
rreqs="make openssl zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-fips \
    --disable-libwrap \
    --disable-systemd \
    --with-ssl=\"${cwsw}/openssl/current\" \
      LIBS='-lz'
  find . -type f -name Makefile -exec sed -i 's/-fPIE/-fPIC/g' {} \;
  find . -type f -name Makefile -exec sed -i 's/-pie//g' {} \;
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
