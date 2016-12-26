DROP TABLE IF EXISTS `contract`;
DROP TABLE IF EXISTS `account`;
DROP TABLE IF EXISTS `company`;
DROP TABLE IF EXISTS `client`;

CREATE TABLE `company` (
  `companyname` varchar(100),
  `fax` TEXT(40),
  `address` varchar(100) NOT NULL,
  `account_number` int unsigned NOT NULL default 0,
  PRIMARY KEY (`companyname`)
) ENGINE=InnoDB;

CREATE TABLE `account` (
  `accountid` int(10) unsigned NOT NULL,
  `email` varchar(100),
  `name` varchar(20),
  `telephone` varchar(20),
  `companyname` varchar(100),
  `total_contract_value` int unsigned NOT NULL default 0,
  PRIMARY KEY (`accountid`),
  UNIQUE KEY (`email`),
  UNIQUE KEY (`telephone`),
  FOREIGN KEY (`companyname`)
        references company(`companyname`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `client` (
  `clientname` varchar(100),
  `fax` TEXT(40),
  `address` varchar(100),
  `client_value` int unsigned NOT NULL default 0,
  PRIMARY KEY (`clientname`)
) ENGINE=InnoDB;

CREATE TABLE `contract` (
  `contractid` int(10) unsigned NOT NULL,
  `contractname` varchar(100),
  `clientname` varchar(100),
  `accountid` int(10) unsigned,
  `value` int unsigned NOT NULL,
  PRIMARY KEY (`contractid`),
  FOREIGN KEY (`clientname`)
        references client(`clientname`)
        ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`accountid`)
        references account(`accountid`)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB;


DROP trigger if exists add_account;
CREATE trigger add_account after insert on account for each row
    update company set account_number = account_number + 1 where companyname = new.companyname;

DROP trigger if exists del_account;
CREATE trigger del_account after delete on account for each row
    update company set account_number = account_number - 1 where companyname = old.companyname;

delimiter |

DROP trigger if exists add_contract |
CREATE trigger add_contract after insert on contract for each row
    begin
    update client set client_value = client_value + new.value where clientname = new.clientname;
    update account set total_contract_value = total_contract_value + new.value where accountid = new.accountid;
    end
    |
DROP trigger if exists del_contract |
CREATE trigger del_contract after delete on contract for each row
    begin
    update client set client_value = client_value - old.value where clientname = old.clientname;
    update account set total_contract_value = total_contract_value - old.value where accountid = old.accountid;
    end
    |

DROP trigger if exists upd_contract |
CREATE trigger upd_contract after update on contract for each row
    begin
    IF (new.clientname = old.clientname) THEN
        update client set client_value = client_value + new.value - old.value where clientname = old.clientname;
    ELSE
        update client set client_value = client_value - old.value where clientname = old.clientname;
        update client set client_value = client_value + new.value where clientname = new.clientname;
    END IF;
    IF (new.accountid = old.accountid) THEN
        update account set total_contract_value = total_contract_value + new.value - old.value where accountid = old.accountid;
    ELSE
        update account set total_contract_value = total_contract_value + new.value where accountid = new.accountid;
        update account set total_contract_value = total_contract_value - old.value where accountid = old.accountid;
    END IF;
    end
    |
delimiter ;

