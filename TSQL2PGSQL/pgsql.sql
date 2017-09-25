create schema "acc";
create schema "biz";
create schema "core";
create schema "dic";
create schema "fs";
create schema "metadata";
create schema "person";
create schema "presentation";
create schema "profile";
create schema "req";
create schema "sec";
create schema "stock";
create schema "wf";
create table "acc"."stock_investment" (
	"id" serial not null,
	"operation_id" int not null,
	"operation_part_id" int not null,
	"amount" decimal(26, 6) not null,
	"price" decimal(26, 6) not null,
	"currency_id" int not null,
	"shareholder_id" int not null,
	"issuer_id" int not null,
	"share_type_id" int not null,
	"modified_date" timestamp not null,
	"modified_by" int not null,
	constraint "pk_stock_investment" primary key ("id")
);

create table "acc"."authorized_capital" (
	"id" serial not null,
	"operation_id" int not null,
	"operation_part_id" int not null,
	"amount" decimal(26, 6) not null,
	"price" decimal(26, 6) not null,
	"currency_id" int not null,
	"issuer_id" int not null,
	"issue_id" int not null,
	"share_type_id" int not null,
	"modified_date" timestamp not null,
	"modified_by" int not null,
	constraint "pk_authorized_capital" primary key ("id")
);

create table "acc"."account" (
	"id" int not null,
	"code" varchar(32) not null,
	"name" varchar(256) not null,
	"schema_name" varchar(128) not null,
	"table_name" varchar(128) not null,
	"comments" text null,
	constraint "pk_account" primary key ("id"),
	constraint "ak_account_code" unique ("code")
);

create table "acc"."operation_part" (
	"id" int not null,
	"name" varchar(256) not null,
	constraint "pk_operation_part" primary key ("id")
);

create table "acc"."operation" (
	"id" serial not null,
	"document_type_id" int not null,
	"document_id" int not null,
	"operation_date" date not null,
	"name" varchar(1024) not null,
	"debit_account_code" varchar(32) not null,
	"credit_account_code" varchar(32) not null,
	"modified_date" timestamp not null,
	"modified_by" int not null,
	constraint "pk_operation" primary key ("id")
);

create table "acc"."treasury_stock" (
	"id" serial not null,
	"operation_id" int not null,
	"operation_part_id" int not null,
	"amount" decimal(26, 6) not null,
	"price" decimal(26, 6) not null,
	"currency_id" int not null,
	"issuer_id" int not null,
	"share_type_id" int not null,
	"modified_date" timestamp not null,
	"modified_by" int not null,
	constraint "pk_treasury_stock" primary key ("id")
);

create table "acc"."stock_transit" (
	"id" serial not null,
	"operation_id" int not null,
	"operation_part_id" int not null,
	"amount" decimal(26, 6) not null,
	"price" decimal(26, 6) not null,
	"currency_id" int not null,
	"shareholder_id" int not null,
	"issuer_id" int not null,
	"issue_id" int not null,
	"share_type_id" int not null,
	"modified_date" timestamp not null,
	"modified_by" int not null,
	constraint "pk_stock_transit" primary key ("id")
);

create table "biz"."company_history" (
	"hid" int not null,
	"company_id" int not null,
	"period_start" date not null,
	"period_end" date not null,
	"okopf_id" int null,
	"short_name" varchar(256) null,
	"full_name" varchar(1024) null,
	"short_name_intl" varchar(256) null,
	"full_name_intl" varchar(1024) null,
	"full_name_rus" varchar(1024) null,
	"business_phone1" varchar(32) null,
	"business_phone2" varchar(32) null,
	"other_phone1" varchar(32) null,
	"other_phone2" varchar(32) null,
	"email" varchar(128) null,
	"webpage" varchar(128) null,
	"legal_address_id" int null,
	"mail_address_id" int null,
	"actual_address_id" int null,
	"company_okved_id" int null,
	"okpo" varchar(32) null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_company_history" primary key ("hid"),
	constraint "ak_company_history_id" unique ("company_id", "hid")
);

create table "biz"."business_entity_history" (
	"hid" serial not null,
	"document_type_id" int not null,
	"business_entity_id" int not null,
	"period_start" date not null,
	"period_end" date not null,
	"legal_address_id" int null,
	"mail_address_id" int null,
	"actual_address_id" int null,
	"webpage" varchar(128) null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_business_entity_history" primary key ("hid")
);

create table "biz"."business_entity" (
	"id" serial not null,
	"document_type_id" int not null,
	"state" smallint not null,
	"name" varchar(256) not null,
	"ogrn" varchar(32) null,
	"inn" varchar(32) null,
	"kpp" varchar(32) null,
	"country_id" int not null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
);

create table "biz"."subdivision_type" (
	"id" int not null,
	"name" varchar(256) not null,
	"comments" text null,
	 primary key ("id")
);

create table "biz"."subdivision_history" (
	"hid" int not null,
	"subdivision_id" int not null,
	"period_start" date not null,
	"period_end" date not null,
	"business_phone1" varchar(32) null,
	"business_phone2" varchar(32) null,
	"other_phone1" varchar(32) null,
	"other_phone2" varchar(32) null,
	"email" varchar(128) null,
	"webpage" varchar(128) null,
	"legal_address_id" int null,
	"mail_address_id" int null,
	"actual_address_id" int null,
	"executive_person_id" int null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_subdivision_history" primary key ("hid"),
	constraint "ak_subdivision_history_id" unique ("subdivision_id", "hid")
);

create table "biz"."subdivision" (
	"id" int not null,
	"state" smallint not null,
	"name" varchar(256) not null,
	"subdivision_type_id" int not null,
	"registration_date" date null,
	"ogrn" varchar(32) null,
	"inn" varchar(32) null,
	"kpp" varchar(32) null,
	"parent_company_id" int not null,
	"country_id" int not null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
);

create table "biz"."address" (
	"id" serial not null,
	"country_id" int null,
	"fias_id" uuid null,
	"street" varchar(256) null,
	"city" varchar(256) null,
	"postal_code" varchar(256) null,
	"region" varchar(256) null,
	"house" varchar(256) null,
	"building" varchar(256) null,
	"national" varchar(1024) null,
	"international" varchar(1024) null,
	"comments" text null,
	 primary key ("id")
);

create table "biz"."business_entity_role" (
	"business_entity_id" int not null,
	"business_role_id" int not null,
	constraint "pk_business_entity_role" primary key ("business_entity_id", "business_role_id")
);

create table "biz"."board_request_member" (
	"id" serial not null,
	"board_request_id" int not null,
	"business_entity_id" int not null,
	"position_id" int null,
	"head_of_board" bool not null,
	"start_of_term" date not null,
	"end_of_term" date null,
	"comments" text null,
	 primary key ("id")
);

create table "biz"."board_request" (
	"id" serial not null,
	"board_id" int null,
	"board_hid" int null,
	"request_id" int not null,
	"change_type_id" varchar(1) not null,
	"relevance_date" timestamp not null,
	"state" smallint not null,
	"name" varchar(256) not null,
	"company_id" int not null,
	"board_type_id" int not null,
	"secretary_id" int null,
	"phone" varchar(32) null,
	"email" varchar(128) null,
	"responsibility" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
);

create table "biz"."position" (
	"id" serial not null,
	"state" smallint not null,
	"name" varchar(256) not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
);

create table "biz"."board_member_promoter" (
	"board_member_id" int not null,
	"business_entity_id" int not null,
	constraint "pk_board_member_promoter" primary key ("board_member_id", "business_entity_id")
);

create table "biz"."board_member" (
	"id" serial not null,
	"board_hid" int not null,
	"business_entity_id" int not null,
	"position_id" int null,
	"head_of_board" bool not null,
	"start_of_term" date not null,
	"end_of_term" date null,
	"comments" text null,
	 primary key ("id")
);

create table "biz"."board_history" (
	"hid" serial not null,
	"board_id" int not null,
	"period_start" date not null,
	"period_end" date not null,
	"secretary_id" int null,
	"phone" varchar(32) null,
	"email" varchar(128) null,
	"responsibility" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_board_history" primary key ("hid")
);

create table "biz"."board" (
	"id" serial not null,
	"state" smallint not null,
	"name" varchar(256) not null,
	"company_id" int not null,
	"board_type_id" int not null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
);

