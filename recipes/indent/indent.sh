rname="indent"
rver="2.2.12"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="e77d68c0211515459b8812118d606812e300097cfac0b4e9fb3472664263bb8b"
rreqs="make sed flex configgit texinfo gettexttiny slibtool bison"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cd config
  cd ..
  sed -i.ORIG 's/GNUC/GNUC_OFF/g' src/lexi.c
  sed -i.ORIG '/SUBDIRS/ s/doc//g' Makefile.in Makefile.am
  sed -i.ORIG 's/-Werror//g' src/Makefile.{in,am}
  ./configure ${cwconfigureprefix} \
    --disable-nls \
    --without-included-gettext \
    gl_cv_cc_vis_werror=no \
    LIBTOOL=\"${cwsw}/slibtool/current/bin/slibtool-static -all-static\"
  echo '#include <locale.h>' >> config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
