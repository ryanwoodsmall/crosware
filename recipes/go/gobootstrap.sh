rname="gobootstrap"
rver="1.4-bootstrap-20171003"
if [[ ${karch} =~ ^x86_64$ ]] ; then
  rdir="go${rver}-amd64"
  rsha256="320908bbb8b974d7bc3e77eef636154422351ea77e95420329bf70cddafa3ece"
elif [[ ${karch} =~ ^i.86$ ]] ; then
  rdir="go${rver}-386"
  rsha256="79bf677d1f51d3fe688ffc3e38129f357b299ec5a5a54a699e3f8a1455bf7687"
elif [[ ${karch} =~ ^a ]] ; then
  rdir="go${rver}-arm"
  rsha256="a2ba394bb21a28a33fbb9884891132a6cfb29283104f552c998e351993be0c76"
else
  rdir="none"
  rsha256="none"
fi
rdate="20191102"
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/go-misc/releases/download/${rdate}-go1.13.4/${rfile}"

. "${cwrecipe}/go/go.sh.common"
