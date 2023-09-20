# Ankara_HSGM

## Introduction

Cecret was originally developed by [@erinyoung](https://github.com/erinyoung) at the [Utah Public Health Laborotory](https://uphl.utah.gov/) for SARS-COV-2 sequencing with the [artic](https://artic.network/ncov-2019/ncov2019-bioinformatics-sop.html)/Illumina hybrid library prep workflow for MiSeq data with protocols [here](https://www.protocols.io/view/sars-cov-2-sequencing-on-illumina-miseq-using-arti-bffyjjpw) and [here](https://www.protocols.io/view/sars-cov-2-sequencing-on-illumina-miseq-using-arti-bfefjjbn). This nextflow workflow, however, is flexible for many additional organisms and primer schemes as long as the reference genome is "_small_" and "_good enough_." In 2022, [@tives82](https://github.com/tives82) added in contributions for Monkeypox virus, including converting IDT's primer scheme to NC_063383.1 coordinates. We are grateful to everyone that has contributed to this repo.

The nextflow workflow was built to work on linux-based operating systems. Additional config options are needed for cloud batch usage.

The library preparation method greatly impacts which bioinformatic tools are recommended for creating a consensus sequence. For example, amplicon-based library prepation methods will required primer trimming and an elevated minimum depth for base-calling. Some bait-derived library prepation methods have a PCR amplification step, and PCR duplicates will need to be removed. This has added complexity and several (admittedly confusing) options to this workflow. Please submit an [issue](https://github.com/UPHL-BioNGS/Cecret/issues) if/when you run into issues.

It is possible to use this workflow to simply annotate fastas generated from any workflow or downloaded from [GISAID](https://www.gisaid.org/) or [NCBI](https://www.ncbi.nlm.nih.gov/sars-cov-2/). There are also options for multiple sequence alignment (MSA) and phylogenetic tree creation from the fasta files.

Cecret is also part of the [staphb-toolkit](https://github.com/StaPH-B/staphb_toolkit).

## Dependencies

- [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html)
- [Singularity](https://singularity.lbl.gov/install-linux) or [Docker](https://docs.docker.com/get-docker/) - set the profile as singularity or docker during runtime

## Usage

This workflkow does not run without input files, and there are multiple ways to specify which input files should be used
- using files in [directories](https://github.com/UPHL-BioNGS/Cecret#getting-files-from-directories)
- using files specified in a [sample sheet](https://github.com/UPHL-BioNGS/Cecret#using-a-sample-sheet)
- using params, directories and files specified in a [config file](https://github.com/UPHL-BioNGS/Cecret#using-config-files)

```
# using singularity on paired-end reads in a directory called 'reads'
nextflow run UPHL-BioNGS/Cecret -profile singularity --reads <directory to reads>

# using docker on samples specified in SampleSheet.csv
nextflow run UPHL-BioNGS/Cecret -profile docker --sample_sheet SampleSheet.csv

# using a config file containing all inputs
nextflow run UPHL-BioNGS/Cecret -c file.config
```

Results are roughly organiized into 'params.outdir'/< analysis >/sample.result

A file summarizing all results is found in `'params.outdir'/cecret_results.csv` and `'params.outdir'/cecret_results.txt`.

Consensus sequences can be found in `'params.outdir'/consensus` and end with `*.consensus.fa`.
