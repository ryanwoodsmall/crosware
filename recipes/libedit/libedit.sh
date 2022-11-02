rname="libedit"
rver="20221030-3.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://www.thrysoee.dk/editline/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="f0925a5adf4b1bf116ee19766b7daa766917aec198747943b1c4edf67a4be2bb"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} CFLAGS=\"\${CFLAGS} -D__STDC_ISO_10646__=201206L\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
