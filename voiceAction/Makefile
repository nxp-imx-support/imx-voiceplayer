BLDDIR=build

TEST_FILES= \
	BTPVA_action_executor.c

IFLAGS=-I/${OECORE_TARGET_SYSROOT}/usr/include/glib-2.0 \
       -I/${OECORE_TARGET_SYSROOT}/usr/lib/glib-2.0/include -lglib-2.0 \
       -I/${OECORE_TARGET_SYSROOT}/usr/include/dbus-1.0/ \
       -I/${OECORE_TARGET_SYSROOT}/usr/lib/dbus-1.0/include/

CFLAGS=-std=gnu99 \
	 -Wno-unused-variable \
	 -Wsign-compare \
	 -Wno-unused-result \
	 -Wno-unused-function \
	 -Wno-unused-but-set-variable \
	 -no-pie \
	 -DPLATFORM_AARCH64 \
	 -Werror \
	 -DTOOLCHAIN_GCC \
	 -DARM_MATH_NEON \
	 -g3 \
	 -Wall \
	 -D_FILE_OFFSET_BITS=64 \
	 -DUSE_NN_FROM_GLOW \
	 -DARCH_AARCH64 \
	 -DRUN_ON_OTHER_THREAD \
	 -pthread \
	 -ldbus-1 \
	 -lrt \
	 $(IFLAGS)

EXE_OBJ_FILES   = $(addprefix $(BLDDIR)/,$(patsubst %.c,%.o,$(notdir $(TEST_FILES))))

vpath %.c \
	$(BLDDIR)

EXE       = $(BLDDIR)/btp

all : mkdir $(EXE)

mkdir : $(BLDDIR)/.mkdir

$(BLDDIR)/.mkdir :
	@mkdir -p $(BLDDIR)

-include $(wildcard $(BLDDIR)/*.d)


$(EXE) : $(EXE_OBJ_FILES)
	$(CC) $(CFLAGS)  $^  \
	 -lm  \
	  -o $@

$(BLDDIR)/%.o : %.c $(BLDDIR)/compiler_flags
	$(CC) $(CFLAGS) $(LDFLAGS) -MD -MF $(subst .o,.d,$@) -c -o $@ $<

clean :
	rm -f $(BLDDIR)/*
	rmdir $(BLDDIR)

.PHONY : all mkdir clean

.PHONY: force
$(BLDDIR)/compiler_flags: force
	@echo '$(CFLAGS)' | cmp -s - $@ || echo '$(CFLAGS)' > $@
