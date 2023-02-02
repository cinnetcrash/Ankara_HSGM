include { download } from '../modules/download' addParams(params)

workflow test {
    take:
    ch_sra_accessions

    main:
    download(ch_sra_accessions)

    emit:
    reads = Channel.empty()
//    reads = download.out.reads
}
