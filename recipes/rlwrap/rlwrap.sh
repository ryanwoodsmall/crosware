rname="rlwrap"
rver="0.48"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rfile="${rdir}.tar.xz"
rurl="https://github.com/hanslub42/rlwrap/releases/download/v${rver}/${rfile}"
#rurl="https://github.com/hanslub42/rlwrap/releases/download/${rver}/${rfile}"
#rurl="https://github.com/ryanwoodsmall/rlwrap/releases/download/v${rver}/${rfile}"
#rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/rlwrap/${rfile}"
rsha256="cdf69074a216a8284574dddd145dd046c904ad5330a616e0eed53c9043f2ecbc"
rreqs="make netbsdcurses readlinenetbsdcurses configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --without-libptytty \
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