create table "biz"."board_type" (
	"id" int not null,
	"name" varchar(256) not null,
	 primary key ("id")
);

create table "biz"."subdivision_request" (
	"id" serial not null,
	"subdivision_id" int null,
	"subdivision_hid" int null,
	"request_id" int not null,
	"change_type_id" varchar(1) not null,
	"relevance_date" timestamp not null,
	"state" smallint not null,
	"name" varchar(256) not null,
	"subdivision_type_id" int not null,
	"registration_date" date null,
	"ogrn" varchar(32) null,
	"inn" varchar(32) null,
	"kpp" varchar(32) null,
	"parent_company_id" int not null,
	"country_id" int not null,
	"business_phone1" varchar(32) null,
	"business_phone2" varchar(32) null,
	"other_phone1" varchar(32) null,
	"other_phone2" varchar(32) null,
	"email" varchar(128) null,
	"webpage" varchar(128) null,
	"legal_address_id" int null,
	"mail_address_id" int null,
	"actual_address_id" int null,
	"executive_person_id" int null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
);

create table "biz"."document_state_global" (
	"document_state_id" int not null,
	"lang" varchar(2) not null,
	"name" varchar(256) null,
	"comments" text null,
	constraint "pk_document_state_global" primary key ("document_state_id", "lang")
);

create table "biz"."company_okved_item" (
	"company_okved_id" int not null,
	"okved_id" int not null,
	constraint "pk_company_okved_item" primary key ("company_okved_id", "okved_id")
);

create table "biz"."company_okved" (
	"id" serial not null,
	 primary key ("id")
);

create table "biz"."reorganization" (
	"id" serial not null,
	 primary key ("id")
);

create table "biz"."reorganization_item" (
	"reorganization_id" int not null,
	"reorganization_type_id" int not null,
	"reorganization_date" date not null,
	"assignee_company_id" int not null,
	constraint "pk_reorganization_item" primary key ("reorganization_id", "reorganization_type_id", "assignee_company_id")
);

create table "biz"."reorganization_type" (
	"id" int not null,
	"name" varchar(256) not null,
	constraint "pk_reorganization_type" primary key ("id")
);

create table "biz"."board_request_member_promoter" (
	"board_request_member_id" int not null,
	"business_entity_id" int not null,
	constraint "pk_board_request_member_promoter" primary key ("board_request_member_id", "business_entity_id")
);

create table "biz"."kladr" (
	"id" serial not null,
	"state" smallint not null,
	"code" varchar(13) not null,
	"name" varchar(255) not null,
	"abbreviation" varchar(10) not null,
	"postcode" varchar(6) null,
	"code_ifns" varchar(4) null,
	"code_area_ifns" varchar(4) null,
	"code_okato" varchar(11) null,
	constraint "pk_kladr" primary key ("id"),
	constraint "ak_kladr_code" unique ("code")
);

create table "biz"."business_role" (
	"id" int not null,
	"name" varchar(256) not null,
	constraint "pk_business_role" primary key ("id")
);

create table "biz"."company_setup_type" (
	"id" int not null,
	"name" varchar(256) not null,
	constraint "pk_company_setup_type" primary key ("id")
);

create table "biz"."company_request" (
	"id" serial not null,
	"company_id" int null,
	"company_hid" int null,
	"request_id" int not null,
	"change_type_id" varchar(1) not null,
	"relevance_date" timestamp not null,
	"state" smallint not null,
	"name" varchar(256) not null,
	"joint_stock_company" bool not null,
	"registration_date" date null,
	"liquidation_date" date null,
	"ogrn" varchar(32) null,
	"ogrn_date" date null,
	"ogrn_authority_name" varchar(256) null,
	"inn" varchar(32) null,
	"kpp" varchar(32) null,
	"kpp2" varchar(32) null,
	"kpp3" varchar(32) null,
	"issuer_code" varchar(32) null,
	"country_id" int not null,
	"company_setup_type_id" int null,
	"grn" varchar(32) null,
	"grn_date" date null,
	"grn_authority_name" varchar(256) null,
	"tax_registration_date" date null,
	"base_currency_id" int not null,
	"okopf_id" int null,
	"short_name" varchar(256) null,
	"full_name" varchar(1024) null,
	"short_name_intl" varchar(256) null,
	"full_name_intl" varchar(1024) null,
	"full_name_rus" varchar(1024) null,
	"business_phone1" varchar(32) null,
	"business_phone2" varchar(32) null,
	"other_phone1" varchar(32) null,
	"other_phone2" varchar(32) null,
	"email" varchar(128) null,
	"webpage" varchar(128) null,
	"legal_address_id" int null,
	"mail_address_id" int null,
	"actual_address_id" int null,
	"company_okved_id" int null,
	"okpo" varchar(32) null,
	"reorganization_id" int null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
);

create table "biz"."company" (
	"id" int not null,
	"state" smallint not null,
	"name" varchar(256) not null,
	"joint_stock_company" bool not null,
	"registration_date" date null,
	"liquidation_date" date null,
	"ogrn" varchar(32) null,
	"ogrn_date" date null,
	"ogrn_authority_name" varchar(256) null,
	"inn" varchar(32) null,
	"kpp" varchar(32) null,
	"kpp2" varchar(32) null,
	"kpp3" varchar(32) null,
	"issuer_code" varchar(32) null,
	"country_id" int not null,
	"company_setup_type_id" int null,
	"grn" varchar(32) null,
	"grn_date" date null,
	"grn_authority_name" varchar(256) null,
	"tax_registration_date" date null,
	"base_currency_id" int not null,
	"reorganization_id" int null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
);

create table "core"."document_attachment" (
	"id" serial not null,
	"document_type_id" int not null,
	"document_id" int not null,
	"attachment_type_id" int not null,
	"file_id" int not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
);

create table "core"."property_value" (
	"id" serial not null,
	"document_type_id" int not null,
	"document_id" int not null,
	"property_id" int not null,
	"period_start" date not null,
	"period_end" date not null,
	"value" text not null,
	 primary key ("id"),
	constraint "ak_property_value" unique ("document_type_id", "document_id", "property_id", "period_start")
);

create table "core"."document_transition" (
	"id" serial not null,
	"document_id" int not null,
	"document_type_id" int not null,
	"from_state" smallint not null,
	"to_state" smallint not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
);

create table "core"."document" (
	"id" int not null,
	"document_type_id" int not null,
	"state" smallint not null,
	"code" varchar(128) null,
	"name" varchar(1024) null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_document" primary key ("document_type_id", "id")
);

create table "core"."document_history" (
	"hid" int not null,
	"document_id" int not null,
	"document_type_id" int not null,
	"period_start" date not null,
	"period_end" date not null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_document_history" primary key ("document_type_id", "hid")
);

create table "core"."external_link" (
	"document_id" int not null,
	"document_type_id" int not null,
	"system_code" varchar(16) not null,
	"code" varchar(128) not null,
	constraint "pk_external_link" primary key ("document_type_id", "document_id", "system_code")
);

create table "core"."hierarchy_document" (
	"hierarchy_id" int not null,
	"document_id" int not null,
	"document_type_id" int not null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_hierarchy_document" primary key ("hierarchy_id", "document_id", "document_type_id")
);

create table "core"."hierarchy" (
	"id" serial not null,
	"state" smallint not null,
	"path" varchar(512) not null,
	"name" varchar(256) not null,
	"access_right_id" int null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_hierarchy" primary key ("id"),
	constraint "ak_hierarchy_path" unique ("path")
);

create table "dic"."okved" (
	"id" serial not null,
	"state" smallint not null,
	"version" smallint not null,
	"section" varchar(1) not null,
	"code" varchar(32) not null,
	"parent_code" varchar(32) null,
	"name" varchar(1024) not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_okved" primary key ("id")
);

create table "dic"."okopf" (
	"id" serial not null,
	"state" smallint not null,
	"code" varchar(5) not null,
	"parent_code" varchar(5) null,
	"name" varchar(256) not null,
	"singular_name" varchar(256) null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_okopf" primary key ("id")
);

create table "dic"."okof" (
	"id" serial not null,
	"state" smallint not null,
	"code" varchar(128) not null,
	"name" varchar(512) not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_okof" primary key ("id")
);

