create database tbTest;
use tbTest;
create table customer (id bigint, name string, address string);
describe customer;
insert into customer values (11, "test1", "test1"), (22, "test2", "test2");
select * from customer;
drop table customer;
drop database tbTest;