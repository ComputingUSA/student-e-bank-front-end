CREATE TABLE Saving_Account (userid char(12), sanum char(8), savingbal 
float, status char(10), opened_date char(10))

CREATE TABLE Checking_Account (userid char(12), chnum char(8), chbal float, 
status char(10), opened_date char(10))

CREATE TABLE Security (userid char(12), password char(8), previledge 
char(2))


CREATE TABLE Customer (userid char(12), Lname char(12), Fname char(12), DOB 
char(10), SSN char(11), Address char(25), Homephone char (12), Email 
char(20))

INSERT INTO Customer (userid, Lname, Fname, DOB, SSN, Address, Homephone, 
Email) VALUES('peter', 'peter', 'frank', '12/2/1980', '123456789', '20-3 
12Str newyork NY', '1231231111', 'aaa@hotmail.com')

INSERT INTO Customer (userid, Lname, Fname, DOB, SSN, Address, Homephone, 
Email) VALUES('rex', 'rex', 'chan', '10/2/1980', '123456782', '21 18Str 
newyork NY', '1231551111', 'bbb@hotmail.com')

INSERT INTO Customer (userid, Lname, Fname, DOB, SSN, Address, Homephone, 
Email) VALUES('john', 'john', 'wells', '12/26/1981', '356856789', '11 6Str 
newyork NY', '1231231444', 'ccc@hotmail.com')


INSERT INTO Saving_Account (userid, sanum, savingbal, status, opened_date) 
VALUES('peter', '12345', 360.0,'open', '1/5/2002')

INSERT INTO Saving_Account (userid, sanum, savingbal, status, opened_date) 
VALUES('rex', '23456', 558.0,'open', '11/5/2002')

INSERT INTO Saving_Account (userid, sanum, savingbal, status, opened_date) 
VALUES('john', '34567', 960.0,'open', '1/8/2002')

INSERT INTO Checking_Account (userid, chnum, chbal, status, opened_date) 
VALUES('john', '44567', 660.0,'open', '1/8/2002')


INSERT INTO Checking_Account (userid, chnum, chbal, status, opened_date) 
VALUES('peter', '22345', 580.0,'open', '1/5/2002')


INSERT INTO Checking_Account (userid, chnum, chbal, status, opened_date) 
VALUES('rex', '33456', 770.0,'open', '11/8/2002')

CREATE TABLE transaction (accnum int, trandate char(10), trantype char(26), 
debit float, credit float, balance float)

INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance) 
VALUES (12345, '09/17/2003', 'ATM WITHDRAWAL', 20.0, null, 780.0)

INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance) 
VALUES (12345, '09/15/2003', 'DEPOSIT', null, 200.0, 800.0)

INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance) 
VALUES (12345, '09/13/2003', 'AUTOMATED PAYMENT', null, 500.0, 600.0)

INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance) 
VALUES (12345, '09/11/2003', 'ATM WITHDRAWAL', 40.0, null, 100.0)

INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance) 
VALUES (22345, '09/10/2003','Check #403', 40.0, null, 360.0)

INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance) 
VALUES (22345, '09/05/2003', 'Transfer #101', null, 200.0, 400.0)

INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance) 
VALUES (22345, '09/04/2003', 'Deposit', null, 100.0, 200.0)


INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance) 
VALUES (22345, '09/02/2003', 'Check #402', 50.0, null, 100.0)

