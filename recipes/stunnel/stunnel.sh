rname="stunnel"
rver="5.62"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="ftp://ftp.${rname}.org/${rname}/archive/${rver%%.*}.x/${rfile}"
#rurl="https://www.usenix.org.uk/mirrors/${rname}/archive/${rver%%.*}.x/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="9cf5bb949022aa66c736c1326554cca27d0641605a6370274edc4951eb5bd339"
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
