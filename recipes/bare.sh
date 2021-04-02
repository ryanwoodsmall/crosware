rname=""
rver=""
rdir="${rname}-${rver}"
rfile="${rdir}.tar..."
rurl=""
rsha256=""
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

# echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
# echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
# echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
