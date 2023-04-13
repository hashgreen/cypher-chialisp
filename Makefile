PYTHONPATH := .:$(PYTHONPATH)
PY ?= PYTHONPATH=$(PYTHONPATH) python

RM ?= rm -f
OPC ?= opc

RUN_RS = run $(INCLUDE)
RUN_PY = scripts/run_py $(INCLUDE)

ifeq ($(PYPY_MODE),1)
  RUN = $(RUN_PY)
else
  RUN = $(RUN_RS)
endif

clvm_target_for_coin = $(1).clvm $(1).clvm.hex $(1).clvm.hex.sha256tree
clvm_target_for_scheme = $(foreach target,$(2),$(call clvm_target_for_coin,$(1)/$(target)))

.PRECIOUS: %.clvm %.clvm.hex %.clvm.hex.sha256tree

%.clvm: %.clsp
	$(RUN) $^ > $@

%.clvm.hex: %.clvm
	$(OPC) $^ > $@

%.clvm.hex.sha256tree: %.clvm
	$(OPC) --script-hash $^ > $@

# chia standards

CHIA_CLVM_TARGETS = $(call clvm_target_for_scheme,chia, \
	cat-v1 \
	cat-v2 \
	singleton \
	singleton-v1-1 \
)

compile-chia: $(CHIA_CLVM_TARGETS)
clean-chia:
	-$(RM) $(CHIA_CLVM_TARGETS)

TEST_TARGETS = $(subst clsp,clvm,$(shell ls tests/test-*.clsp))

compile-test: $(TEST_TARGETS)
clean-test:
	-$(RM) $(TEST_TARGETS)

test: compile-test
compile: compile-chia compile-test
clean: clean-chia clean-test
