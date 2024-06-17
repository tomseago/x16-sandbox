ASSEMBLER6502	= acme
AS_FLAGS	= -v8 -Wtype-mismatch --strict-segments
RM		= rm

PROGS		= acmehello.prg 
#PROGS		= acmehello.prg c64misc.prg ddrv128.prg ddrv64.prg macedit.prg reu-detect.prg trigono.o

all: $(PROGS)

acmehello.prg: acmehello.asm
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile acmehello.prg --format cbm acmehello.asm

clean:
	-$(RM) -f *.o *.tmp $(PROGS) *~ core
