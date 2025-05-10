rname="rlwrap"
rver="0.46.2"
rdir="${rname}-${rver}"
#rfile="${rdir}.tar.gz"
rfile="${rdir}.tar.xz"
#rurl="https://github.com/hanslub42/${rname}/releases/download/v${rver}/${rfile}"
#rurl="https://github.com/hanslub42/${rname}/releases/download/${rver}/${rfile}"
#rurl="https://github.com/ryanwoodsmall/${rname}/releases/download/v${rver}/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/rlwrap/${rfile}"
rsha256="5905b65819487f71cea525ca16e5a6a83387591fefa07517aa40b8c11a48f82c"
rreqs="make netbsdcurses readlinenetbsdcurses configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    LIBS=\"-lreadline -lcurses -lterminfo\"
  which pod2man || sed -i.ORIG 's/pod2man/echo pod2man/g' filters/Makefile
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
