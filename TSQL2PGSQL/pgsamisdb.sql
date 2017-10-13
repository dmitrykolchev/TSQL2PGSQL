create schema "identity_server";
create schema "metadata";
create schema "presentation";
create table "identity_server"."user_account" (
	"id" serial not null,
	"state" smallint not null,
	"client_id" int not null,
	"name" varchar(256) not null,
	"normalized_name" varchar(256) not null,
	"email" varchar(256) null,
	"normalized_email" varchar(256) null,
	"email_confirmed" bool not null,
	"password_hash" varchar(256) null,
	"security_stamp" varchar(256) null,
	"concurency_stamp" varchar(256) not null,
	"phone_number" varchar(256) null,
	"phone_number_confirmed" bool not null,
	"two_factor_enabled" bool not null,
	"lockout_end" timestamp null,
	"lockout_enabled" bool not null,
	"access_failed_count" int not null,
	"modified_date" timestamp not null,
	constraint "pk_user_account" primary key ("id"),
	constraint "ak_user_account_name" unique ("client_id", "name")
);

create table "identity_server"."user_access_right" (
	"user_id" int not null,
	"access_right_id" int not null,
	constraint "pk_user_access_right" primary key ("user_id", "access_right_id")
);

create table "identity_server"."role_access_right" (
	"role_id" int not null,
	"access_right_id" int not null,
	constraint "pk_role_access_right" primary key ("role_id", "access_right_id")
);

create table "identity_server"."role" (
	"id" serial not null,
	"state" smallint not null,
	"client_id" int not null,
	"code" varchar(128) not null,
	"cn" varchar(128) null,
	"name" varchar(256) not null,
	constraint "pk_role" primary key ("id"),
	constraint "ak_role_code" unique ("client_id", "code")
);

create table "identity_server"."provider" (
	"id" int not null,
	"state" smallint not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	"provider_type" varchar(512) not null,
	"parameters" text null,
	constraint "pk_provider" primary key ("id"),
	constraint "ak_provider_code" unique ("code")
);

create table "identity_server"."client" (
	"id" serial not null,
	"state" smallint not null,
	"provider_id" int not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	"grant_types" varchar(256) not null,
	"client_uri" varchar(512) null,
	"redirect_uri" varchar(512) null,
	"postlogout_uri" varchar(512) null,
	"secret" varchar(256) null,
	"require_consent" bool not null,
	"allowed_scopes" varchar(512) null,
	"user_id" int null,
	"logo" text null,
	"comments" text null,
	constraint "pk_client" primary key ("id")
);

create table "identity_server"."api_resource_claim" (
	"api_resource_code" varchar(128) not null,
	"claim" varchar(128) not null,
	"value" text not null,
	constraint "pk_api_resource_claim" primary key ("api_resource_code", "claim")
);

create table "identity_server"."api_resource" (
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	constraint "pk_api_resource" primary key ("code")
);

create table "identity_server"."access_right" (
	"id" serial not null,
	"state" smallint not null,
	"client_id" int not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	constraint "pk_access_right" primary key ("id"),
	constraint "ak_access_right_code" unique ("client_id", "code")
);

create table "identity_server"."user_role" (
	"user_id" int not null,
	"role_id" int not null,
	constraint "pk_user_role" primary key ("user_id", "role_id")
);

create table "identity_server"."user_profile" (
	"user_id" int not null,
	"claim" varchar(128) not null,
	"value" text not null,
	constraint "pk_user_profile" primary key ("user_id", "claim")
);

create table "metadata"."data_operation_type" (
	"id" int not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	constraint "pk_data_operation_type" primary key ("id")
);

create table "metadata"."change_type" (
	"id" varchar(1) not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	constraint "pk_change_type" primary key ("id")
);

create table "metadata"."request_type_global" (
	"request_type_id" int not null,
	"lang" varchar(2) not null,
	"name" varchar(256) null,
	constraint "pk_request_type_global" primary key ("request_type_id", "lang")
);

create table "metadata"."document_type_global" (
	"document_type_id" int not null,
	"lang" varchar(2) not null,
	"name" varchar(256) null,
	"title" varchar(512) null,
	constraint "pk_document_type_global" primary key ("document_type_id", "lang")
);

create table "metadata"."document_state_global" (
	"document_state_id" int not null,
	"lang" varchar(2) not null,
	"name" varchar(256) null,
	"comments" text null,
	constraint "pk_document_state_global" primary key ("document_state_id", "lang")
);

create table "metadata"."document_state" (
	"id" serial not null,
	"document_type_id" int not null,
	"value" smallint not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_document_state" primary key ("id"),
	constraint "ak_document_state_value" unique ("document_type_id", "value")
);

create table "metadata"."request_type" (
	"id" serial not null,
	"state" smallint not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	"data_operation_type_id" int not null,
	"ordinal" int not null,
	"visible" bool not null,
	"document_type_id" int not null,
	"controller" varchar(128) not null,
	"action" varchar(128) not null,
	"parameters" varchar(128) null,
	"access_right_code" varchar(128) not null,
	"edit_request_type_code" varchar(128) null,
	"view_request_type_code" varchar(128) null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_request_type" primary key ("id"),
	constraint "ak_request_type_action" unique ("controller", "action"),
	constraint "ak_request_type_code" unique ("code")
);

