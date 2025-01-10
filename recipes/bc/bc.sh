rname="bc"
rver="1.08.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/bc/${rfile}"
rsha256="b71457ffeb210d7ea61825ff72b3e49dc8f2c1a04102bbe23591d783d1bfe996"
rreqs="bison ed flex make readlinenetbsdcurses netbsdcurses sed texinfo"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  : sed -i.ORIG '/^SUBDIRS/ s/doc//g' Makefile.{am,in}
  ./configure ${cwconfigureprefix} \
    --with-readline \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include) -static -s\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      LIBS='-lreadline -lcurses -lterminfo -static'
  sed -i.ORIG '/:.*LDADD/s,LDADD,LIBBC,g' ./dc/Makefile
  pushd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
