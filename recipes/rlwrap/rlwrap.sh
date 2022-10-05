rname="rlwrap"
rver="0.45.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://github.com/hanslub42/${rname}/releases/download/${rver}/${rfile}"
rurl="https://github.com/ryanwoodsmall/${rname}/releases/download/v${rver}/${rfile}"
rsha256="626ff6260dd3dd9d93b98b149a563067a2b22da70dcee39475387c0eefd2e70f"
rreqs="make netbsdcurses readlinenetbsdcurses configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    LIBS=\"-lreadline -lcurses -lterminfo\"
  which pod2man || sed -i.ORIG 's/pod2man/echo pod2man/g' filters/Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
