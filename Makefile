CHIA_PUZZLE_DIR = ../chia-blockchain/chia/wallet/puzzles
RUN = run --include . --include chia/puzzles
OPC = opc
DIFF = git diff --word-diff=plain --word-diff-regex=. --no-index

clvm_target_for_coin = $(1).clvm $(1).clvm.hex $(1).clvm.hex.sha256tree
clvm_target_for_folder = $(foreach target,$(2),$(call clvm_target_for_coin,$(1)/$(target)))

.PRECIOUS: %.clvm %.clvm.hex %.clvm.hex.sha256tree

%.clvm: %.clsp
	$(RUN) $^ > $@

%.clvm.hex: %.clvm
	$(OPC) $^ > $@

%.clvm.hex.sha256tree: %.clvm
	$(OPC) --script-hash $^ > $@

chia_clvm_targets = $(call clvm_target_for_folder,chia, \
	cat-v1 \
	cat-v2 \
	singleton \
	singleton-v1-1 \
)

compile-chia: $(chia_clvm_targets)

diff-chia:
	-$(DIFF) chia/cat-v2.clvm.hex chia/puzzles/cat_v2.clvm.hex;
	-$(DIFF) chia/cat-v1.clvm.hex $(CHIA_PUZZLE_DIR)/cat.clvm.hex;
	-$(DIFF) chia/singleton.clvm.hex $(CHIA_PUZZLE_DIR)/singleton_top_layer.clvm.hex;
	-$(DIFF) chia/singleton-v1-1.clvm.hex $(CHIA_PUZZLE_DIR)/singleton_top_layer_v1_1.clvm.hex;
