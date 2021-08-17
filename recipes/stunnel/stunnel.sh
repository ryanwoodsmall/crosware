rname="stunnel"
rver="5.60"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="ftp://ftp.${rname}.org/${rname}/archive/${rver%%.*}.x/${rfile}"
rurl="https://www.usenix.org.uk/mirrors/${rname}/archive/${rver%%.*}.x/${rfile}"
rsha256="c45d765b1521861fea9b03b425b9dd7d48b3055128c0aec673bba5ef9b8f787d"
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
