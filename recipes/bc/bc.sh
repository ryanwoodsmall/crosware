rname="bc"
rver="1.07.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="62adfca89b0a1c0164c2cdca59ca210c1d44c3ffc46daf9931cf4942664cb02a"
rreqs="bison ed flex make ncurses readline sed"

# XXX - docs need makeinfo/texinfo

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG '/^SUBDIRS/ s/doc//g' Makefile.{am,in}
  ./configure ${cwconfigureprefix} --with-readline LIBS='-lreadline -lncurses -static'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
