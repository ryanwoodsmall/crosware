rname="ag"
rver="2.2.0"
rdir="the_silver_searcher-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://geoff.greer.fm/${rname}/releases/${rfile}"
rsha256="d9621a878542f3733b5c6e71c849b9d1a830ed77cb1a1f6c2ea441d4b0643170"
rreqs="make zlib xz pkgconfig pcre"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
