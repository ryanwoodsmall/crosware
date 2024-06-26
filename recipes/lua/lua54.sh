rver="5.4.7"
sv="${rver%.*}"
sv="${sv//./}"
rname="lua${sv}"
rsha256="9fbf5e28ef86c69858f6d3d34eccc32e911c1a28b4120ff3e84aaa70cfbf1e30"
. "${cwrecipe}/${rname%${sv}}/${rname%${sv}}.sh.common"
unset sv
