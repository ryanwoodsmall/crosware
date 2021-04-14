#!/usr/bin/env bash

#
# test currently installed curl version for https interop
#
# XXX - test http/2? https://github.com/curl/curl/issues/6825
#

if [ -z "${cwsw}" ] ; then
  echo "is this crosware?" 1>&2
  exit 1
fi

sn="${0}"

durl="https://www.google.com"

: ${copts:="-fkILs"}

if [[ ${@} =~ -h ]] ; then
cat >/dev/stderr<<EOF
${sn}: usage
  ${sn} # HTTPS HEAD test against default url: ${durl}
  ${sn} https://site.com/ # HTTPS HEAD test against site.com
  env url=http://my.site ${sn} # HTTP HEAD test against my.site
  # curl options in variable \${copts} - default: ${copts}
  # note: \${url} environment variable takes precedence over cli argument
EOF
exit 1
fi

if [ ${#} -eq 0 ] ; then
: ${url:="${durl}"}
else
  if [ -z "${url}" ] ; then
    url="${1}"
  fi
fi

rec=0
for i in $(realpath ${cwsw}/curl/current/bin/curl-*{ssl,tls}* | sort -u) ; do
  echo "--"
  echo "${i}"
  echo "url: ${url}"
  "${i}" --version
  "${i}" ${copts} "${url}"
  ec="${?}"
  ((rec+=ec))
  echo "${ec}"
  echo "--"
done
exit $((${rec}%256))
