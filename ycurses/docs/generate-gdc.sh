#!/bin/bash
DOCDIR=`pwd`
pushd ../modules/
gdmd -D -Dd$DOCDIR -c -o- *.d $DOCDIR/candydoc/candy.ddoc $DOCDIR/candydoc/modules.ddoc
#gdc -fdoc -fdoc-dir=$DOCDIR -c -fsyntax-only *.d $DOCDIR/candydoc/candy.ddoc $DOCDIR/candydoc/modules.ddoc
popd
