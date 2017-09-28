alter table "core"."hierarchy" drop constraint "fk_hierarchy_access_right";

alter table "core"."hierarchy_document" drop constraint "fk_hierarchy_document_hierarchy";

create table "core"."tmp_ms_xx_hierarchy" (
        "id" serial not null,
        "state" smallint not null,
        "path" varchar(512) not null,
        "name" varchar(256) not null,
        "access_right_code" varchar(128) null,
        "modified_by" int not null,
        "modified_date" timestamp not null,
        constraint "tmp_ms_xx_constraint_pk_hierarchy1" primary key ("id"),
        constraint "tmp_ms_xx_constraint_ak_hierarchy_path1" unique ("path")
);

if exists (select 1 from "core"."hierarchy") then
--begin

-- set identity_insert "core"."tmp_ms_xx_hierarchy" on
insert into "core"."tmp_ms_xx_hierarchy"
        ("id", "state", "path", "name", "modified_by", "modified_date")
select "id", "state", "path", "name", "modified_by", "modified_date" from "core"."hierarchy"
-- set identity_insert "core"."tmp_ms_xx_hierarchy" off

--end
end if;

drop table "core"."hierarchy";

alter table "core"."tmp_ms_xx_hierarchy" rename to "hierarchy";

alter table "core"."hierarchy" rename constraint "tmp_ms_xx_constraint_pk_hierarchy1" to pk_hierarchy;

alter table "core"."hierarchy" rename constraint "tmp_ms_xx_constraint_ak_hierarchy_path1" to ak_hierarchy_path;

create table "core"."hierarchy_request" (
        "id" serial not null,
        "hierarchy_id" int null,
        "request_id" int not null,
        "change_type_id" varchar(1) not null,
        "state" smallint not null,
        "name" varchar(256) not null,
        "access_right_code" varchar(128) null,
        "parent_hierarchy_id" int null,
        "modified_by" int not null,
        "modified_date" timestamp not null,
        constraint "pk_hierarchy_request" primary key ("id")
);

create table "core"."hierarchy_request_document" (
        "hierarchy_request_id" int not null,
        "document_id" int not null,
        "document_type_id" int not null,
        "modified_by" int not null,
        "modified_date" timestamp not null,
        constraint "pk_hierarchy_request_document" primary key ("hierarchy_request_id", "document_id", "document_type_id")
);

alter table "core"."hierarchy"
        add constraint "fk_hierarchy_access_right" foreign key ("access_right_code") references "sec"."access_right" ("code");

alter table "core"."hierarchy_document"
        add constraint "fk_hierarchy_document_hierarchy" foreign key ("hierarchy_id") references "core"."hierarchy" ("id");

alter table "core"."hierarchy_request"
        add constraint "fk_hierarchy_request_hierarchy" foreign key ("hierarchy_id") references "core"."hierarchy" ("id");

alter table "core"."hierarchy_request"
        add constraint "fk_hierarchy_request_parent_hierarchy" foreign key ("parent_hierarchy_id") references "core"."hierarchy" ("id");

alter table "core"."hierarchy_request"
        add constraint "fk_hierarchy_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "core"."hierarchy_request"
        add constraint "fk_hierarchy_request_access_right" foreign key ("access_right_code") references "sec"."access_right" ("code");

alter table "core"."hierarchy_request_document"
        add constraint "fk_hierarchy_request_document_hierarchy_request" foreign key ("hierarchy_request_id") references "core"."hierarchy_request" ("id");

alter table "core"."hierarchy_request_document"
        add constraint "fk_hierarchy_request_document_document" foreign key ("document_type_id", "document_id") references "core"."document" ("document_type_id", "id");

alter table "core"."hierarchy_request_document"
        add constraint "fk_hierarchy_request_document_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");