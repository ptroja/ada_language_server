#!/bin/bash

set -e -x

function linux_before_install()
{
    docker build --tag lsp --file integration/travis/Dockerfile .
}

function linux_script()
{
    TAG=${TRAVIS_TAG:-latest}
    sed -i -e "s/VERSION/$TAG/g" integration/travis/bintray.json
    docker run -i -t -v$(pwd)/upload:/upload --env TRAVIS_TAG lsp /bin/bash -c \
 'make -C /tmp/ada_language_server LIBRARY_TYPE=relocatable deploy'

}

GNAT_INSTALLER=gnat-community-2019-20190517-x86_64-darwin-bin.dmg
INSTALL_DIR=$PWD/../gnat

function osx_before_install()
{
    echo INSTALL_DIR=$INSTALL_DIR
    git clone https://github.com/AdaCore/gnat_community_install_script.git
    wget -nv -O $GNAT_INSTALLER \
        http://mirrors.cdn.adacore.com/art/5ce0322c31e87a8f1d4253fa
    sh gnat_community_install_script/install_package.sh \
        $GNAT_INSTALLER $INSTALL_DIR
    $INSTALL_DIR/bin/gprinstall --uninstall gnatcoll
    wget -nv -O- https://dl.bintray.com/reznikmm/libadalang/libadalang-stable-osx.tar.gz \
        | tar xzf - -C $INSTALL_DIR
}

function osx_script()
{
    export PATH=$INSTALL_DIR/bin:$PATH
    export LIBRARY_PATH=/usr/local/lib        # To find GMP
    make OS=osx LIBRARY_TYPE=relocatable all
    integration/travis/deploy.sh darwin
}

${TRAVIS_OS_NAME}_$1
