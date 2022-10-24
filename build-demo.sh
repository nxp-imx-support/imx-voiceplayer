#!/bin/sh


if [ "$1" != "" ]; then
      BUILD_TYPE=$1
    else
      BUILD_TYPE=demo
fi


BUILD_OUTPUT_DIR=build_output_${BUILD_TYPE}

rm -rfv  ${BUILD_OUTPUT_DIR}.tgz ${BUILD_OUTPUT_DIR}
mkdir -p ${BUILD_OUTPUT_DIR}


#### BUILD APP GUI ####

rm -rf build
mkdir -p build
cd build

qmake ../Btplayer.pro 

make -j8
cd ..


#### BUILD APP COMPONENTS ####

rm -rf msgq/build 
mkdir -p msgq/build 
cd msgq/build

cmake ..
make -j8
cd ../..


rm -rf vit-using-vad-ww-and-vc/build 
#mkdir -p vit-using-vad-ww-and-vc/build 
#cd vit-using-vad-ww-and-vc/build
make -j8
cd ../..


#### PACK DEMO COMPONENTS ####

cp -a build/Btplayer ${BUILD_OUTPUT_DIR}
cp -a msgq/build/MsgQ ${BUILD_OUTPUT_DIR}
cp -a vit-using-vad-ww-and-vc/build/btp_vit ${BUILD_OUTPUT_DIR}
cp -a sh/*.sh ${BUILD_OUTPUT_DIR}

#cd ..
tar zcvf ${BUILD_OUTPUT_DIR}.tgz ${BUILD_OUTPUT_DIR}
#cd 