create table "dic"."country" (
	"id" serial not null,
	"state" smallint not null,
	"code" varchar(2) not null,
	"alf3" varchar(3) not null,
	"numeric_code" varchar(3) not null,
	"name" varchar(256) not null,
	"full_name" varchar(1024) not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_country" primary key ("id"),
	constraint "ak_country_code" unique ("code")
);

create table "dic"."currency" (
	"id" serial not null,
	"state" smallint not null,
	"code" varchar(3) not null,
	"numeric_code" varchar(3) not null,
	"name" varchar(256) not null,
	"minor_unit" smallint not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_currency" primary key ("id")
);

create table "dic"."currency_rate" (
	"id" serial not null,
	"from_currency_id" int not null,
	"to_currency_id" int not null,
	"period_start" date not null,
	"period_end" date not null,
	"amount" int not null,
	"value" decimal(28, 6) not null,
	constraint "pk_currency_rate" primary key ("id")
);

create table "dic"."unit_measure" (
	"id" serial not null,
	"state" smallint not null,
	"code" varchar(4) not null,
	"name" varchar(256) not null,
	"section" varchar(1) not null,
	"unit_measure_group_id" smallint not null,
	"local_name" varchar(32) null,
	"international_name" varchar(32) null,
	"local_symbol" varchar(32) null,
	"international_symbol" varchar(32) null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_unit_measure" primary key ("id"),
	constraint "ak_unit_measure_code" unique ("code")
);

create table "dic"."lang" (
	"id" int not null,
	"state" smallint not null,
	"code" varchar(2) not null,
	"name" varchar(256) not null,
	"native_name" varchar(256) not null,
	"comments" text null,
	constraint "pk_lang" primary key ("id"),
	constraint "ak_lang_code" unique ("code")
);

create table "dic"."unit_measure_conversion" (
	"id" serial not null,
	"from_unit_measure_id" int not null,
	"to_unit_measure_id" int not null,
	"multiplier" bigint not null,
	"divider" bigint not null,
	constraint "pk_unit_measure_conversion" primary key ("id")
);

create table "dic"."unit_measure_group" (
	"id" int not null,
	"state" smallint not null,
	"name" varchar(256) not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_unit_measure_group" primary key ("id")
);

create table "dic"."unit_measure_section" (
	"id" int not null,
	"state" smallint not null,
	"code" varchar(1) not null,
	"name" varchar(256) not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_unit_measure_section" primary key ("id"),
	constraint "ak_unit_measure_section_code" unique ("code")
);

create table "fs"."file" (
	"id" serial not null,
	"state" smallint not null,
	"name" varchar(256) not null,
	"relative_path" text not null,
	"comments" text not null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
);

create table "metadata"."transition_template" (
	"id" serial not null,
	"document_type_id" int not null,
	"from_state" smallint not null,
	"to_state" smallint not null,
	"access_right_id" int not null,
	 primary key ("id")
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
	 primary key ("id"),
	constraint "AK_document_state_value" unique ("document_type_id", "value")
);

create table "metadata"."property" (
	"id" serial not null,
	"document_type_id" int not null,
	"property_type_id" int not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	"supports_history" bool not null,
	"format" varchar(256) null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id"),
	constraint "ak_property_id_document_type_id" unique ("document_type_id", "id")
);

create table "metadata"."property_definition_global" (
	"property_definition_id" int not null,
	"lang" varchar(2) not null,
	"title" varchar(256) null,
	constraint "pk_property_definition_global" primary key ("property_definition_id", "lang")
);

