rname="jo"
rver="1.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jpmens/${rname}/releases/download/v${rver}/${rfile}"
rsha256="63ed4766c2e0fcb5391a14033930329369f437d7060a11d82874e57e278bda5f"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
