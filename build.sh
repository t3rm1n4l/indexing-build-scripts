#!/bin/bash -xe

basepath=$(pwd)/../
if [ -z "$1" ];
then
    basepath=$(pwd)/../
else
    basepath=$1/../
fi

mkdir -p $basepath/forestdb/build
pushd $basepath/forestdb/build
cmake ../
make

mkdir -p $basepath/install/{lib,bin}
cp $basepath/forestdb/build/libforestdb* $basepath/install/lib


export GOPATH=$basepath/build/gobuild
gosrc=$GOPATH/src
mkdir -p $gosrc

for repo in github.com/couchbaselabs/{goprotobuf,retriever,dparval,go-couchbase,clog,go-slab,goforestdb,tuqtng,query} \
    github.com/couchbase/{gomemcached,indexing} \
    github.com/prataprc/collatejson \
    github.com/dustin/{gojson,go-jsonpointer} \
    github.com/gorilla/{context,mux} \
    github.com/sbinet/liner
do
    rm -rf $gosrc/$repo
    mkdir -p $gosrc/$repo
    project=`basename $repo`
    cp -r $basepath/$project/* $gosrc/$repo/
done

export C_INCLUDE_PATH=$C_INCLUDE_PATH:$basepath/forestdb/include/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$basepath/install/lib
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$basepath/install/lib

pushd $gosrc/github.com/couchbase/indexing/secondary/projector/main
go build -o projector
cp projector $basepath/install/bin/
popd


pushd $gosrc/github.com/couchbase/indexing/secondary/indexer/main
CGO_LDFLAGS="-L $basepath/install/lib -Wl,-rpath,$basepath/install/lib" go build -o indexer
cp indexer $basepath/install/bin/
popd

pushd $gosrc/github.com/couchbaselabs/tuqtng
go build -o cbq_engine
cp cbq_engine $basepath/install/bin/

pushd cbq
go build -o cbq
cp cbq $basepath/install/bin/
popd

popd
