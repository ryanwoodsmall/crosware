#
# XXX - move to netbsdcurses
#

rname="inetutils"
rver="1.9.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="849d96f136effdef69548a940e3e0ec0624fc0c81265296987986a0dd36ded37"
rreqs="make sed ncurses readline configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd '${rbdir}' >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --libexecdir='${ridir}/sbin' \
    --enable-servers \
    --enable-clients \
    --disable-rcp \
    --disable-rlogin \
    --disable-rsh
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install-strip
  find ${ridir}/bin/ ${ridir}/sbin/ | xargs chmod a+x
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_path \"${rtdir}/current/sbin\"' >> "${rprof}"
}
"
