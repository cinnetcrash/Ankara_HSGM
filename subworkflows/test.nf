include { download } from '../modules/cecret' addParams(params)

workflow test {
    take:
        ch_sra_accessions

    main:
        download(ch_sra_accessions)

    emit:
        reads = download.out.paired.mix(download.out.single)
}
