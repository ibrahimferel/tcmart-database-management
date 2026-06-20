CREATE OR REPLACE FUNCTION fn_laporan_penjualan(
    p_start DATE,
    p_end DATE
)
RETURNS TABLE (
    total_transaksi BIGINT,
    total_pendapatan DECIMAL,
    rata_rata_nilai_transaksi DECIMAL
)
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT
        COUNT(*)::BIGINT,
        COALESCE(SUM(t_total_harga), 0)::DECIMAL,
        COALESCE(ROUND(AVG(t_total_harga), 2), 0)::DECIMAL
    FROM transaksi
    WHERE t_tgl::date BETWEEN p_start AND p_end;
END;
$$;

