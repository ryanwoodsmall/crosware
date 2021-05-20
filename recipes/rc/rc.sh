#
# XXX - this really needs to be a git commit, release is way out of date
#       repo: https://github.com/rakitzis/rc
# XXX - maybe the fork at: https://github.com/muennich/rc
#

rname="rc"
rver="1.7.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="http://static.tobold.org/${rname}/${rfile}"
#rurl="https://sources.voidlinux.org/${rdir}/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="5ed26334dd0c1a616248b15ad7c90ca678ae3066fa02c5ddd0e6936f9af9bfd8"
rreqs="make readline"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --with-edit=readline
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
