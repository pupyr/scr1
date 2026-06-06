
ARCH_lowercase = $(shell echo $(ARCH) | tr A-Z a-z)


## rv32_isa_tests += isa/rv32ui/mergeSort.S         
rv32_isa_tests += isa/rv32ui/sha256.S
