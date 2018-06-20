rname="cxref"
rver="1.6e"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://www.gedanken.org.uk/software/${rname}/download/${rfile}"
rsha256="21492210f9e1030e4e697f0d84f31ac57a0844e64c8fb28432001c44663242f2"
rreqs="make bison flex"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
