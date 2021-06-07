#!/bin/sh
cd ${HOME}/Desktop/
curl -OL\# https://www.python.org/ftp/python/3.9.0/python-3.9.0-macosx10.9.pkg
sudo installer -pkg python-3.9.0-macosx10.9.pkg -target /
sudo pip3.9 install jupyter
jupyter notebook

# 20210607165007
# 放置