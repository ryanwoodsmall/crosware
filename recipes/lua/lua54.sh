rver="5.4.6"
sv="${rver%.*}"
sv="${sv//./}"
rname="lua${sv}"
rsha256="7d5ea1b9cb6aa0b59ca3dde1c6adcb57ef83a1ba8e5432c0ecd06bf439b3ad88"
. "${cwrecipe}/${rname%${sv}}/${rname%${sv}}.sh.common"
unset sv
