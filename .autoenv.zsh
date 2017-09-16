autostash PROJDIR=`dirname $0`
autostash PATH=$PATH:$PROJDIR/node_modules/.bin

0() {
    cd $PROJDIR
}

t() {
    cd $PROJDIR && elm-test
}

tw() {
    cd $PROJDIR && elm-test --watch
}
