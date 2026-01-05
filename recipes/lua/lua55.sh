rver="5.5.0"
sv="${rver%.*}"
sv="${sv//./}"
rname="lua${sv}"
rsha256="57ccc32bbbd005cab75bcc52444052535af691789dba2b9016d5c50640d68b3d"
. "${cwrecipe}/${rname%${sv}}/${rname%${sv}}.sh.common"
unset sv
