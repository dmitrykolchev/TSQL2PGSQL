# TSQL2PGSQL
Converts T-SQL script to PostgreSql. 

This program converts T-SQL scripts to PostgreSql scripts.




``` t-sql
CREATE TABLE [person].[person_history] (
    [hid]               INT            NOT NULL,
    [person_id]         INT            NOT NULL,
    [period_start]      DATE           NOT NULL,
    [period_end]        DATE           NOT NULL,
    [title]             NVARCHAR (32)  NULL,
    [first_name]        NVARCHAR (128) NULL,
    [middle_name]       NVARCHAR (128) NULL,
    [last_name]         NVARCHAR (128) NULL,
    [full_name]         NVARCHAR (256) NULL,
    [business_phone1]   VARCHAR (32)   NULL,
    [business_phone2]   VARCHAR (32)   NULL,
    [mobile_phone1]     VARCHAR (32)   NULL,
    [mobile_phone2]     VARCHAR (32)   NULL,
    [home_phone1]       VARCHAR (32)   NULL,
    [home_phone2]       VARCHAR (32)   NULL,
    [other_phone1]      VARCHAR (32)   NULL,
    [other_phone2]      VARCHAR (32)   NULL,
    [email1]            NVARCHAR (128) NULL,
    [email2]            NVARCHAR (128) NULL,
    [skype]             NVARCHAR (128) NULL,
    [webpage]           NVARCHAR (128) NULL,
    [legal_address_id]  INT            NULL,
    [mail_address_id]   INT            NULL,
    [actual_address_id] INT            NULL,
    [modified_by]       INT            NOT NULL,
    [modified_date]     DATETIME2 (7)  NOT NULL,
    CONSTRAINT [pk_person_history] PRIMARY KEY NONCLUSTERED ([hid] ASC),
    CONSTRAINT [ak_person_history_id] UNIQUE CLUSTERED ([person_id] ASC, [hid] ASC)
);

CREATE TABLE [req].[request] (
    [id]                     INT            IDENTITY (1, 1) NOT NULL,
    [state]                  SMALLINT       NOT NULL,
    [name]                   NVARCHAR (256) NULL,
    [request_type_id]        INT            NOT NULL,
    [author_id]              INT            NOT NULL,
    [data_operation_type_id] INT            NOT NULL,
    [document_type_id]       INT            NULL,
    [document_id]            INT            NULL,
    [document_hid]           INT            NULL,
    [document_name]          NVARCHAR (256) NULL,
    [request_data_id]        INT            NULL,
    [relevance_date]         DATE           NULL,
    [process_id]             INT            NULL,
    [comments_history]       NVARCHAR (MAX) NULL,
    [modified_by]            INT            NOT NULL,
    [modified_date]          DATETIME2 (7)  NOT NULL,
    CONSTRAINT [pk_request] PRIMARY KEY CLUSTERED ([id] ASC)


```

``` sql
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


```
