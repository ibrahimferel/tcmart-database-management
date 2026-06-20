CREATE OR REPLACE FUNCTION trg_cegah_stok_negatif()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.s_jumlah < 0 THEN
        RAISE EXCEPTION 'Stok tidak boleh negatif. Stok saat ini: %, percobaan pengurangan menghasilkan: %',
            OLD.s_jumlah, NEW.s_jumlah;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_cegah_stok_negatif
BEFORE UPDATE ON stok
FOR EACH ROW
EXECUTE FUNCTION trg_cegah_stok_negatif();
