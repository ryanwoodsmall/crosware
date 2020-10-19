rname="stunnel"
rver="5.57"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="ftp://ftp.${rname}.org/${rname}/archive/${rver%%.*}.x/${rfile}"
rsha256="af5ab973dde11807c38735b87bdd87563a47d2fa1c72a07929fcfce80a600fe1"
rreqs="make openssl zlib toybox perl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  grep -ril '/usr/bin/perl' . \
  | xargs sed -i \"s#/usr/bin/perl#${cwsw}/perl/current/bin/perl#g\"
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
