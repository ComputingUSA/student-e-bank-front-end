CREATE TABLE login  (userid char(12), password char(8), privilegele char(10))

CREATE TABLE Saving_Account (userid char(12), sanum char(8), savingbal float, status char(10), opened_date char(10))

CREATE TABLE Checking_Account (userid char(12), chnum char(8), chbal float, status char(10), opened_date char(10))

CREATE TABLE Customer (userid char(12), Lname char(12), Fname char(12), DOB char(10), SSN char(11), Address char(25), Homephone char (12), Email char(20))

Create table transaction (accnum char(10), trandate char(20), trantype char(20), debit char(20), credit char(20), balance char(20))

INSERT INTO LOGIN (userid,password,privilegele) VALUES (“admin”,”admin”,”admin”)


Optional data:

INSERT INTO Customer (userid, Lname, Fname, DOB, SSN, Address, Homephone, Email) VALUES('peter', 'peter', 'frank', '12/2/1980', '123456789', '20-3 12Str newyork NY', '1231231111', 'aa@hotmail.com')

INSERT INTO Customer (userid, Lname, Fname, DOB, SSN, Address, Homephone, Email) VALUES('rex', 'rex', 'chan', '10/2/1980', '123456782', '21 18Str newyork NY', '1231551111', 'bbb@hotmail.com')

INSERT INTO Customer (userid, Lname, Fname, DOB, SSN, Address, Homephone, Email) VALUES('john', 'john', 'wells', '12/26/1981', '356856789', '11 6Str newyork NY', '1231231444', 'ccc@hotmail.com')

INSERT INTO Saving_Account (userid, sanum, savingbal, status, opened_date) VALUES('peter', '12345', 360.0,'open', '1/5/2002')

INSERT INTO Saving_Account (userid, sanum, savingbal, status, opened_date) VALUES('rex', '23456', 558.0,'open', '11/5/2002')

INSERT INTO Saving_Account (userid, sanum, savingbal, status, opened_date) VALUES('john', '34567', 960.0,'open', '1/8/2002')

INSERT INTO Checking_Account (userid, chnum, chbal, status, opened_date) VALUES('john', '44567', 660.0,'open', '1/8/2002')


INSERT INTO Checking_Account (userid, chnum, chbal, status, opened_date) VALUES('peter', '22345', 580.0,'open', '1/5/2002')


INSERT INTO Checking_Account (userid, chnum, chbal, status, opened_date) VALUES('rex', '33456', 770.0,'open', '11/8/2002')

