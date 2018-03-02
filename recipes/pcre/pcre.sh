rname="pcre"
rver="8.41"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://ftp.pcre.org/pub/${rname}/${rfile}"
rsha256="e62c7eac5ae7c0e7286db61ff82912e1c0b7a0c13706616e94a7dd729321b530"
rreqs="make zlib bzip2 readline"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --enable-pcre8 \
    --enable-pcre16 \
    --enable-pcre32 \
    --enable-pcregrep-libz \
    --enable-pcregrep-libbz2 \
    --enable-pcretest-libreadline \
    --enable-unicode-properties \
    --enable-utf
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
