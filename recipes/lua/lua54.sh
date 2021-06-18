rver="5.4.3"
sv="${rver%.*}"
sv="${sv//./}"
rname="lua${sv}"
rsha256="f8612276169e3bfcbcfb8f226195bfc6e466fe13042f1076cbde92b7ec96bbfb"
. "${cwrecipe}/${rname%${sv}}/${rname%${sv}}.sh.common"
unset sv
