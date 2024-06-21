ASSEMBLER6502	= acme
AS_FLAGS		= -v8 --color -Wtype-mismatch --strict-segments
RM				= rm
X16EMU			= ../x16emu/x16emu

PROGS		= acmehello.prg hello.prg mtest.prg
#PROGS		= acmehello.prg c64misc.prg ddrv128.prg ddrv64.prg macedit.prg reu-detect.prg trigono.o
# Automatically generate a list of .prg files from the existing .asm files
#PROGS = $(patsubst %.asm,%.prg,$(wildcard *.asm))

all: $(PROGS)

run-mtest: mtest.prg
	$(X16EMU) -prg mtest.prg -scale 2 -run -debug
mtest.prg: mtest.asm variables.asm vera.asm
# acmehello.prg: acmehello.asm
# 	$(ASSEMBLER6502) $(AS_FLAGS) --outfile acmehello.prg --format cbm -r acmehello.rpt acmehello.asm

%.prg: %.asm
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile $@ --format cbm -r $*.rpt $<

clean:
	-$(RM) -f *.o *.tmp $(PROGS) *~ core
