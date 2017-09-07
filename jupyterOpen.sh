#!/usr/bin/env bash

WORKBOOK=$(realpath --relative-to="$HOME" "$*")

echo "Opening '$WORKBOOK'"

jupyterName=$(docker run \
    --rm \
    -d \
    -v $HOME:/home/jovyan:rw \
    --user $(id -u):$(id -g) \
    -p 127.0.0.1::8888 \
    --entrypoint /bin/bash \
    jupyter/datascience-notebook \
    -c 'source /home/jovyan/.profile && /usr/local/bin/start-notebook.sh --NotebookApp.token=""')

jupyterPort=$(docker inspect --format '{{ (index (index .NetworkSettings.Ports "8888/tcp") 0).HostPort }}' $jupyterName)

mkdir /tmp/$jupyterName-profile

#Fix so we run new instances of firefox per jupyter session
/usr/bin/firefox -no-remote --profile /tmp/$jupyterName-profile "http://localhost:$jupyterPort/notebooks/$WORKBOOK" || true

#TODO catch stuff to ensure that these steps will ALWAYS run
rm -rf /tmp/$jupyterName-profile

#
#
#docker run \
#        --rm \
#        --link $jupyterName:jupyter \
#        -v $HOME:/home/firefox:rw \
#        -v /tmp/.X11-unix:/tmp/.X11-unix \
#        -v /dev/snd:/dev/snd \
#        --privileged \
#        --user $(id -u):$(id -g) \
#        -e DISPLAY=unix$DISPLAY \
#        --entrypoint 'bash' \
#        chrisdaish/firefox \
#        /usr/bin/firefox -no-remote http://jupyter:8888/notebooks/$WORKBOOK \
#        || true #To ensure we do not crash and do not stop the jupyterDocker
#

docker stop $jupyterName
