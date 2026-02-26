create table if not exists dw.etl_runs (
  run_id bigserial primary key,
  started_at timestamp not null default now(),
  finished_at timestamp,
  status text not null default 'RUNNING',
  message text,
  batch_id text
);

create table if not exists dw.ingested_files (
  file_id bigserial primary key,
  source_name text not null,
  file_name text not null,
  file_hash text not null,
  ingested_at timestamp not null default now(),
  row_count bigint,
  status text not null default 'OK',
  message text
);

create unique index if not exists ux_ingested_files
on dw.ingested_files(source_name, file_hash);

