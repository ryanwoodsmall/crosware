rname="diction"
rver="1.11"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="35c2f1bf8ddf0d5fa9f737ffc8e55230736e5d850ff40b57fdf5ef1d7aa024f6"
rreqs="make configgit gettexttiny"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  ./configure ${cwconfigureprefix} --disable-nls CC=\"\${CC}\" CFLAGS=-Wl,-static LDFLAGS=-static
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
