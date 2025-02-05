#/bin/bash
# nextflow run ~/sandbox/Cecret -profile singularity --reads /home/eriny/sandbox/test_files/cecret/reads --outdir tests -with-tower -resume
# nextflow run ~/sandbox/Cecret -profile singularity,mpx --reads /home/eriny/sandbox/test_files/cecret/mpx --outdir tests --cleaner 'fastp' -with-tower -resume
# nextflow run ~/sandbox/Cecret -profile singularity --nanopore /home/eriny/sandbox/test_files/cecret/nanopore --outdir tests -with-tower -resume

test=$1

if [ -z "$test" ]; then test="small" ; fi

if [ "$test" == "small" ]
then

  # sample sheet
  nextflow run ~/sandbox/Cecret \
    -profile singularity \
    --sample_sheet /home/eriny/sandbox/test_files/cecret/sample_sheet.csv \
    --outdir singularity_defaults_sample_sheet \
    -resume \
    -with-tower

  # using included nextclade data
  nextflow run ~/sandbox/Cecret \
    -profile singularity \
    --sample_sheet /home/eriny/sandbox/test_files/cecret/sample_sheet.csv \
    --outdir singularity_defaults_sample_sheet_included_nextclade \
    --download_nextclade_dataset false \
    -resume \
    -with-tower

  options=("reads" "single_reads" "fastas" "nanopore")

  for option in ${options[@]}
  do
    # defaults
    nextflow run ~/sandbox/Cecret \
      -profile singularity,artic_V3 \
      --$option /home/eriny/sandbox/test_files/cecret/$option \
      --outdir singularity_defaults_$option \
      -with-tower

    # removed test for bamsnap and rename because of lack of interest
    nextflow run ~/sandbox/Cecret \
      -profile singularity,artic_V3 \
      --$option /home/eriny/sandbox/test_files/cecret/$option \
      --outdir all_on_$option \
      -with-tower \
      --filter true \
      -resume

    # removing primer trimming
    nextflow run ~/sandbox/Cecret \
      -profile singularity,artic_V3 \
      --$option /home/eriny/sandbox/test_files/cecret/$option \
      --outdir nontrimmed_$option \
      --trimmer 'none' \
      -with-tower \
      -resume

    # changing the cleaner, aligner, and trimmer
    nextflow run ~/sandbox/Cecret \
      -profile singularity,artic_V3 \
      --$option /home/eriny/sandbox/test_files/cecret/$option \
      --outdir toggled_$option \
      --cleaner 'fastp' \
      --trimmer 'samtools' \
      --aligner 'minimap2' \
      --markdup true \
      -with-tower \
      -resume

    # with UPHL's config
    nextflow run ~/sandbox/Cecret \
      -profile uphl,artic_V3 \
      --$option /home/eriny/sandbox/test_files/cecret/$option \
      --outdir uphl_$option \
      -with-tower \
      -resume
  done

  # multifasta
  nextflow run ~/sandbox/Cecret \
    -profile singularity,artic_V3 \
    --reads /home/eriny/sandbox/test_files/cecret/reads \
    --single-reads /home/eriny/sandbox/test_files/cecret/single-reads \
    --fastas /home/eriny/sandbox/test_files/cecret/fastas \
    --multifastas /home/eriny/sandbox/test_files/cecret/multifasta \
    --outdir kitchen_sink  \
    -with-tower

  # empty
  nextflow run ~/sandbox/Cecret \
    -profile singularity,artic_V3 \
    --reads doesntexit \
    --single-reads willnotexist \
    --fastas shouldntexit \
    --outdir empty  \
    -with-tower

else
  # CDC's test data with relatedness
  nextflow run ~/sandbox/Cecret \
    -profile singularity,artic_V3 \
    --reads /home/eriny/sandbox/sars-cov-2-datasets/reads \
    --outdir default_datasets \
    --relatedness true  \
    -with-tower

  nextflow run ~/sandbox/Cecret \
    -profile uphl,artic_V3 \
    --reads /home/eriny/sandbox/sars-cov-2-datasets/reads \
    --outdir uphl_datasets \
    -with-tower \
    -resume \
    --relatedness true

  # CDC's test data with relatedness using nextalign
  nextflow run ~/sandbox/Cecret \
    -profile singularity,artic_V3 \
    --reads /home/eriny/sandbox/sars-cov-2-datasets/reads \
    --outdir toggled_datasets \
    --cleaner 'fastp' \
    --trimmer 'samtools' \
    --aligner 'minimap2' \
    --markdup true \
    --relatedness true \
    --msa 'nextalign' \
    -with-tower \
    -resume

  # MPX
  nextflow run ~/sandbox/Cecret \
    -profile singularity,mpx \
    --reads /home/eriny/sandbox/test_files/cecret/mpx \
    --outdir mpx \
    --cleaner 'fastp' \
    --relatedness true \
    --msa 'nextalign' \
    -with-tower \
    -resume

  # MPX with idt primers
  nextflow run ~/sandbox/Cecret \
    -profile singularity,mpx_idt \
    --reads /home/eriny/sandbox/test_files/cecret/mpx_idt \
    --outdir mpx_idt \
    --cleaner 'fastp' \
    --relatedness true \
    --msa 'nextalign' \
    -with-tower \
    -resume

  # other
  nextflow run ~/sandbox/Cecret \
    -profile singularity \
    --reads /home/eriny/sandbox/test_files/cecret/mpx \
    --outdir mpx \
    --cleaner 'fastp' \
    --trimmer 'none' \
    --species 'other' \
    --nextclade_dataset  'hMPXV' \
    --vadr_options '--split --glsearch -s -r --nomisc --r_lowsimok --r_lowsimxd 100 --r_lowsimxl 2000 --alt_pass discontn,dupregin' \
    --vadr_reference 'mpxv' \
    --vadr_trim_options '--minlen 50 --maxlen 210000' \
    --kraken2_organism 'Monkeypox virus' \
    -with-tower \
    -resume

  # MPX with kraken
  nextflow run ~/sandbox/Cecret \
    -profile uphl,mpx \
    --reads /home/eriny/sandbox/test_files/cecret/mpx \
    --outdir uphl_mpx \
    --cleaner 'fastp' \
    --relatedness true \
    --msa 'nextalign' \
    -with-tower \
    -resume
fi
