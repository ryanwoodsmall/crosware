#
# XXX - provide an update function to rename/move config.sub/config.guess and copy new ones in?
#

rname="configgit"
rver="dd5d5dd697df579a5ebd119a88475b446c07c6b0"
rdir="config-dd5d5dd"
rfile="${rdir}.tar.gz"
rurl="http://git.savannah.gnu.org/gitweb/\?p=config.git\;a=snapshot\;h=${rver}\;sf=tgz"
rsha256="4eac11d10beaef441d1fe38bc83a59667a3aae85cd68ae82e3f33000a61a495f"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  #cwscriptecho \"cwconfigure_${rname} noop\"
  echo -n
}
"

eval "
function cwmake_${rname}() {
  #cwscriptecho \"cwmake_${rname} noop\"
  echo -n
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cwmkdir "${ridir}"
  install -m 0755 config.guess ${ridir}/config.guess
  install -m 0755 config.sub ${ridir}/config.sub
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  #cwscriptecho \"cwgenprofd_${rname} noop\"
  echo -n
}
"
