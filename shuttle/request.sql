CREATE TABLE request (
    id int(11) auto_increment,
    departure varchar(11) not null,
    arrival varchar(11) not null,
    date  varchar(20) not null,
    hour  varchar(4) not null,
    minute  varchar(4) not null,
    date_created datetime not null default NOW());