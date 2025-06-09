rver="5.4.8"
sv="${rver%.*}"
sv="${sv//./}"
rname="lua${sv}"
rsha256="4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae"
. "${cwrecipe}/${rname%${sv}}/${rname%${sv}}.sh.common"
unset sv
