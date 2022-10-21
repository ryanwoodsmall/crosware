rname="rlwrap"
rver="0.46"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/hanslub42/${rname}/releases/download/v${rver}/${rfile}"
#rurl="https://github.com/hanslub42/${rname}/releases/download/${rver}/${rfile}"
#rurl="https://github.com/ryanwoodsmall/${rname}/releases/download/v${rver}/${rfile}"
rsha256="b4bd79fda824426dae65236e338ba7daf3f0d0acad7c1561d4d5e6dadcfd539d"
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
