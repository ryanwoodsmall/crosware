rver="5.4.5"
sv="${rver%.*}"
sv="${sv//./}"
rname="lua${sv}"
rsha256="59df426a3d50ea535a460a452315c4c0d4e1121ba72ff0bdde58c2ef31d6f444"
. "${cwrecipe}/${rname%${sv}}/${rname%${sv}}.sh.common"
unset sv
