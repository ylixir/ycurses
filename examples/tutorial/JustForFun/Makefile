# Makefile for JustForFun Files

# A few variables

LIBS=-L-lncurses

SRC_DIR=.
EXE_DIR=../demo/exe

EXES = \
	${EXE_DIR}/hanoi \
	${EXE_DIR}/life\
	${EXE_DIR}/magic \
	${EXE_DIR}/queens \
	${EXE_DIR}/shuffle \
	${EXE_DIR}/tt

${EXE_DIR}/%: %.o
	${DC} -of$@ $< ${LIBS}

%.o: ${SRC_DIR}/%.d
	${DC} -of$@ -c $< ${IMPORTS}

all:    ${EXES}

clean:
	@rm -f ${EXES}
