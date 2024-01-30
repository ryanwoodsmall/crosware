#
# XXX - provide an update function to rename/move config.sub/config.guess and copy new ones in?
#       cwfixupconfig_${rname}()
# XXX - cgit or gitweb?
#     - cgit for now
#     - cgit urls easier to escape
#     - gitweb url is something like http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=${rver}
# XXX - broken as of 20240130
#

rname="configgit"
rver="dd5d5dd697df579a5ebd119a88475b446c07c6b0"
rdir="${rname}-${rver}"
rurl="http://git.savannah.gnu.org/cgit/config.git/plain"
rfile=""
rsha256=""
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \
    \"https://raw.githubusercontent.com/ryanwoodsmall/crosware-source-mirror/master/configgit/\$(cwver_${rname})_config.guess\" \
    \"${cwdl}/${rname}/config.guess\" \
    \"917194b0e3c0e22e16b8416f9c48e465d4c84d7d49e0dfe60b7ed95e9a0fa7df\"
  cwfetchcheck \
    \"https://raw.githubusercontent.com/ryanwoodsmall/crosware-source-mirror/master/configgit/\$(cwver_${rname})_config.sub\" \
    \"${cwdl}/${rname}/config.sub\" \
    \"d33ce42392950b609356a93f2fc91d2575d3b98d1b904b1add111398b51a530a\"
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"\$(cwidir_${rname})\"
  rm -f \$(cwidir_${rname})/config.{guess,sub}
  install -m 0755 \"${cwdl}/${rname}/config.guess\" \"\$(cwidir_${rname})/config.guess\"
  install -m 0755 \"${cwdl}/${rname}/config.sub\" \"\$(cwidir_${rname})/config.sub\"
}
"
