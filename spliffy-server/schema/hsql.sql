alter table address_book drop constraint FKFB8B054B41C0965;
alter table branch drop constraint FKADAF25A2797DEFA1;
alter table branch drop constraint FKADAF25A2DBC256B5;
alter table branch drop constraint FKADAF25A2DF4B1732;
alter table cal_event drop constraint FKABCCC2E94BF6E69A;
alter table calendar drop constraint FKF55EFB3EB41C0965;
alter table commit_item drop constraint FK5A19351B24564550;
alter table commit_item drop constraint FK5A19351B5844BC56;
alter table commit_item drop constraint FK5A19351B87B0AAE2;
alter table contact drop constraint FK38B724209E879473;
alter table deleted_item drop constraint FKEE892B79C498A977;
alter table deleted_item drop constraint FKEE892B79D23A15E0;
alter table deleted_item drop constraint FKEE892B796259B2DB;
alter table directory_member drop constraint FK84B4C4AC128EE6EF;
alter table directory_member drop constraint FK84B4C4AC288B1AFF;
alter table fanout_entry drop constraint FKD6C6228E8E483F02;
alter table item_version drop constraint FKC31F7BACA664A544;
alter table permission drop constraint FKE125C5CFD928E814;
alter table permission drop constraint FKE125C5CFBE7D0D6E;
alter table repository drop constraint FK7446DB4A27CAD3C3;
alter table repository drop constraint FK7446DB4ADBC256B5;
alter table share drop constraint FK6854FDFF9ACA084;
alter table user_entity drop constraint FKDED72AD7ADFB913D;
alter table volume_instance drop constraint FK6A9A3C1ACBA82DD2;
drop table address_book if exists;
drop table base_entity if exists;
drop table blob_hash if exists;
drop table branch if exists;
drop table cal_event if exists;
drop table calendar if exists;
drop table commit_item if exists;
drop table contact if exists;
drop table deleted_item if exists;
drop table directory_member if exists;
drop table fanout_entry if exists;
drop table fanout_hash if exists;
drop table item if exists;
drop table item_version if exists;
drop table permission if exists;
drop table repository if exists;
drop table share if exists;
drop table user_entity if exists;
drop table volume if exists;
drop table volume_instance if exists;
create table address_book (id bigint generated by default as identity (start with 1), name varchar(255) not null, description varchar(255), created_date date not null, modified_date date not null, owner varchar(255), primary key (id));
create table base_entity (name varchar(255) not null, created_date date not null, modified_date date not null, primary key (name));
create table blob_hash (blob_hash bigint not null, volume_id bigint not null, primary key (blob_hash));
create table branch (id bigint generated by default as identity (start with 1), name varchar(255) not null, head bigint, repository bigint not null, linked_to bigint, primary key (id));
create table cal_event (id bigint generated by default as identity (start with 1), name varchar(255) not null, description varchar(255), timezone varchar(255), created_date timestamp not null, modified_date timestamp not null, ctag bigint not null, start_date timestamp not null, end_date timestamp not null, summary varchar(255), calendar bigint not null, primary key (id));
create table calendar (id bigint generated by default as identity (start with 1), name varchar(255) not null, created_date timestamp not null, modified_date timestamp not null, ctag bigint not null, color varchar(255), owner varchar(255) not null, primary key (id), unique (name, owner));
create table commit_item (id bigint generated by default as identity (start with 1), created_date timestamp, editor varchar(255), branch bigint not null, root_item_version bigint not null, primary key (id));
create table contact (id bigint generated by default as identity (start with 1), name varchar(255) not null, created_date timestamp not null, modified_date timestamp not null, organization_name varchar(255), telephonenumber varchar(255), given_name varchar(255), sur_name varchar(255), mail varchar(255), uid varchar(255) not null, address_book bigint not null, primary key (id));
create table deleted_item (id bigint generated by default as identity (start with 1), repo_version bigint, deleted_from bigint, deleted_resource bigint, primary key (id));
create table directory_member (id bigint generated by default as identity (start with 1), name varchar(1000), parent_item bigint not null, member_item bigint not null, primary key (id), unique (name, parent_item));
create table fanout_entry (id bigint generated by default as identity (start with 1), chunk_hash bigint, fanout bigint, primary key (id));
create table fanout_hash (fanout_hash bigint not null, actual_content_length bigint not null, primary key (fanout_hash));
create table item (id bigint generated by default as identity (start with 1), type varchar(1) not null, create_date date not null, primary key (id));
create table item_version (id bigint generated by default as identity (start with 1), modified_date date not null, item_hash bigint not null, item bigint not null, primary key (id));
create table permission (id bigint generated by default as identity (start with 1), priviledge integer, granted_on bigint, grantee varchar(255), primary key (id));
create table repository (id bigint generated by default as identity (start with 1), name varchar(255), created_date date not null, head bigint, base_entity varchar(255) not null, primary key (id));
create table share (id varbinary(255) not null, created_date date not null, priviledge integer, share_recip varchar(255), accepted_date date, shared_from bigint not null, primary key (id));
create table user_entity (name varchar(255) not null, email varchar(255) not null, password varchar(255), primary key (name));
create table volume (id bigint generated by default as identity (start with 1), target_capacity bigint not null, used_bytes bigint not null, primary key (id));
create table volume_instance (id bigint generated by default as identity (start with 1), location varchar(255) not null, instance_type varchar(255) not null, capacity bigint, cost integer not null, online bit not null, lost bit not null, volume bigint, primary key (id), unique (location, instance_type));
alter table address_book add constraint FKFB8B054B41C0965 foreign key (owner) references base_entity;
alter table branch add constraint FKADAF25A2797DEFA1 foreign key (linked_to) references branch;
alter table branch add constraint FKADAF25A2DBC256B5 foreign key (head) references commit_item;
alter table branch add constraint FKADAF25A2DF4B1732 foreign key (repository) references repository;
alter table cal_event add constraint FKABCCC2E94BF6E69A foreign key (calendar) references calendar;
alter table calendar add constraint FKF55EFB3EB41C0965 foreign key (owner) references base_entity;
alter table commit_item add constraint FK5A19351B24564550 foreign key (root_item_version) references item_version;
alter table commit_item add constraint FK5A19351B5844BC56 foreign key (editor) references user_entity;
alter table commit_item add constraint FK5A19351B87B0AAE2 foreign key (branch) references branch;
alter table contact add constraint FK38B724209E879473 foreign key (address_book) references address_book;
alter table deleted_item add constraint FKEE892B79C498A977 foreign key (deleted_from) references item_version;
alter table deleted_item add constraint FKEE892B79D23A15E0 foreign key (repo_version) references commit_item;
alter table deleted_item add constraint FKEE892B796259B2DB foreign key (deleted_resource) references item_version;
alter table directory_member add constraint FK84B4C4AC128EE6EF foreign key (parent_item) references item_version;
alter table directory_member add constraint FK84B4C4AC288B1AFF foreign key (member_item) references item_version;
alter table fanout_entry add constraint FKD6C6228E8E483F02 foreign key (fanout) references fanout_hash;
alter table item_version add constraint FKC31F7BACA664A544 foreign key (item) references item;
alter table permission add constraint FKE125C5CFD928E814 foreign key (granted_on) references item;
alter table permission add constraint FKE125C5CFBE7D0D6E foreign key (grantee) references base_entity;
alter table repository add constraint FK7446DB4A27CAD3C3 foreign key (base_entity) references base_entity;
alter table repository add constraint FK7446DB4ADBC256B5 foreign key (head) references commit_item;
alter table share add constraint FK6854FDFF9ACA084 foreign key (shared_from) references branch;
alter table user_entity add constraint FKDED72AD7ADFB913D foreign key (name) references base_entity;
alter table volume_instance add constraint FK6A9A3C1ACBA82DD2 foreign key (volume) references volume;
