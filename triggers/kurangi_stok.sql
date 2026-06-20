CREATE OR REPLACE FUNCTION trg_kurangi_stok()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
    v_stok_id INT;
BEGIN
    SELECT stok_s_id INTO v_stok_id
    FROM produk
    WHERE p_id = NEW.produk_p_id;

    UPDATE stok
    SET s_jumlah = s_jumlah - NEW.dt_jumlah,
        s_tgl_update = NOW()
    WHERE s_id = v_stok_id;

    RETURN NULL;
END;
$$;

CREATE TRIGGER trg_kurangi_stok
AFTER INSERT ON detail_transaksi
FOR EACH ROW
EXECUTE FUNCTION trg_kurangi_stok();

