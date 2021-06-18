rver="5.2.4"
sv="${rver%.*}"
sv="${sv//./}"
rname="lua${sv}"
rsha256="b9e2e4aad6789b3b63a056d442f7b39f0ecfca3ae0f1fc0ae4e9614401b69f4b"
. "${cwrecipe}/${rname%${sv}}/${rname%${sv}}.sh.common"
unset sv
