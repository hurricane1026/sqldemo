insert into company (companyname, fax, address) values("meiqia", "123214", "shangdi,yiquanhui");
insert into company (companyname, fax, address) values("test", "123211224", "test");

insert into account (accountid, email, name , telephone, companyname) values (1, "1@meiqia.com", "111", "111111", "meiqia");
insert into account (accountid, email, name , telephone, companyname) values (2, "2@meiqia.com", "222", "222222", "meiqia");

insert into client (clientname, fax, address) values ("shangde", "1234123", "beijing");
insert into client (clientname, fax, address) values ("huanqiu", "11234123", "beijing");

insert into contract (contractid, contractname, clientname, accountid, value) values (
100, "2016 early", "shangde", 1, 10000
);

insert into contract (contractid, contractname, clientname, accountid, value) values (
200, "2016 early", "huanqiu", 2, 20000
);
