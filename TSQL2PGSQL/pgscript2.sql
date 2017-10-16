alter table "biz"."position_request" drop constraint "fk_position_request_request";
alter table "person"."person_relation_request" drop constraint "fk_person_relation_request_request";
alter table "core"."hierarchy_request" drop constraint "fk_hierarchy_request_request";
alter table "stock"."issue_request" drop constraint "fk_issue_request_request";
alter table "biz"."board_request" drop constraint "fk_board_request_request";
alter table "req"."request" drop constraint "fk_request_document";
alter table "req"."request" drop constraint "fk_request_data_operation_type";
alter table "req"."request" drop constraint "fk_request_request_type";
alter table "req"."request" drop constraint "fk_request_document_history";
alter table "biz"."company_request" drop constraint "fk_company_request_request";
alter table "req"."request_transition" drop constraint "fk_request_transition_request";
alter table "biz"."subdivision_request" drop constraint "fk_subdivision_request_request";
alter table "stock"."deal_request" drop constraint "fk_deal_request_request";
alter table "person"."person_request" drop constraint "fk_person_request_request";
alter table "biz"."board_request_member" drop constraint "fk_board_request_member_position";

create table "req"."tmp_ms_xx_request" (
	"id" int not null default nextval('req.request_id_seq'::regclass),
	"state" smallint not null,
	"name" varchar(256) null,
	"request_type_id" int not null,
	"author_id" int not null,
	"data_operation_type_id" int not null,
	"document_type_id" int null,
	"document_id" int null,
	"document_hid" int null,
	"copy_document_type_id" int null,
	"copy_document_id" int null,
	"copy_document_hid" int null,
	"document_name" varchar(256) null,
	"request_data_id" int null,
	"relevance_date" date null,
	"process_id" int null,
	"comments_history" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "tmp_ms_xx_constraint_pk_request1" primary key ("id")
);

insert into "req"."tmp_ms_xx_request"
	("id", "state", "name", "request_type_id", "author_id", "data_operation_type_id", "document_type_id", "document_id", "document_hid", "document_name", "request_data_id", "relevance_date", "process_id", "comments_history", "modified_by", "modified_date")
select "id", "state", "name", "request_type_id", "author_id", "data_operation_type_id", "document_type_id", "document_id", "document_hid", "document_name", "request_data_id", "relevance_date", "process_id", "comments_history", "modified_by", "modified_date" from "req"."request"

drop table "req"."request";

alter table "req"."tmp_ms_xx_request" rename to request;

alter table "req"."request" rename constraint "req"."tmp_ms_xx_constraint_pk_request1" to pk_request;

alter table "biz"."position_request"
	add constraint "fk_position_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "person"."person_relation_request"
	add constraint "fk_person_relation_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "core"."hierarchy_request"
	add constraint "fk_hierarchy_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "stock"."issue_request"
	add constraint "fk_issue_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "biz"."board_request"
	add constraint "fk_board_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "req"."request"
	add constraint "fk_request_document" foreign key ("document_type_id", "document_id") references "core"."document" ("document_type_id", "id");

alter table "req"."request"
	add constraint "fk_request_data_operation_type" foreign key ("data_operation_type_id") references "metadata"."data_operation_type" ("id");

alter table "req"."request"
	add constraint "fk_request_request_type" foreign key ("request_type_id") references "metadata"."request_type" ("id");

alter table "req"."request"
	add constraint "fk_request_document_history" foreign key ("document_type_id", "document_hid") references "core"."document_history" ("document_type_id", "hid");

alter table "biz"."company_request"
	add constraint "fk_company_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "req"."request_transition"
	add constraint "fk_request_transition_request" foreign key ("request_id") references "req"."request" ("id");

alter table "biz"."subdivision_request"
	add constraint "fk_subdivision_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "stock"."deal_request"
	add constraint "fk_deal_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "person"."person_request"
	add constraint "fk_person_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "biz"."board_request_member"
	add constraint "fk_board_request_member_position" foreign key ("position_id") references "biz"."position" ("id");

