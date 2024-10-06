#!/usr/bin/env bash
sudo mkdir -p /tmp/cw
sudo chmod 1777 /tmp/cw
docker run -it --rm \
  --network host \
  --privileged \
  --volume crosware-ccache:/root/.ccache \
  --volume crosware-downloads:/usr/local/crosware/downloads \
  --volume crosware-ult:/usr/local/tmp \
  --volume /tmp/cw:/tmp \
  --volume /dev/null:/dev/null \
    ryanwoodsmall/crosware:minimal
