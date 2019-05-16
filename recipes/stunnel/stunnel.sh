rname="stunnel"
rver="5.54"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="ftp://ftp.${rname}.org/${rname}/archive/${rver%%.*}.x/${rfile}"
rsha256="5e8588a6c274b46b1d63e1b50f0725f4908dec736f6588eb48d1eb3d20c87902"
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
