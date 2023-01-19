#
# XXX - distribute an autotools-ed version of the archive?
#
rname="muslfts"
rver="1.2.7"
rdir="musl-fts-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/pullmoll/musl-fts/archive/${rfile}"
rsha256="49ae567a96dbab22823d045ffebe0d6b14b9b799925e9ca9274d47d26ff482a6"
rreqs="make sed autoconf automake libtool pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH} libtoolize -fiv
  env PATH=${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH} \
    ${cwsw}/autoconf/current/bin/autoreconf -fiv -I${cwsw}/pkgconfig/current/share/aclocal/
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
