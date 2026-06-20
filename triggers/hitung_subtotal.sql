CREATE OR REPLACE FUNCTION trg_hitung_subtotal()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
    v_harga DECIMAL(10,2);
BEGIN
    SELECT p_harga_jual INTO v_harga
    FROM produk
    WHERE p_id = NEW.produk_p_id;

    IF v_harga IS NULL THEN
        RAISE EXCEPTION 'Produk dengan ID % tidak ditemukan', NEW.produk_p_id;
    END IF;

    NEW.dt_harga_satuan := v_harga;
    NEW.dt_subtotal := NEW.dt_jumlah * v_harga;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_hitung_subtotal
BEFORE INSERT ON detail_transaksi
FOR EACH ROW
EXECUTE FUNCTION trg_hitung_subtotal();

