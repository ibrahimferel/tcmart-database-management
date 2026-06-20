CREATE OR REPLACE FUNCTION trg_validasi_kasir_aktif()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
    v_status VARCHAR(10);
BEGIN
    SELECT k_status INTO v_status
    FROM karyawan
    WHERE k_id = NEW.karyawan_k_id;

    IF v_status IS NULL THEN
        RAISE EXCEPTION 'Karyawan dengan ID % tidak ditemukan', NEW.karyawan_k_id;
    END IF;

    IF v_status = 'resign' THEN
        RAISE EXCEPTION 'Karyawan dengan ID % sudah resign dan tidak dapat melayani transaksi', NEW.karyawan_k_id;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validasi_kasir_aktif
BEFORE INSERT ON transaksi
FOR EACH ROW
EXECUTE FUNCTION trg_validasi_kasir_aktif();