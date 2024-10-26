rname="9mount"
rver="8009fdbb8022fb1320e297ee60024362e0df5618"
rdir="${rname}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/sqweek/9mount/archive/${rfile}"
rsha256="485f9bc0aa7c30aa683c960a52f44db248c109bec1462fb540b33705258cfd88"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install prefix=\"\$(cwidir_${rname})\" CPPFLAGS= LDFLAGS=-static
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
