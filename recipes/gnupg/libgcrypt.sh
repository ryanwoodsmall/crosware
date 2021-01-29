#
# XXX - 1.9.0 insecure, 1.9.1 (a SECURITY fix) introduced something (ungated FEATURES?) that breaks compilation
#  keccak.c: In function 'keccak_init':
#  keccak.c:907:23: error: 'HWF_INTEL_FAST_SHLD' undeclared (first use in this function)
#    907 |   else if (features & HWF_INTEL_FAST_SHLD)
#        |                       ^~~~~~~~~~~~~~~~~~~
#  keccak.c:907:23: note: each undeclared identifier is reported only once for each function it appears in
#

rname="libgcrypt"
rver="1.8.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="03b70f028299561b7034b8966d7dd77ef16ed139c43440925fe8782561974748"
rreqs="make libgpgerror slibtool configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-asm \
    --with-libgpg-error-prefix=\${cwsw}/libgpgerror/current/
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
