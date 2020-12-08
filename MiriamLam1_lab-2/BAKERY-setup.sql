DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS receipts;
DROP TABLE IF EXISTS goods;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers(
    CId INTEGER PRIMARY KEY NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    UNIQUE(FirstName, LastName)
);

CREATE TABLE goods(
    GId VARCHAR(50) PRIMARY KEY NOT NULL,
    Flavor VARCHAR(50) NOT NULL,
    Food VARCHAR(50) NOT NULL,
    Price DECIMAL(5,2) NOT NULL,
    UNIQUE(Food,Flavor)
);

CREATE TABLE receipts(
    RNumber CHAR(5) PRIMARY KEY NOT NULL,
    Customer INTEGER NOT NULL,
    SaleDate DATE NOT NULL,
    FOREIGN KEY(Customer) REFERENCES customers(CId)
);

CREATE TABLE items(
    Receipt CHAR(5) NOT NULL,
    Ordinal INT NOT NULL,
    Item VARCHAR(50) NOT NULL,
    UNIQUE(Receipt, Ordinal),
    FOREIGN KEY (Item) REFERENCES goods (GId),
    FOREIGN KEY (Receipt) REFERENCES receipts(RNumber)
);
