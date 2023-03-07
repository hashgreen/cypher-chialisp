PYTHONPATH := .:$(PYTHONPATH)
PY ?= PYTHONPATH=$(PYTHONPATH) python

RUN ?= run --include .
OPC ?= opc
RM ?= rm -f

clvm_target_for_coin = $(1).clvm $(1).clvm.hex $(1).clvm.hex.sha256tree
clvm_target_for_folder = $(foreach target,$(2),$(call clvm_target_for_coin,$(1)/$(target)))

.PRECIOUS: %.clvm %.clvm.hex %.clvm.hex.sha256tree

%.clvm: %.clsp
	$(RUN) $^ > $@

%.clvm.hex: %.clvm
	$(OPC) $^ > $@

%.clvm.hex.sha256tree: %.clvm
	$(OPC) --script-hash $^ > $@

# chia standards

chia_clvm_targets = $(call clvm_target_for_folder,chia, \
	cat-v1 \
	cat-v2 \
	singleton \
	singleton-v1-1 \
)

compile-chia: $(chia_clvm_targets)

clean-chia:
	-$(RM) $(chia_clvm_targets)


# tests

test_targets = $(subst clsp,clvm,$(shell ls tests/test-*.clsp))

compile-test: $(test_targets)

clean-test:
	-$(RM) $(test_targets)


# general

test: compile-test

clean: clean-chia clean-test
