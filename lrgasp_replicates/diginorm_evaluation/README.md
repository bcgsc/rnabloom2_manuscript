## Synopsis

Evaluate gene representation of RNA-Bloom2 read sets.

## Requirements

* Trans-NanoSim v3.1.0 : https://github.com/bcgsc/NanoSim
* rnaseq_utils : https://github.com/bcgsc/rnaseq_utils

## Quantify expression

Configure file paths in bash script `transnanosim.sh` and run:

```
bash transnanosim.sh
```

Genes are represented by the reads if it has TPM > 0.