create table "metadata"."data_operation_type" (
	"id" int not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	 primary key ("id")
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

create table "metadata"."change_type" (
	"id" varchar(1) not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	 primary key ("id")
);

create table "metadata"."property_type" (
	"id" int not null,
	"code" varchar(64) not null,
	"name" varchar(256) not null,
	constraint "pk_property_type" primary key ("id")
);

create table "metadata"."request_transition_template" (
	"id" serial not null,
	"request_type_id" int not null,
	"from_state" smallint not null,
	"to_state" smallint not null,
	"access_right_code" varchar(128) not null,
	"options" varchar(1024) null,
	constraint "pk_request_transition_template" primary key ("id")
);

create table "metadata"."document_type" (
	"id" serial not null,
	"state" smallint not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	"title" varchar(512) null,
	"schema_object_type" varchar(1024) null,
	"object_type" varchar(1024) null,
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

create table "metadata"."property_definition" (
	"id" serial not null,
	"state" smallint not null,
	"document_type_id" int not null,
	"ordinal" int not null,
	"name" varchar(64) not null,
	"title" varchar(256) not null,
	"db_type" varchar(128) not null,
	"maximum_length" int null,
	"numeric_precision" int null,
	"numeric_scale" int null,
	"nullable" bool not null,
	"generated" bool not null,
	"can_set" bool not null,
	"can_update" bool not null,
	"historical" bool not null,
	"base_set" varchar(16) not null,
	constraint "pk_property_definition" primary key ("id")
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
	"workflow_type_id" int null,
	"view_type" varchar(128) null,
	"view_source" varchar(1024) null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_request_type" primary key ("id"),
	constraint "ak_request_type_action" unique ("controller", "action"),
	constraint "ak_request_type_code" unique ("code")
);

create table "person"."relation_type" (
	"id" int not null,
	"name" varchar(256) not null,
	"alternate_name" varchar(256) not null,
	constraint "pk_relation_type" primary key ("id")
);

create table "person"."person_request" (
	"id" serial not null,
	"person_id" int null,
	"person_hid" int null,
	"request_id" int not null,
	"change_type_id" varchar(1) not null,
	"relevance_date" timestamp not null,
	"state" smallint not null,
	"name" varchar(256) not null,
	"inn" varchar(32) null,
	"birthdate" date null,
	"place_of_birth" varchar(256) null,
	"country_id" int not null,
	"title" varchar(32) null,
	"first_name" varchar(128) null,
	"middle_name" varchar(128) null,
	"last_name" varchar(128) null,
	"full_name" varchar(256) null,
	"business_phone1" varchar(32) null,
	"business_phone2" varchar(32) null,
	"mobile_phone1" varchar(32) null,
	"mobile_phone2" varchar(32) null,
	"home_phone1" varchar(32) null,
	"home_phone2" varchar(32) null,
	"other_phone1" varchar(32) null,
	"other_phone2" varchar(32) null,
	"email1" varchar(128) null,
	"email2" varchar(128) null,
	"skype" varchar(128) null,
	"webpage" varchar(128) null,
	"legal_address_id" int null,
	"mail_address_id" int null,
	"actual_address_id" int null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
);

create table "person"."person_relation_request" (
	"id" serial not null,
	"person_relation_id" int null,
	"request_id" int not null,
	"change_type_id" varchar(1) not null,
	"state" smallint not null,
	"person_id" int not null,
	"relative_person_id" int not null,
	"period_start" date not null,
	"period_end" date null,
	"relation_type_id" int not null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_person_relation_request" primary key ("id")
);

create table "person"."person_relation" (
	"id" serial not null,
	"state" smallint not null,
	"person_id" int not null,
	"relative_person_id" int not null,
	"period_start" date not null,
	"period_end" date null,
	"relation_type_id" int not null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_person_relation" primary key ("id"),
	constraint "ak_person_relation" unique ("person_id", "relative_person_id", "period_start")
);

create table "person"."person_history" (
	"hid" int not null,
	"person_id" int not null,
	"period_start" date not null,
	"period_end" date not null,
	"title" varchar(32) null,
	"first_name" varchar(128) null,
	"middle_name" varchar(128) null,
	"last_name" varchar(128) null,
	"full_name" varchar(256) null,
	"business_phone1" varchar(32) null,
	"business_phone2" varchar(32) null,
	"mobile_phone1" varchar(32) null,
	"mobile_phone2" varchar(32) null,
	"home_phone1" varchar(32) null,
	"home_phone2" varchar(32) null,
	"other_phone1" varchar(32) null,
	"other_phone2" varchar(32) null,
	"email1" varchar(128) null,
	"email2" varchar(128) null,
	"skype" varchar(128) null,
	"webpage" varchar(128) null,
	"legal_address_id" int null,
	"mail_address_id" int null,
	"actual_address_id" int null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_person_history" primary key ("hid"),
	constraint "ak_person_history_id" unique ("person_id", "hid")
);

create table "person"."person" (
	"id" int not null,
	"state" smallint not null,
	"name" varchar(256) not null,
	"inn" varchar(32) null,
	"birthdate" date null,
	"place_of_birth" varchar(256) null,
	"country_id" int not null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
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
	 primary key ("id"),
	constraint "ak_command_code" unique ("code")
);

create table "presentation"."node_global" (
	"node_id" int not null,
	"lang" varchar(2) not null,
	"name" varchar(256) null,
	"title" varchar(256) null,
	constraint "pk_node_global" primary key ("node_id", "lang")
);

create table "presentation"."node_type" (
	"id" int not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	 primary key ("id")
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

create table "presentation"."view_type" (
	"id" int not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	constraint "pk_view_type" primary key ("id"),
	constraint "ak_view_type_code" unique ("code")
);

create table "profile"."default_parameter" (
	"id" int not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	"type" varchar(128) not null,
	"value" text null,
	constraint "pk_default_parameter" primary key ("id"),
	constraint "ak_default_parameter_code" unique ("code")
);

create table "profile"."parameter" (
	"id" serial not null,
	"user_id" int not null,
	"parameter_code" varchar(128) not null,
	"value" text null,
	constraint "pk_parameter" primary key ("id"),
	constraint "ak_parameter_user_code" unique ("user_id", "parameter_code")
);

create table "profile"."application_state" (
	"id" serial not null,
	"user_id" int not null,
	"section" varchar(256) not null,
	"data" text not null,
	constraint "pk_application_state" primary key ("id")
);

create table "req"."request_transition" (
	"id" bigserial not null,
	"request_id" int not null,
	"from_state" smallint not null,
	"to_state" smallint not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_request_transition" primary key ("id")
);

create table "req"."request" (
	"id" serial not null,
	"state" smallint not null,
	"name" varchar(256) null,
	"request_type_id" int not null,
	"author_id" int not null,
	"data_operation_type_id" int not null,
	"document_type_id" int null,
	"document_id" int null,
	"document_hid" int null,
	"document_name" varchar(256) null,
	"request_data_id" int null,
	"relevance_date" date null,
	"process_id" int null,
	"comments_history" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_request" primary key ("id")
);

create table "sec"."user_role" (
	"user_id" int not null,
	"role_id" int not null,
	constraint "pk_user_role" primary key ("user_id", "role_id")
);

create table "sec"."role" (
	"id" int not null,
	"state" smallint not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_role" primary key ("id")
);

create table "sec"."user" (
	"id" int not null,
	"state" smallint not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	"email" varchar(256) null,
	"department" varchar(256) null,
	"company" varchar(256) null,
	"job_title" varchar(128) null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_user" primary key ("id")
);

create table "sec"."role_access_right" (
	"role_id" int not null,
	"access_right_id" int not null,
	constraint "pk_role_access_right" primary key ("role_id", "access_right_id")
);

create table "sec"."access_right" (
	"id" int not null,
	"state" smallint not null,
	"code" varchar(128) not null,
	"name" varchar(256) not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id"),
	constraint "ak_access_right_code" unique ("code")
);

create table "sec"."user_access_right" (
	"user_id" int not null,
	"access_right_id" int not null,
	constraint "pk_user_access_right" primary key ("user_id", "access_right_id")
);

create table "stock"."deal_type" (
	"id" int not null,
	"name" varchar(512) not null,
	"state" smallint not null,
	 primary key ("id")
);

create table "stock"."issue_type" (
	"id" int not null,
	"name" varchar(256) not null,
	"jsc" bool not null,
	"llc" bool not null,
	constraint "pk_issue_type" primary key ("id")
);

create table "stock"."stock_type" (
	"id" int not null,
	"name" varchar(512) not null,
	 primary key ("id")
);

create table "stock"."stock_class" (
	"id" int not null,
	"name" varchar(256) not null,
	 primary key ("id")
);

create table "stock"."share_type" (
	"id" serial not null,
	"state" smallint not null,
	"name" varchar(256) not null,
	"stock_type_id" int not null,
	"stock_class_id" int null,
	"votes_per_share" int not null,
	"face_value" decimal(26, 4) not null,
	"currency_id" int not null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id"),
	constraint "ak_share_type_all" unique ("stock_type_id", "stock_class_id", "votes_per_share", "face_value", "currency_id")
);

create table "stock"."issue" (
	"id" serial not null,
	"state" smallint not null,
	"issue_status_id" int not null,
	"company_id" int not null,
	"issue_type_id" int not null,
	"share_type_id" int not null,
	"old_share_type_id" int null,
	"declared_amount_integer" bigint not null,
	"declared_amount_numerator" bigint not null,
	"declared_amount_denominator" bigint not null,
	"amount_integer" bigint not null,
	"amount_numerator" bigint not null,
	"amount_denominator" bigint not null,
	"offering_method_id" int null,
	"offering_price" decimal(26, 4) null,
	"offering_currency_id" int null,
	"shares_issue_code" varchar(32) null,
	"decision_date" date not null,
	"registration_date" date null,
	"report_date" date null,
	"void_date" date null,
	"operation_date" date null,
	"ratio" int null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	 primary key ("id")
);

create table "stock"."issue_request" (
	"id" serial not null,
	"issue_id" int null,
	"request_id" int not null,
	"change_type_id" varchar(1) not null,
	"state" smallint not null,
	"issue_status_id" int not null,
	"company_id" int not null,
	"issue_type_id" int not null,
	"share_type_id" int null,
	"old_share_type_id" int null,
	"declared_amount_integer" bigint not null,
	"declared_amount_numerator" bigint not null,
	"declared_amount_denominator" bigint not null,
	"amount_integer" bigint not null,
	"amount_numerator" bigint not null,
	"amount_denominator" bigint not null,
	"offering_method_id" int null,
	"offering_price" decimal(26, 4) null,
	"offering_currency_id" int null,
	"shares_issue_code" varchar(32) null,
	"decision_date" date not null,
	"registration_date" date null,
	"report_date" date null,
	"void_date" date null,
	"operation_date" date null,
	"ratio" int null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_issue_request" primary key ("id")
);

create table "stock"."offering_method" (
	"id" serial not null,
	"state" smallint not null,
	"issue_type_id" int not null,
	"name" varchar(256) not null,
	constraint "pk_offering_method" primary key ("id")
);

create table "stock"."issue_status" (
	"id" int not null,
	"name" varchar(512) not null,
	 primary key ("id")
);

create table "stock"."deal" (
	"id" serial not null,
	"state" smallint not null,
	"deal_type_id" int not null,
	"seller_id" int null,
	"buyer_id" int null,
	"issuer_id" int not null,
	"issue_id" int null,
	"share_type_id" int not null,
	"amount_integer" bigint not null,
	"amount_numerator" bigint not null,
	"amount_denominator" bigint not null,
	"value" decimal(22, 6) null,
	"currency_id" int null,
	"change_hands_date" date not null,
	"contract_date" date null,
	"contract_number" varchar(64) null,
	"contract_name" varchar(256) null,
	"deal_date" date not null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_deal" primary key ("id")
);

create table "stock"."deal_request" (
	"id" serial not null,
	"deal_id" int null,
	"request_id" int not null,
	"change_type_id" varchar(1) not null,
	"state" smallint not null,
	"deal_type_id" int not null,
	"seller_id" int null,
	"buyer_id" int null,
	"issuer_id" int null,
	"issue_id" int null,
	"share_type_id" int null,
	"amount_integer" bigint null,
	"amount_numerator" bigint null,
	"amount_denominator" bigint null,
	"value" decimal(22, 6) null,
	"currency_id" int null,
	"change_hands_date" date not null,
	"contract_date" date null,
	"deal_date" date not null,
	"contract_number" varchar(64) null,
	"contract_name" varchar(256) null,
	"comments" text null,
	"modified_by" int not null,
	"modified_date" timestamp not null,
	constraint "pk_deal_request" primary key ("id")
);

alter table "metadata"."request_type"
	alter column "access_right_code" set default ('Generic');

alter table "acc"."stock_investment"
	add constraint "fk_stock_investment_operation" foreign key ("operation_id") references "acc"."operation" ("id");

alter table "acc"."stock_investment"
	add constraint "fk_stock_investment_operation_part" foreign key ("operation_part_id") references "acc"."operation_part" ("id");

alter table "acc"."stock_investment"
	add constraint "fk_stock_investment_currency" foreign key ("currency_id") references "dic"."currency" ("id");

alter table "acc"."stock_investment"
	add constraint "fk_stock_investment_shareholder" foreign key ("shareholder_id") references "biz"."business_entity" ("id");

alter table "acc"."stock_investment"
	add constraint "fk_stock_investment_issuer" foreign key ("issuer_id") references "biz"."company" ("id");

alter table "acc"."stock_investment"
	add constraint "fk_stock_investment_share_type" foreign key ("share_type_id") references "stock"."share_type" ("id");

alter table "acc"."authorized_capital"
	add constraint "fk_authorized_capital_operation" foreign key ("operation_id") references "acc"."operation" ("id");

alter table "acc"."authorized_capital"
	add constraint "fk_authorized_capital_operation_part" foreign key ("operation_part_id") references "acc"."operation_part" ("id");

alter table "acc"."authorized_capital"
	add constraint "fk_authorized_capital_currency" foreign key ("currency_id") references "dic"."currency" ("id");

alter table "acc"."authorized_capital"
	add constraint "fk_authorized_capital_issuer" foreign key ("issuer_id") references "biz"."company" ("id");

alter table "acc"."authorized_capital"
	add constraint "fk_authorized_capital_issue" foreign key ("issue_id") references "stock"."issue" ("id");

alter table "acc"."authorized_capital"
	add constraint "fk_authorized_capital_share_type" foreign key ("share_type_id") references "stock"."share_type" ("id");

alter table "acc"."operation"
	add constraint "fk_operation_document" foreign key ("document_type_id", "document_id") references "core"."document" ("document_type_id", "id");

alter table "acc"."operation"
	add constraint "fk_operation_debit_account" foreign key ("debit_account_code") references "acc"."account" ("code");

alter table "acc"."operation"
	add constraint "fk_operation_credit_account" foreign key ("credit_account_code") references "acc"."account" ("code");

alter table "acc"."treasury_stock"
	add constraint "fk_treasury_stock_operation" foreign key ("operation_id") references "acc"."operation" ("id");

alter table "acc"."treasury_stock"
	add constraint "fk_treasury_stock_operation_part" foreign key ("operation_part_id") references "acc"."operation_part" ("id");

alter table "acc"."treasury_stock"
	add constraint "fk_treasury_stock_currency" foreign key ("currency_id") references "dic"."currency" ("id");

alter table "acc"."treasury_stock"
	add constraint "fk_treasury_stock_issuer" foreign key ("issuer_id") references "biz"."company" ("id");

alter table "acc"."treasury_stock"
	add constraint "fk_treasury_stock_share_type" foreign key ("share_type_id") references "stock"."share_type" ("id");

alter table "acc"."stock_transit"
	add constraint "fk_stock_transit_operation" foreign key ("operation_id") references "acc"."operation" ("id");

alter table "acc"."stock_transit"
	add constraint "fk_stock_transit_operation_part" foreign key ("operation_part_id") references "acc"."operation_part" ("id");

alter table "acc"."stock_transit"
	add constraint "fk_stock_transit_currency" foreign key ("currency_id") references "dic"."currency" ("id");

alter table "acc"."stock_transit"
	add constraint "fk_stock_transit_shareholder" foreign key ("shareholder_id") references "biz"."business_entity" ("id");

alter table "acc"."stock_transit"
	add constraint "fk_stock_transit_issuer" foreign key ("issuer_id") references "biz"."company" ("id");

alter table "acc"."stock_transit"
	add constraint "fk_stock_transit_issue" foreign key ("issue_id") references "stock"."issue" ("id");

alter table "acc"."stock_transit"
	add constraint "fk_stock_transit_share_type" foreign key ("share_type_id") references "stock"."share_type" ("id");

alter table "biz"."company_history"
	add constraint "fk_company_history_company" foreign key ("company_id") references "biz"."company" ("id");

alter table "biz"."company_history"
	add constraint "fk_company_history_legaladdress" foreign key ("legal_address_id") references "biz"."address" ("id");

alter table "biz"."company_history"
	add constraint "fk_company_history_mailaddress" foreign key ("mail_address_id") references "biz"."address" ("id");

alter table "biz"."company_history"
	add constraint "fk_company_history_actualaddress" foreign key ("actual_address_id") references "biz"."address" ("id");

alter table "biz"."company_history"
	add constraint "fk_company_history_company_okved" foreign key ("company_okved_id") references "biz"."company_okved" ("id");

alter table "biz"."company_history"
	add constraint "fk_company_history_business_entity_history" foreign key ("hid") references "biz"."business_entity_history" ("hid");

alter table "biz"."company_history"
	add constraint "fk_company_history_okopf" foreign key ("okopf_id") references "dic"."okopf" ("id");

alter table "biz"."business_entity_history"
	add constraint "fk_business_entity_history_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "biz"."business_entity_history"
	add constraint "fk_business_entity_history" foreign key ("business_entity_id") references "biz"."business_entity" ("id");

alter table "biz"."business_entity_history"
	add constraint "fk_business_entity_history_legal_address" foreign key ("legal_address_id") references "biz"."address" ("id");

alter table "biz"."business_entity_history"
	add constraint "fk_business_entity_history_mail_address" foreign key ("mail_address_id") references "biz"."address" ("id");

alter table "biz"."business_entity_history"
	add constraint "fk_business_entity_history_actual_address" foreign key ("actual_address_id") references "biz"."address" ("id");

alter table "biz"."business_entity"
	add constraint "fk_business_entity_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "biz"."business_entity"
	add constraint "fk_business_entity_country" foreign key ("country_id") references "dic"."country" ("id");

alter table "biz"."subdivision_history"
	add constraint "fk_subdivision_history_legaladdress" foreign key ("legal_address_id") references "biz"."address" ("id");

alter table "biz"."subdivision_history"
	add constraint "fk_subdivision_history_mailaddress" foreign key ("mail_address_id") references "biz"."address" ("id");

alter table "biz"."subdivision_history"
	add constraint "fk_subdivision_history_actualaddress" foreign key ("actual_address_id") references "biz"."address" ("id");

alter table "biz"."subdivision_history"
	add constraint "fk_subdivision_history_executive_person" foreign key ("executive_person_id") references "person"."person" ("id");

alter table "biz"."subdivision_history"
	add constraint "fk_subdivision_history_business_entity_history" foreign key ("hid") references "biz"."business_entity_history" ("hid");

alter table "biz"."subdivision_history"
	add constraint "fk_subdivision_history_subdivision" foreign key ("subdivision_id") references "biz"."subdivision" ("id");

alter table "biz"."subdivision"
	add constraint "fk_subdivision_subdivision_type" foreign key ("subdivision_type_id") references "biz"."subdivision_type" ("id");

alter table "biz"."subdivision"
	add constraint "fk_subdivision_country" foreign key ("country_id") references "dic"."country" ("id");

alter table "biz"."subdivision"
	add constraint "fk_subdivision_parent_company" foreign key ("parent_company_id") references "biz"."company" ("id");

alter table "biz"."subdivision"
	add constraint "fk_subdivision_business_entity" foreign key ("id") references "biz"."business_entity" ("id");

alter table "biz"."address"
	add constraint "fk_address_country" foreign key ("country_id") references "dic"."country" ("id");

alter table "biz"."business_entity_role"
	add constraint "fk_business_entity_role_business_entity" foreign key ("business_entity_id") references "biz"."business_entity" ("id");

alter table "biz"."business_entity_role"
	add constraint "fk_business_entity_role_business_role" foreign key ("business_role_id") references "biz"."business_role" ("id");

alter table "biz"."board_request_member"
	add constraint "fk_board_request_member_board_request" foreign key ("board_request_id") references "biz"."board_request" ("id");

alter table "biz"."board_request_member"
	add constraint "fk_board_request_member_business_entity" foreign key ("business_entity_id") references "biz"."business_entity" ("id");

alter table "biz"."board_request_member"
	add constraint "fk_board_request_member_position" foreign key ("position_id") references "biz"."position" ("id");

alter table "biz"."board_request"
	add constraint "fk_board_request_board" foreign key ("board_id") references "biz"."board" ("id");

alter table "biz"."board_request"
	add constraint "fk_board_request_board_history" foreign key ("board_hid") references "biz"."board_history" ("hid");

alter table "biz"."board_request"
	add constraint "fk_board_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "biz"."board_request"
	add constraint "fk_board_request_change_type" foreign key ("change_type_id") references "metadata"."change_type" ("id");

alter table "biz"."board_request"
	add constraint "fk_board_request_company" foreign key ("company_id") references "biz"."company" ("id");

alter table "biz"."board_request"
	add constraint "fk_board_request_board_type" foreign key ("board_type_id") references "biz"."board_type" ("id");

alter table "biz"."board_request"
	add constraint "fk_board_request_secretary_person" foreign key ("secretary_id") references "person"."person" ("id");

alter table "biz"."board_member_promoter"
	add constraint "fk_board_member_promoter_board_member" foreign key ("board_member_id") references "biz"."board_member" ("id");

alter table "biz"."board_member_promoter"
	add constraint "fk_board_member_promoter_business_entity" foreign key ("business_entity_id") references "biz"."business_entity" ("id");

alter table "biz"."board_member"
	add constraint "fk_board_member_board_history" foreign key ("board_hid") references "biz"."board_history" ("hid");

alter table "biz"."board_member"
	add constraint "fk_board_member_business_entity" foreign key ("business_entity_id") references "biz"."business_entity" ("id");

alter table "biz"."board_member"
	add constraint "fk_board_member_position" foreign key ("position_id") references "biz"."position" ("id");

alter table "biz"."board_history"
	add constraint "fk_board_history_board" foreign key ("board_id") references "biz"."board" ("id");

alter table "biz"."board_history"
	add constraint "fk_board_history_secretary_person" foreign key ("secretary_id") references "person"."person" ("id");

alter table "biz"."board"
	add constraint "fk_board_company" foreign key ("company_id") references "biz"."company" ("id");

alter table "biz"."board"
	add constraint "fk_board_board_type" foreign key ("board_type_id") references "biz"."board_type" ("id");

alter table "biz"."subdivision_request"
	add constraint "fk_subdivision_request_change_type" foreign key ("change_type_id") references "metadata"."change_type" ("id");

alter table "biz"."subdivision_request"
	add constraint "fk_subdivision_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "biz"."subdivision_request"
	add constraint "fk_subdivision_request_subdivision" foreign key ("subdivision_id") references "biz"."subdivision" ("id");

alter table "biz"."subdivision_request"
	add constraint "fk_subdivision_request_subdivision_history" foreign key ("subdivision_hid") references "biz"."subdivision_history" ("hid");

alter table "biz"."subdivision_request"
	add constraint "fk_subdivision_request_subdivision_type" foreign key ("subdivision_type_id") references "biz"."subdivision_type" ("id");

alter table "biz"."subdivision_request"
	add constraint "fk_subdivision_request_country" foreign key ("country_id") references "dic"."country" ("id");

alter table "biz"."subdivision_request"
	add constraint "fk_subdivision_request_parent_company" foreign key ("parent_company_id") references "biz"."company" ("id");

alter table "biz"."subdivision_request"
	add constraint "fk_subdivision_request_legaladdress" foreign key ("legal_address_id") references "biz"."address" ("id");

alter table "biz"."subdivision_request"
	add constraint "fk_subdivision_request_mailaddress" foreign key ("mail_address_id") references "biz"."address" ("id");

alter table "biz"."subdivision_request"
	add constraint "fk_subdivision_request_actualaddress" foreign key ("actual_address_id") references "biz"."address" ("id");

alter table "biz"."subdivision_request"
	add constraint "fk_subdivision_request_executive_person" foreign key ("executive_person_id") references "person"."person" ("id");

alter table "biz"."document_state_global"
	add constraint "fk_document_state_global_document_state" foreign key ("document_state_id") references "metadata"."document_state" ("id");

alter table "biz"."company_okved_item"
	add constraint "fk_company_okved_item_company_okved" foreign key ("company_okved_id") references "biz"."company_okved" ("id");

alter table "biz"."company_okved_item"
	add constraint "fk_company_okved_item_okved" foreign key ("okved_id") references "dic"."okved" ("id");

alter table "biz"."reorganization_item"
	add constraint "fk_reorganization_item_reorganization" foreign key ("reorganization_id") references "biz"."reorganization" ("id");

alter table "biz"."reorganization_item"
	add constraint "fk_reorganization_item_reorganization_type" foreign key ("reorganization_type_id") references "biz"."reorganization_type" ("id");

alter table "biz"."reorganization_item"
	add constraint "fk_reorganization_item_assignee_company_company" foreign key ("assignee_company_id") references "biz"."company" ("id");

alter table "biz"."board_request_member_promoter"
	add constraint "fk_board_request_member_promoter_board_request_member" foreign key ("board_request_member_id") references "biz"."board_request_member" ("id");

alter table "biz"."board_request_member_promoter"
	add constraint "fk_board_request_member_promoter_business_entity" foreign key ("business_entity_id") references "biz"."business_entity" ("id");

alter table "biz"."company_request"
	add constraint "fk_company_request_change_type" foreign key ("change_type_id") references "metadata"."change_type" ("id");

alter table "biz"."company_request"
	add constraint "fk_company_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "biz"."company_request"
	add constraint "fk_company_request_company" foreign key ("company_id") references "biz"."company" ("id");

alter table "biz"."company_request"
	add constraint "fk_company_request_company_history" foreign key ("company_hid") references "biz"."company_history" ("hid");

alter table "biz"."company_request"
	add constraint "fk_company_request_legaladdress" foreign key ("legal_address_id") references "biz"."address" ("id");

alter table "biz"."company_request"
	add constraint "fk_company_request_mailaddress" foreign key ("mail_address_id") references "biz"."address" ("id");

alter table "biz"."company_request"
	add constraint "fk_company_request_actualaddress" foreign key ("actual_address_id") references "biz"."address" ("id");

alter table "biz"."company_request"
	add constraint "fk_company_request_company_okved" foreign key ("company_okved_id") references "biz"."company_okved" ("id");

alter table "biz"."company_request"
	add constraint "fk_company_request_country" foreign key ("country_id") references "dic"."country" ("id");

alter table "biz"."company_request"
	add constraint "fk_company_request_company_setup_type" foreign key ("company_setup_type_id") references "biz"."company_setup_type" ("id");

alter table "biz"."company_request"
	add constraint "fk_company_request_currency" foreign key ("base_currency_id") references "dic"."currency" ("id");

alter table "biz"."company_request"
	add constraint "fk_company_request_okopf" foreign key ("okopf_id") references "dic"."okopf" ("id");

alter table "biz"."company_request"
	add constraint "fk_company_request_reorganization" foreign key ("reorganization_id") references "biz"."reorganization" ("id");

alter table "biz"."company"
	add constraint "fk_company_country" foreign key ("country_id") references "dic"."country" ("id");

alter table "biz"."company"
	add constraint "fk_company_company_setup_type" foreign key ("company_setup_type_id") references "biz"."company_setup_type" ("id");

alter table "biz"."company"
	add constraint "fk_company_business_entity" foreign key ("id") references "biz"."business_entity" ("id");

alter table "biz"."company"
	add constraint "fk_company_currency" foreign key ("base_currency_id") references "dic"."currency" ("id");

alter table "biz"."company"
	add constraint "fk_company_reorganization" foreign key ("reorganization_id") references "biz"."reorganization" ("id");

alter table "core"."property_value"
	add constraint "fk_property_document" foreign key ("document_type_id", "document_id") references "core"."document" ("document_type_id", "id");

alter table "core"."property_value"
	add constraint "fk_property_value_property" foreign key ("document_type_id", "property_id") references "metadata"."property" ("document_type_id", "id");

alter table "core"."document_transition"
	add constraint "FK_document_transition_document_state_from" foreign key ("document_type_id", "from_state") references "metadata"."document_state" ("document_type_id", "value");

alter table "core"."document_transition"
	add constraint "FK_document_transition_document_state_to" foreign key ("document_type_id", "to_state") references "metadata"."document_state" ("document_type_id", "value");

alter table "core"."document"
	add constraint "fk_document_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "core"."document_history"
	add constraint "fk_document_history_document" foreign key ("document_type_id", "document_id") references "core"."document" ("document_type_id", "id");

alter table "core"."document_history"
	add constraint "fk_document_history_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "core"."external_link"
	add constraint "fk_external_link_document" foreign key ("document_type_id", "document_id") references "core"."document" ("document_type_id", "id");

alter table "core"."external_link"
	add constraint "fk_external_link_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "core"."hierarchy_document"
	add constraint "fk_hierarchy_document_hierarchy" foreign key ("hierarchy_id") references "core"."hierarchy" ("id");

alter table "core"."hierarchy_document"
	add constraint "fk_hierarchy_document_document" foreign key ("document_type_id", "document_id") references "core"."document" ("document_type_id", "id");

alter table "core"."hierarchy_document"
	add constraint "fk_hierarchy_document_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "core"."hierarchy"
	add constraint "fk_hierarchy_access_right" foreign key ("access_right_id") references "sec"."access_right" ("id");

alter table "dic"."currency_rate"
	add constraint "fk_currency_rate_from_currency" foreign key ("from_currency_id") references "dic"."currency" ("id");

alter table "dic"."currency_rate"
	add constraint "fk_currency_rate_to_currency" foreign key ("to_currency_id") references "dic"."currency" ("id");

alter table "dic"."unit_measure"
	add constraint "fk_unit_measure_uom_section" foreign key ("section") references "dic"."unit_measure_section" ("code");

alter table "dic"."unit_measure_conversion"
	add constraint "fk_uomc_from_uom" foreign key ("from_unit_measure_id") references "dic"."unit_measure" ("id");

alter table "dic"."unit_measure_conversion"
	add constraint "fk_uomc_to_uom" foreign key ("to_unit_measure_id") references "dic"."unit_measure" ("id");

alter table "metadata"."transition_template"
	add constraint "fk_transition_from_state" foreign key ("document_type_id", "from_state") references "metadata"."document_state" ("document_type_id", "value");

alter table "metadata"."transition_template"
	add constraint "fk_transition_to_state" foreign key ("document_type_id", "to_state") references "metadata"."document_state" ("document_type_id", "value");

alter table "metadata"."transition_template"
	add constraint "fk_transition_access_right" foreign key ("access_right_id") references "sec"."access_right" ("id");

alter table "metadata"."document_state"
	add constraint "FK_document_state_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "metadata"."property"
	add constraint "fk_property_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "metadata"."property"
	add constraint "fk_property_property_type" foreign key ("property_type_id") references "metadata"."property_type" ("id");

alter table "metadata"."property_definition_global"
	add constraint "fk_property_definition_global_property_definition" foreign key ("property_definition_id") references "metadata"."property_definition" ("id");

alter table "metadata"."request_type_global"
	add constraint "fk_request_type_global_request_type" foreign key ("request_type_id") references "metadata"."request_type" ("id");

alter table "metadata"."document_type_global"
	add constraint "fk_document_type_global_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "metadata"."request_transition_template"
	add constraint "fk_request_transition_template_request_type" foreign key ("request_type_id") references "metadata"."request_type" ("id");

alter table "metadata"."request_transition_template"
	add constraint "fk_request_transition_template_access_right" foreign key ("access_right_code") references "sec"."access_right" ("code");

alter table "metadata"."property_definition"
	add constraint "fk_property_definition_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "metadata"."request_type"
	add constraint "fk_request_type_access_right" foreign key ("access_right_code") references "sec"."access_right" ("code");

alter table "metadata"."request_type"
	add constraint "fk_request_type_data_operation_type" foreign key ("data_operation_type_id") references "metadata"."data_operation_type" ("id");

alter table "metadata"."request_type"
	add constraint "fk_request_type_document_type" foreign key ("document_type_id") references "metadata"."document_type" ("id");

alter table "metadata"."request_type"
	add constraint "fk_request_type_view_type" foreign key ("view_type") references "presentation"."view_type" ("code");

alter table "person"."person_request"
	add constraint "fk_person_request_change_type" foreign key ("change_type_id") references "metadata"."change_type" ("id");

alter table "person"."person_request"
	add constraint "fk_person_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "person"."person_request"
	add constraint "fk_person_request_person" foreign key ("person_id") references "person"."person" ("id");

alter table "person"."person_request"
	add constraint "fk_person_request_person_history" foreign key ("person_hid") references "person"."person_history" ("hid");

alter table "person"."person_request"
	add constraint "fk_person_request_legaladdress" foreign key ("legal_address_id") references "biz"."address" ("id");

alter table "person"."person_request"
	add constraint "fk_person_request_mailaddress" foreign key ("mail_address_id") references "biz"."address" ("id");

alter table "person"."person_request"
	add constraint "fk_person_request_actualaddress" foreign key ("actual_address_id") references "biz"."address" ("id");

alter table "person"."person_request"
	add constraint "fk_person_request_country" foreign key ("country_id") references "dic"."country" ("id");

alter table "person"."person_relation_request"
	add constraint "fk_person_relation_request_person" foreign key ("person_id") references "person"."person" ("id");

alter table "person"."person_relation_request"
	add constraint "fk_person_relation_request_relative_person" foreign key ("relative_person_id") references "person"."person" ("id");

alter table "person"."person_relation_request"
	add constraint "fk_person_relation_request_relation_type" foreign key ("relation_type_id") references "person"."relation_type" ("id");

alter table "person"."person_relation_request"
	add constraint "fk_person_relation_request_person_relation" foreign key ("person_relation_id") references "person"."person_relation" ("id");

alter table "person"."person_relation_request"
	add constraint "fk_person_relation_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "person"."person_relation"
	add constraint "fk_person_relation_person" foreign key ("person_id") references "person"."person" ("id");

alter table "person"."person_relation"
	add constraint "fk_person_relation_relative_person" foreign key ("relative_person_id") references "person"."person" ("id");

alter table "person"."person_relation"
	add constraint "fk_person_relation_relation_type" foreign key ("relation_type_id") references "person"."relation_type" ("id");

alter table "person"."person_history"
	add constraint "fk_person_history_person" foreign key ("person_id") references "person"."person" ("id");

alter table "person"."person_history"
	add constraint "fk_person_history_business_entity_history" foreign key ("hid") references "biz"."business_entity_history" ("hid");

alter table "person"."person_history"
	add constraint "fk_person_history_legaladdress" foreign key ("legal_address_id") references "biz"."address" ("id");

alter table "person"."person_history"
	add constraint "fk_person_history_mailaddress" foreign key ("mail_address_id") references "biz"."address" ("id");

alter table "person"."person_history"
	add constraint "fk_person_history_actualaddress" foreign key ("actual_address_id") references "biz"."address" ("id");

alter table "person"."person"
	add constraint "fk_person_country" foreign key ("country_id") references "dic"."country" ("id");

alter table "person"."person"
	add constraint "fk_person_business_entity" foreign key ("id") references "biz"."business_entity" ("id");

alter table "presentation"."command_global"
	add constraint "fk_command_global_command" foreign key ("command_id") references "presentation"."command" ("id");

alter table "presentation"."node_global"
	add constraint "fk_node_global_node" foreign key ("node_id") references "presentation"."node" ("id");

alter table "presentation"."node"
	add constraint "fk_node_node_type" foreign key ("node_type_id") references "presentation"."node_type" ("id");

alter table "presentation"."node"
	add constraint "fk_node_request_type" foreign key ("request_type_code") references "metadata"."request_type" ("code");

alter table "profile"."parameter"
	add constraint "fk_parameter_default_parameter" foreign key ("parameter_code") references "profile"."default_parameter" ("code");

alter table "req"."request_transition"
	add constraint "fk_request_transition_request" foreign key ("request_id") references "req"."request" ("id");

alter table "req"."request"
	add constraint "fk_request_request_type" foreign key ("request_type_id") references "metadata"."request_type" ("id");

alter table "req"."request"
	add constraint "fk_request_document" foreign key ("document_type_id", "document_id") references "core"."document" ("document_type_id", "id");

alter table "req"."request"
	add constraint "fk_request_document_history" foreign key ("document_type_id", "document_hid") references "core"."document_history" ("document_type_id", "hid");

alter table "req"."request"
	add constraint "fk_request_data_operation_type" foreign key ("data_operation_type_id") references "metadata"."data_operation_type" ("id");

alter table "sec"."user_role"
	add constraint "fk_user_role_user" foreign key ("user_id") references "sec"."user" ("id");

alter table "sec"."user_role"
	add constraint "fk_user_role_role" foreign key ("role_id") references "sec"."role" ("id");

alter table "sec"."role_access_right"
	add constraint "fk_role_access_right_role" foreign key ("role_id") references "sec"."role" ("id");

alter table "sec"."role_access_right"
	add constraint "fk_role_access_right_access_right" foreign key ("access_right_id") references "sec"."access_right" ("id");

alter table "sec"."user_access_right"
	add constraint "fk_user_access_right_user" foreign key ("user_id") references "sec"."user" ("id");

alter table "sec"."user_access_right"
	add constraint "fk_user_access_right_access_right" foreign key ("access_right_id") references "sec"."access_right" ("id");

alter table "stock"."share_type"
	add constraint "fk_capital_type_currency" foreign key ("currency_id") references "dic"."currency" ("id");

alter table "stock"."share_type"
	add constraint "fk_share_type_stock_type" foreign key ("stock_type_id") references "stock"."stock_type" ("id");

alter table "stock"."share_type"
	add constraint "fk_share_type_stock_class" foreign key ("stock_class_id") references "stock"."stock_class" ("id");

alter table "stock"."issue"
	add constraint "fk_issue_issue_type" foreign key ("issue_type_id") references "stock"."issue_type" ("id");

alter table "stock"."issue"
	add constraint "fk_issue_share_type" foreign key ("share_type_id") references "stock"."share_type" ("id");

alter table "stock"."issue"
	add constraint "fk_issue_old_share_type" foreign key ("old_share_type_id") references "stock"."share_type" ("id");

alter table "stock"."issue"
	add constraint "fk_issue_offering_currency" foreign key ("offering_currency_id") references "dic"."currency" ("id");

alter table "stock"."issue"
	add constraint "fk_issue_issue_status" foreign key ("issue_status_id") references "stock"."issue_status" ("id");

alter table "stock"."issue"
	add constraint "fk_issue_company" foreign key ("company_id") references "biz"."company" ("id");

alter table "stock"."issue"
	add constraint "fk_issue_offering_method" foreign key ("offering_method_id") references "stock"."offering_method" ("id");

alter table "stock"."issue_request"
	add constraint "fk_issue_request_change_type" foreign key ("change_type_id") references "metadata"."change_type" ("id");

alter table "stock"."issue_request"
	add constraint "fk_issue_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "stock"."issue_request"
	add constraint "fk_issue_request_issue" foreign key ("issue_id") references "stock"."issue" ("id");

alter table "stock"."issue_request"
	add constraint "fk_issue_request_issue_type" foreign key ("issue_type_id") references "stock"."issue_type" ("id");

alter table "stock"."issue_request"
	add constraint "fk_issue_request_share_type" foreign key ("share_type_id") references "stock"."share_type" ("id");

alter table "stock"."issue_request"
	add constraint "fk_issue_request_old_share_type" foreign key ("old_share_type_id") references "stock"."share_type" ("id");

alter table "stock"."issue_request"
	add constraint "fk_issue_request_offering_currency" foreign key ("offering_currency_id") references "dic"."currency" ("id");

alter table "stock"."issue_request"
	add constraint "fk_issue_request_issue_status" foreign key ("issue_status_id") references "stock"."issue_status" ("id");

alter table "stock"."issue_request"
	add constraint "fk_issue_request_company" foreign key ("company_id") references "biz"."company" ("id");

alter table "stock"."issue_request"
	add constraint "fk_issue_request_offering_method" foreign key ("offering_method_id") references "stock"."offering_method" ("id");

alter table "stock"."offering_method"
	add constraint "fk_offering_method_issue_type" foreign key ("issue_type_id") references "stock"."issue_type" ("id");

alter table "stock"."deal"
	add constraint "fk_deal_deal_type" foreign key ("deal_type_id") references "stock"."deal_type" ("id");

alter table "stock"."deal"
	add constraint "fk_deal_seller" foreign key ("seller_id") references "biz"."business_entity" ("id");

alter table "stock"."deal"
	add constraint "fk_deal_buyer" foreign key ("buyer_id") references "biz"."business_entity" ("id");

alter table "stock"."deal"
	add constraint "fk_deal_issuer" foreign key ("issuer_id") references "biz"."company" ("id");

alter table "stock"."deal"
	add constraint "fk_deal_issue" foreign key ("issue_id") references "stock"."issue" ("id");

alter table "stock"."deal"
	add constraint "fk_deal_share_type" foreign key ("share_type_id") references "stock"."share_type" ("id");

alter table "stock"."deal"
	add constraint "fk_deal_currency" foreign key ("currency_id") references "dic"."currency" ("id");

alter table "stock"."deal_request"
	add constraint "fk_deal_request_change_type" foreign key ("change_type_id") references "metadata"."change_type" ("id");

alter table "stock"."deal_request"
	add constraint "fk_deal_request_request" foreign key ("request_id") references "req"."request" ("id");

alter table "stock"."deal_request"
	add constraint "fk_deal_request_deal" foreign key ("deal_id") references "stock"."deal" ("id");

alter table "stock"."deal_request"
	add constraint "fk_deal_request_deal_type" foreign key ("deal_type_id") references "stock"."deal_type" ("id");

alter table "stock"."deal_request"
	add constraint "fk_deal_request_seller" foreign key ("seller_id") references "biz"."business_entity" ("id");

alter table "stock"."deal_request"
	add constraint "fk_deal_request_buyer" foreign key ("buyer_id") references "biz"."business_entity" ("id");

alter table "stock"."deal_request"
	add constraint "fk_deal_request_issuer" foreign key ("issuer_id") references "biz"."company" ("id");

alter table "stock"."deal_request"
	add constraint "fk_deal_request_issue" foreign key ("issue_id") references "stock"."issue" ("id");

alter table "stock"."deal_request"
	add constraint "fk_deal_request_share_type" foreign key ("share_type_id") references "stock"."share_type" ("id");

alter table "stock"."deal_request"
	add constraint "fk_deal_request_currency" foreign key ("currency_id") references "dic"."currency" ("id");

alter table "stock"."issue"
	add constraint "check_b626848b8d2440bfb671ab3ac4720076" check ("amount_numerator" >= 0);

alter table "stock"."issue"
	add constraint "check_115a828bb85e4c55b7b3ee80a1598466" check ("amount_denominator" > 0);

alter table "stock"."issue"
	add constraint "check_840d17a002a1470697c2cb28846634a8" check ("amount_numerator" >= 0);

alter table "stock"."issue"
	add constraint "check_1cfb3bca9e904b978963f41983490a09" check ("amount_denominator" > 0);

alter table "stock"."issue"
	add constraint "check_b93e69fab4ef403c8243051f2163851e" check ("ratio" > 0);

alter table "stock"."issue_request"
	add constraint "check_ae9234f246ee455faedd32cabf02e626" check ("amount_numerator" >= 0);

alter table "stock"."issue_request"
	add constraint "check_902913b17e9f4997988921fcecec0400" check ("amount_denominator" > 0);

alter table "stock"."issue_request"
	add constraint "check_3cf7e7578b6a42c6a4faa9524969c063" check ("amount_numerator" >= 0);

alter table "stock"."issue_request"
	add constraint "check_ecd5b5b4549f400d9aebd0ca5d98b0bd" check ("amount_denominator" > 0);

alter table "stock"."issue_request"
	add constraint "check_1029a2976c1d4b59a6c9ae8aeef51f5a" check ("ratio" > 0);

alter table "stock"."deal"
	add constraint "check_609d756883b34ea1903cd6723e94506c" check ("amount_numerator" >= 0 and "amount_numerator" < "amount_denominator");

alter table "stock"."deal"
	add constraint "check_ca5a6d25596a483f8b0ec1ab9c54adae" check ("amount_denominator" > 0);

alter table "stock"."deal_request"
	add constraint "check_3123efb33bd24bfcaab6071a8d3ae0df" check ("amount_numerator" >= 0 and "amount_numerator" < "amount_denominator");

alter table "stock"."deal_request"
	add constraint "check_a3f56b30bcb2413791cf4d7a19b7429e" check ("amount_denominator" > 0);


