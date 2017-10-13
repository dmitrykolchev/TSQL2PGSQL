create schema "identity_server";
create table "identity_server"."user_access_right" (
	"user_id" int not null,
	"access_right_id" int not null,
	constraint "pk_user_access_right" primary key ("user_id", "access_right_id")
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

create table "identity_server"."role_access_right" (
	"role_id" int not null,
	"access_right_id" int not null,
	constraint "pk_role_access_right" primary key ("role_id", "access_right_id")
);

create table "identity_server"."access_right" (
	"id" serial not null,
	"state" smallint not null,
	"client_id" int not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	constraint "pk_access_right" primary key ("id"),
	constraint "ak_access_right_code" unique ("code")
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

alter table "identity_server"."user_access_right"
	add constraint "fk_user_access_right_user_account" foreign key ("user_id") references "identity_server"."user_account" ("id");

alter table "identity_server"."user_access_right"
	add constraint "fk_user_access_right_access_right" foreign key ("access_right_id") references "identity_server"."access_right" ("id");

alter table "identity_server"."api_resource_claim"
	add constraint "fk_api_resource_claim_api_resource" foreign key ("api_resource_code") references "identity_server"."api_resource" ("code");

alter table "identity_server"."role_access_right"
	add constraint "fk_role_access_right_role" foreign key ("role_id") references "identity_server"."role" ("id");

alter table "identity_server"."role_access_right"
	add constraint "fk_role_access_right_access_right" foreign key ("access_right_id") references "identity_server"."access_right" ("id");

alter table "identity_server"."access_right"
	add constraint "fk_access_right_client" foreign key ("client_id") references "identity_server"."client" ("id");

alter table "identity_server"."user_role"
	add constraint "fk_user_role_user_account" foreign key ("user_id") references "identity_server"."user_account" ("id");

alter table "identity_server"."user_role"
	add constraint "fk_user_role_role" foreign key ("role_id") references "identity_server"."role" ("id");

alter table "identity_server"."user_profile"
	add constraint "fk_user_profile_user_account" foreign key ("user_id") references "identity_server"."user_account" ("id");

alter table "identity_server"."role"
	add constraint "fk_role_client" foreign key ("client_id") references "identity_server"."client" ("id");

alter table "identity_server"."user_account"
	add constraint "fk_user_account_client" foreign key ("client_id") references "identity_server"."client" ("id");

alter table "identity_server"."client"
	add constraint "fk_client_provider" foreign key ("provider_id") references "identity_server"."provider" ("id");

