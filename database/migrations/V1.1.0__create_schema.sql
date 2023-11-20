create table if not exists demo.grades
(
	id bigint,
	last_modified timestamp,
	batch_uuid text,
	grade bigint
);

alter table demo.grades owner to postgres;

create unique index if not exists grade_id_uindex
	on demo.grades (id);