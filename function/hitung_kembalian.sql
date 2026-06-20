CREATE OR REPLACE FUNCTION fn_hitung_kembalian(
    p_transaksi_id INT,
    p_total_bayar DECIMAL
)
RETURNS TABLE (
    transaksi_id INT,
    total_harga DECIMAL,
    total_bayar DECIMAL,
    kembalian DECIMAL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_total_harga DECIMAL(10,2);
BEGIN
    SELECT t_total_harga INTO v_total_harga
    FROM transaksi
    WHERE t_id = p_transaksi_id;

    IF v_total_harga IS NULL THEN
        RAISE EXCEPTION 'Transaksi dengan ID % tidak ditemukan', p_transaksi_id;
    END IF;

    IF p_total_bayar < v_total_harga THEN
        RAISE EXCEPTION 'Pembayaran (%) kurang dari total harga (%)', p_total_bayar, v_total_harga;
    END IF;

    UPDATE transaksi
    SET t_total_bayar = p_total_bayar,
        t_kembalian = p_total_bayar - v_total_harga
    WHERE t_id = p_transaksi_id;

    RETURN QUERY
    SELECT t_id, t_total_harga, t_total_bayar, t_kembalian
    FROM transaksi
    WHERE t_id = p_transaksi_id;
END;
$$;

