rname="indent"
rver="2.2.10"
#rver="2.2.11"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="8a9b41be5bfcab5d8c1be74204b10ae78789fc3deabea0775fdced8677292639"
#rurl="http://dev.alpinelinux.org/archive/${rname}/${rfile}"
#rsha256="aaff60ce4d255efb985f0eb78cca4d1ad766c6e051666073050656b6753a0893"
rreqs="make sed flex configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cd config
  mv config.sub{,.ORIG}
  mv config.guess{,.ORIG}
  install -m 0755 ${cwsw}/configgit/current/config.sub config.sub
  install -m 0755 ${cwsw}/configgit/current/config.guess config.guess
  cd ..
  sed -i.ORIG 's/GNUC/GNUC_OFF/g' src/lexi.c
  sed -i.ORIG '/SUBDIRS/ s/doc//g' Makefile.in Makefile.am
  ./configure ${cwconfigureprefix} --disable-nls --without-included-gettext
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