create table "metadata"."document_type" (
	"id" serial not null,
	"state" smallint not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	"title" varchar(512) null,
	"schema_name" varchar(64) null,
	"table_name" varchar(64) null,
	"entity_type" varchar(1024) null,
	"history_type" varchar(1024) null,
	"data_adapter" varchar(1024) null,
	"image_name" varchar(128) not null,
	"supports_history" bool not null,
	"supports_hierarchy" bool not null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_document_type" primary key ("id")
);

create table "presentation"."view_type" (
	"id" int not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	constraint "pk_view_type" primary key ("id"),
	constraint "ak_view_type_code" unique ("code")
);

create table "presentation"."node_type" (
	"id" int not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	constraint "pk_node_type" primary key ("id")
);

create table "presentation"."node_global" (
	"node_id" int not null,
	"lang" varchar(2) not null,
	"name" varchar(256) null,
	"title" varchar(256) null,
	constraint "pk_node_global" primary key ("node_id", "lang")
);

create table "presentation"."node" (
	"id" serial not null,
	"state" smallint not null,
	"code" varchar(128) not null,
	"parent_code" varchar(128) null,
	"name" varchar(256) not null,
	"title" varchar(256) null,
	"node_type_id" int not null,
	"ordinal" int not null,
	"parameters" text null,
	"image" text null,
	"image_name" varchar(128) null,
	"request_type_code" varchar(128) null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_node" primary key ("id"),
	constraint "ak_node_code" unique ("code")
);

create table "presentation"."command_global" (
	"command_id" int not null,
	"lang" varchar(2) not null,
	"name" varchar(256) null,
	"title" varchar(256) null,
	constraint "pk_command_global" primary key ("command_id", "lang")
);

create table "presentation"."command" (
	"id" serial not null,
	"state" smallint not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	"title" varchar(256) null,
	"image_name" varchar(128) not null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_command" primary key ("id"),
	constraint "ak_command_code" unique ("code")
);

alter table "identity_server"."user_account"
	add constraint "fk_user_account_client" foreign key ("client_id") references "identity_server"."client" ("id");

alter table "identity_server"."user_access_right"
	add constraint "fk_user_access_right_user_account" foreign key ("user_id") references "identity_server"."user_account" ("id");

alter table "identity_server"."user_access_right"
	add constraint "fk_user_access_right_access_right" foreign key ("access_right_id") references "identity_server"."access_right" ("id");

alter table "identity_server"."role_access_right"
	add constraint "fk_role_access_right_role" foreign key ("role_id") references "identity_server"."role" ("id");

alter table "identity_server"."role_access_right"
	add constraint "fk_role_access_right_access_right" foreign key ("access_right_id") references "identity_server"."access_right" ("id");

alter table "identity_server"."role"
	add constraint "fk_role_client" foreign key ("client_id") references "identity_server"."client" ("id");

alter table "identity_server"."client"
	add constraint "fk_client_provider" foreign key ("provider_id") references "identity_server"."provider" ("id");

alter table "identity_server"."api_resource_claim"
	add constraint "fk_api_resource_claim_api_resource" foreign key ("api_resource_code") references "identity_server"."api_resource" ("code");

alter table "identity_server"."access_right"
	add constraint "fk_access_right_client" foreign key ("client_id") references "identity_server"."client" ("id");

alter table "identity_server"."user_role"
	add constraint "fk_user_role_user_account" foreign key ("user_id") references "identity_server"."user_account" ("id");

alter table "identity_server"."user_role"
	add constraint "fk_user_role_role" foreign key ("role_id") references "identity_server"."role" ("id");

alter table "identity_server"."user_profile"
	add constraint "fk_user_profile_user_account" foreign key ("user_id") references "identity_server"."user_account" ("id");

alter table "metadata"."request_type_global"
	add constraint "fk_request_type_global_request_type" foreign key ("request_type_id") references "metadata"."request_type" ("id");

alter table "metadata"."document_type_global"
	add constraint "fk_document_type_global_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "metadata"."document_state_global"
	add constraint "fk_document_state_global_document_state" foreign key ("document_state_id") references "metadata"."document_state" ("id");

alter table "metadata"."document_state"
	add constraint "fk_document_state_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "metadata"."request_type"
	add constraint "fk_request_type_data_operation_type" foreign key ("data_operation_type_id") references "metadata"."data_operation_type" ("id");

alter table "metadata"."request_type"
	add constraint "fk_request_type_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "presentation"."node_global"
	add constraint "fk_node_global_node" foreign key ("node_id") references "presentation"."node" ("id");

alter table "presentation"."node"
	add constraint "fk_node_node_type" foreign key ("node_type_id") references "presentation"."node_type" ("id");

alter table "presentation"."node"
	add constraint "fk_node_request_type" foreign key ("request_type_code") references "metadata"."request_type" ("code");

alter table "presentation"."command_global"
	add constraint "fk_command_global_command" foreign key ("command_id") references "presentation"."command" ("id");

