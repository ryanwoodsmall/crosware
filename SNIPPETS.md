# SNIPPETS.md

...

## docker sha256

```bash
(
  v="29.9.3"
  u="https://download.docker.com/linux/static/stable"
  for a in aarch64 armhf x86_64 ; do
    for p in '' rootless-extras- ; do
      echo "${v} : ${a} : ${p}"
      curl -kL -o "${cwtop}/tmp/${a}_docker-${p}${v}.tgz" "${u}/${a}/docker-${p}${v}.tgz"
      echo $?
      echo
    done
  done
)
```
