#!/bin/bash
gdmd -D -c -o- ../modules/*.d candydoc/candy.ddoc candydoc/modules.ddoc -I../modules
