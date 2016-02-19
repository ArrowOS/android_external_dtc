TARGETS = dtc
CFLAGS = -Wall -g

BISON = bison

OBJS = dtc.o livetree.o flattree.o data.o treesource.o fstree.o \
	dtc-parser.tab.o lex.yy.o

DEPFILES = $(OBJS:.o=.d)

all: $(DEPFILES) $(TARGETS)

dtc:	$(OBJS)
	$(LINK.c) -o $@ $^

dtc-parser.tab.c dtc-parser.tab.h dtc-parser.output: dtc-parser.y
	$(BISON) -d $<

lex.yy.c: dtc-lexer.l
	$(LEX) $<

lex.yy.o: lex.yy.c dtc-parser.tab.h

check: all
	cd tests && $(MAKE) check

clean:
	rm -f *~ *.o a.out core $(TARGETS)
	rm -f *.tab.[ch] lex.yy.c
	rm -f *.i *.output vgcore.*
	rm -f *.d
	cd tests && $(MAKE) clean

%.d: %.c
	$(CC) -MM -MG -MT "$*.o $@" $< > $@

-include $(DEPFILES)
