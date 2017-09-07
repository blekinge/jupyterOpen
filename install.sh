#!/usr/bin/env bash

xdg-mime install --novendor xdg_jupyter.xml
cp jupyterOpen.sh $HOME/bin/ 
chmod a+x $HOME/bin/jupyterOpen.sh
xdg-desktop-menu install --novendor jupyter.desktop
