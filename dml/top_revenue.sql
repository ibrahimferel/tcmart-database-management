SELECT
    kp.kp_nama                              AS kategori,
    COUNT(DISTINCT dt.transaksi_t_id)       AS jumlah_transaksi,
    SUM(dt.dt_subtotal)                     AS total_pendapatan
FROM   detail_transaksi dt
JOIN   produk          p  ON p.p_id   = dt.produk_p_id
JOIN   kategori_produk kp ON kp.kp_id = p.kategori_produk_kp_id
GROUP  BY kp.kp_nama
ORDER  BY total_pendapatan DESC;