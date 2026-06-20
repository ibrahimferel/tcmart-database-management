CREATE TABLE log_peringatan_stok (
    lps_id SERIAL PRIMARY KEY,
    lps_produk_id INT NOT NULL REFERENCES produk(p_id),
    lps_nama_produk VARCHAR(100),
    lps_stok_sisa INT,
    lps_stok_minimum INT,
    lps_tgl TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION trg_peringatan_stok_menipis()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
    v_produk_id INT;
    v_nama VARCHAR(100);
BEGIN
    IF NEW.s_jumlah < NEW.s_minimum THEN
        SELECT p.p_id, p.p_nama INTO v_produk_id, v_nama
        FROM produk p
        WHERE p.stok_s_id = NEW.s_id;

        INSERT INTO log_peringatan_stok (lps_produk_id, lps_nama_produk, lps_stok_sisa, lps_stok_minimum)
        VALUES (v_produk_id, v_nama, NEW.s_jumlah, NEW.s_minimum);

        RAISE NOTICE 'PERINGATAN: Stok % (ID: %) menipis! Sisa: %, Minimum: %',
            v_nama, v_produk_id, NEW.s_jumlah, NEW.s_minimum;
    END IF;

    RETURN NULL;
END;
$$;

CREATE TRIGGER trg_peringatan_stok_menipis
AFTER UPDATE ON stok
FOR EACH ROW
EXECUTE FUNCTION trg_peringatan_stok_menipis();

