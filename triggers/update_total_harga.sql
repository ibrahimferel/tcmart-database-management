CREATE OR REPLACE FUNCTION trg_update_total_harga()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE transaksi
    SET t_total_harga = (
        SELECT COALESCE(SUM(dt_subtotal), 0)
        FROM detail_transaksi
        WHERE transaksi_t_id = NEW.transaksi_t_id
    )
    WHERE t_id = NEW.transaksi_t_id;

    RETURN NULL;
END;
$$;

CREATE TRIGGER trg_update_total_harga
AFTER INSERT ON detail_transaksi
FOR EACH ROW
EXECUTE FUNCTION trg_update_total_harga();

