-- BAKERY-1
UPDATE goods SET Price = Price + 2 WHERE Food = 'Cake' and Flavor = 'Lemon' OR Food = 'Cake' and Flavor = 'Napoleon';

-- BAKERY-2
UPDATE goods SET Price = Price*1.15 WHERE (Flavor = 'Apricot' OR Flavor = 'Chocolate') AND Price < 5.95 ORDER BY Food;

-- BAKERY-3
DROP TABLE IF EXISTS payments;

CREATE TABLE payments(
    Receipt CHAR(5) NOT NULL,
    Amount DECIMAL(5,2) NOT NULL,
    PaymentSettled DATETIME,
    PaymentType VARCHAR(30),
    UNIQUE(Receipt,Amount),
    FOREIGN KEY (Receipt) REFERENCES receipts(RNumber)
);

-- BAKERY-4
drop trigger if exists noweekends;
create trigger noweekends before insert on items

for each row
    begin
        DECLARE mydate DATE;
        DECLARE myfood varchar(100);
        DECLARE myflavor varchar(100);
        
        SELECT SaleDate INTO mydate from receipts WHERE receipts.RNumber = NEW.Receipt;
        SELECT Flavor into myflavor from goods where goods.GId = new.Item;
        SELECT Food into myfood from goods where goods.GId = new.Item;
        
        if (DAYOFWEEK(mydate)=1 or DAYOFWEEK(mydate)=7) and (myfood = "Meringues" and myflavor = "Almond") then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot add Meringues or Almonds on Sunday or Saturday';
        end if;
    end;

-- AIRLINES-1
create trigger same_location before insert on flights

for each row
    begin
        if (new.SourceAirport = new.DestAirport) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot fly to same place';
        end if;
    end;

-- AIRLINES-2
ALTER TABLE airlines
    DROP COLUMN Partner;

ALTER TABLE airlines
    ADD COLUMN Partner VARCHAR(30) NULL;
    
UPDATE airlines
SET Partner = "JetBlue"
WHERE Abbreviation = "SouthWest";

UPDATE airlines
SET Partner = "SouthWest"
WHERE Abbreviation = "JetBlue";
    
DROP trigger IF EXISTS partner_check;

CREATE trigger partner_check before insert on airlines
    for each row
    begin
        if (new.Partner = new.Abbreviation) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot partner to yourself';
        end if;
        
        if exists (select * from airlines where (new.Partner = Partner)) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Already partnered to something else';
        end if;
        
        if ((!exists(select * from airlines where Abbreviation = new.Partner)) and new.Partner<>NULL)then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nonexistent Partner';
        end if;
    end;
    
DROP trigger IF EXISTS partner_check_update;
CREATE trigger partner_check_update before update on airlines
    for each row
    begin
        if (new.Partner = new.Abbreviation) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot partner to yourself';
        end if;
        
        if exists (select * from airlines where (new.Partner = Partner)) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Already partnered to something else';
        end if;
        
        if !exists(select * from airlines where Abbreviation = new.Partner) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nonexistent Partner';
        end if;
    end;


-- KATZENJAMMER-1
ALTER TABLE Instruments
    MODIFY Instrument VARCHAR(100);
    
UPDATE Instruments
SET Instrument = "awesome bass balalaika"
WHERE Instrument = "bass balalaika";

UPDATE Instruments
SET Instrument = "acoustic guitar"
WHERE Instrument = "guitar";

-- KATZENJAMMER-2
DELETE FROM Vocals
WHERE !((Bandmate = 1) and (`Type` <> 'lead'));


