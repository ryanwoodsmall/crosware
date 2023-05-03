rver="5.4.4"
sv="${rver%.*}"
sv="${sv//./}"
rname="lua${sv}"
rsha256="164c7849653b80ae67bec4b7473b884bf5cc8d2dca05653475ec2ed27b9ebf61"
. "${cwrecipe}/${rname%${sv}}/${rname%${sv}}.sh.common"
unset sv
