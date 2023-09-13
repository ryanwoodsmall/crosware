#
# XXX - our perl needs to be at front of path for config/make
# XXX - other "openssl version -a" stuff?
# XXX - 1.1.1j disables threads/pic with -static in LDFLAGS. WHY? COME ON
# XXX - disable zlib to workaround some conflicts (redis) and pain with forcing libz.a
# XXX - remove `-lz` "fix" - this shouldn't be necessary but will need a full rebuild
# XXX - need openssl11, openssl3, etc.?
#

v="111"
rname="openssl"
rver="$(cwver_${rname}${v})"
rdir="$(cwdir_${rname}${v})"
rfile="$(cwfile_${rname}${v})"
rurl="$(cwurl_${rname}${v})"
rsha256=""
rreqs="openssl${v}"

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwfetch_${rname}"
cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${rtdir}\"
  rm -rf \"${rtdir}/current\"
  rm -rf \"\$(cwidir_${rname})\"
  ln -sf \"\$(cwidir_${rname}${v})\" \"\$(cwidir_${rname})\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  #echo 'append_cppflags \"-I${rtdir}/current/include/${rname}\"' >> \"${rprof}\"
}
"

unset v
