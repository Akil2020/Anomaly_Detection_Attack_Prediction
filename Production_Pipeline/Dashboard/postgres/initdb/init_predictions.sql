-- Auto-init: create staging, load CSV (server-side COPY), create final table, transform
CREATE TABLE IF NOT EXISTS public.predictions_staging (
  "Date" TEXT,
  "Time" TEXT,
  "Source" TEXT,
  "Source_port" TEXT,
  "Destination" TEXT,
  "Dest_Port" TEXT,
  "Protocol" TEXT,
  "Service" TEXT,
  "Policy_ID" TEXT,
  "State" TEXT,
  "Action" TEXT,
  "Duration" TEXT,
  "Bytes" TEXT,
  "Packets" TEXT,
  "pred_attack" TEXT,
  "anomaly_score" TEXT
);

COPY public.predictions_staging FROM '/data/predictions.csv' WITH (FORMAT csv, HEADER true);

CREATE TABLE IF NOT EXISTS public.predictions (
  id SERIAL PRIMARY KEY,
  ts TIMESTAMP WITH TIME ZONE,
  "Source" TEXT,
  "Source_port" BIGINT,
  "Destination" TEXT,
  "Dest_Port" BIGINT,
  "Protocol" TEXT,
  "Service" TEXT,
  "Policy_ID" TEXT,
  "State" TEXT,
  "Action" TEXT,
  "Duration" TEXT,
  "Bytes" BIGINT,
  "Packets" BIGINT,
  "pred_attack" TEXT,
  "anomaly_score" DOUBLE PRECISION
);

INSERT INTO public.predictions ("ts", "Source", "Source_port", "Destination", "Dest_Port", "Protocol", "Service", "Policy_ID", "State", "Action", "Duration", "Bytes", "Packets", "pred_attack", "anomaly_score")
SELECT
  -- safe ts parser: check formats using regex before calling to_timestamp
  CASE
    WHEN NULLIF("Date",'') IS NOT NULL AND NULLIF("Time",'') IS NOT NULL AND "Date" ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
      THEN to_timestamp( NULLIF("Date",'') || ' ' || NULLIF("Time",''), 'YYYY-MM-DD HH24:MI:SS' )
    WHEN NULLIF("Date",'') IS NOT NULL AND NULLIF("Time",'') IS NOT NULL AND "Date" ~ '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
      THEN to_timestamp( NULLIF("Date",'') || ' ' || NULLIF("Time",''), 'DD-MM-YYYY HH24:MI:SS' )
    WHEN NULLIF("Date",'') IS NOT NULL AND NULLIF("Time",'') IS NOT NULL AND "Date" ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
      THEN to_timestamp( substr(NULLIF("Date",''),7,4) || '-' || substr(NULLIF("Date",''),4,2) || '-' || substr(NULLIF("Date",''),1,2) || ' ' || NULLIF("Time",''), 'YYYY-MM-DD HH24:MI:SS' )
    -- fallback: single timestamp-like column named Timestamp/TS/received_at (ISO-like)
    WHEN NULLIF("Timestamp",'') IS NOT NULL THEN
      CASE WHEN NULLIF("Timestamp",'') ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2} '
           THEN to_timestamp(NULLIF("Timestamp",''),'YYYY-MM-DD HH24:MI:SS')
           ELSE NULL END
    WHEN NULLIF("TS",'') IS NOT NULL THEN
      CASE WHEN NULLIF("TS",'') ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2} '
           THEN to_timestamp(NULLIF("TS",''),'YYYY-MM-DD HH24:MI:SS')
           ELSE NULL END
    ELSE NULL
  END AS ts,

  NULLIF("Source",'') AS "Source",
  NULLIF("Source_port",'')::bigint AS "Source_port",
  NULLIF("Destination",'') AS "Destination",
  NULLIF("Dest_Port",'')::bigint AS "Dest_Port",
  NULLIF("Protocol",'') AS "Protocol",
  NULLIF("Service",'') AS "Service",
  NULLIF("Policy_ID",'') AS "Policy_ID",
  NULLIF("State",'') AS "State",
  NULLIF("Action",'') AS "Action",
  NULLIF("Duration",'')::double precision AS "Duration",
  NULLIF("Bytes",'')::bigint AS "Bytes",
  NULLIF("Packets",'')::bigint AS "Packets",
  NULLIF("pred_attack",'') AS "pred_attack",
  NULLIF("anomaly_score",'')::double precision AS "anomaly_score"
FROM public.predictions_staging;
-- ---------- end transform ----------
