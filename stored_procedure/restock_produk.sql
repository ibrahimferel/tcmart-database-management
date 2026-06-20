CREATE OR REPLACE PROCEDURE sp_batalkan_transaksi(
    p_transaksi_id INT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_tgl TIMESTAMP;
    rec RECORD;
BEGIN
    SELECT t_tgl INTO v_tgl
    FROM transaksi
    WHERE t_id = p_transaksi_id;

    IF v_tgl IS NULL THEN
        RAISE EXCEPTION 'Transaksi dengan ID % tidak ditemukan', p_transaksi_id;
    END IF;

    IF v_tgl::date <> CURRENT_DATE THEN
        RAISE EXCEPTION 'Transaksi hanya bisa dibatalkan di hari yang sama (H+0). Transaksi dilakukan tanggal %', v_tgl::date;
    END IF;

    FOR rec IN
        SELECT dt.produk_p_id, dt.dt_jumlah, p.stok_s_id
        FROM detail_transaksi dt
        JOIN produk p ON p.p_id = dt.produk_p_id
        WHERE dt.transaksi_t_id = p_transaksi_id
    LOOP
        UPDATE stok
        SET s_jumlah = s_jumlah + rec.dt_jumlah,
            s_tgl_update = NOW()
        WHERE s_id = rec.stok_s_id;
    END LOOP;

    DELETE FROM detail_transaksi
    WHERE transaksi_t_id = p_transaksi_id;

    DELETE FROM transaksi
    WHERE t_id = p_transaksi_id;
END;
$$;

