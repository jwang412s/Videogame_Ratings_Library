DROP TABLE Stocks;
DROP TABLE Run;
DROP TABLE Device;
DROP TABLE Online_R;
DROP TABLE Physical_R;
DROP TABLE IsOf;
DROP TABLE About;
DROP TABLE Rating;
DROP TABLE BuysFrom;
DROP TABLE Game;
DROP TABLE Developer;
DROP TABLE Genre;
DROP TABLE Customer;
DROP TABLE Retailer;



create table Developer
	(DeveloperID int not null,
	D_Name char(40) not null,
	NumOfEmployees int not null,
	D_Type char(40),
	Country char(40),
	UNIQUE (D_Name),
	primary key (DeveloperID)
	);
grant select on Developer to public;
	
CREATE TABLE Game (
	GameID int not null,
	G_Title	char(100),
	Price	float,
	DeveloperID	int not null,
	primary key(GameID),
	FOREIGN KEY	(DeveloperID) references Developer ON DELETE CASCADE,
	UNIQUE(G_Title)
	);
grant select on Game to public;

CREATE TABLE Genre (
	G_Name	char(20) not null,
	TagCreationDate	char(20),
	Popularity	int,
	primary key(G_Name, TagCreationDate)
	);
grant select on Genre to public;

CREATE TABLE IsOf (
	TagCreationDate	char(20),
	GameID int, 
	G_Name char(20),
	primary key (GameID, G_Name, TagCreationDate),
	FOREIGN KEY	(G_Name, TagCreationDate) references Genre(G_Name, TagCreationDate) ON DELETE CASCADE,
	FOREIGN KEY	(GameID) references Game ON DELETE CASCADE
	);
grant select on IsOf to public;




CREATE TABLE Customer (
	Username CHAR(20),
	C_Name CHAR(20),
	Phone# INT,
    PRIMARY KEY (Username),
	UNIQUE(Phone#)
);

grant select on Customer to public;


CREATE TABLE Rating (
	RatingID int,
	Stars int,
	R_Title char(100), 
	GameID int,
	Username char(20) not null,
	primary key	(RatingID, Username),
	FOREIGN KEY (GameID) references Game ON DELETE CASCADE,
	FOREIGN KEY	(Username) references Customer(Username) ON DELETE CASCADE,
	UNIQUE(R_Title),
	UNIQUE(RatingID)
	);
grant select on Rating to public;


CREATE TABLE About (
	RatingID int not null,		
	GameID	int,
	PRIMARY KEY	(RatingID, GameID),
	FOREIGN KEY	(GameID) references	Game(GameID) ON DELETE CASCADE,
	FOREIGN KEY	(RatingID) references Rating(RatingID) ON DELETE CASCADE
	); 
grant select on About to public;




CREATE TABLE Retailer (
	RetailerID INT,
    PRIMARY KEY (RetailerID)
);

grant select on Retailer to public;

CREATE TABLE Physical_R (
	RetailerID INT,
	Street CHAR(40),
	City CHAR(20),
	PostalCode CHAR(6),
	PRIMARY KEY	(RetailerID),
	FOREIGN KEY	(RetailerID) REFERENCES	Retailer ON DELETE CASCADE
);

grant select on Physical_R to public;

CREATE TABLE Online_R (
	RetailerID INT,
	WebsiteURL CHAR(100),
    PRIMARY KEY (RetailerID),
	FOREIGN KEY (RetailerID) REFERENCES	Retailer ON DELETE CASCADE,
	UNIQUE(WebsiteURL)
);

grant select on Online_R to public;



CREATE TABLE BuysFrom (
	Username char(20),
	RetailerID int,
	PRIMARY KEY	(Username, RetailerID),
	FOREIGN KEY	(Username)	references	Customer(Username) ON DELETE CASCADE,
	FOREIGN KEY	(RetailerID) references Retailer(RetailerID) ON DELETE CASCADE
	);


















INSERT INTO	Developer VALUES	(1, 'Rockstar Games', 2000, 'Studio', 'USA');
INSERT INTO	Developer VALUES	(2, 'Activision-Blizzard', 9800, 'Studio', 'USA');
INSERT INTO	Developer VALUES	(3, 'Game Freak', 169, 'Studio',  'Japan');
INSERT INTO	Developer VALUES	(4, 'Gattai Games', 10, 'Indie', 'Singapore');
INSERT INTO	Developer VALUES	(5, 'EA', 12000, 'Studio',  'USA');
INSERT INTO	Developer VALUES	(6, 'Tripod Studios', 20, 'Indie', 'Japan');
INSERT INTO	Developer VALUES	(7, 'Duoyi Games', 6, 'Indie', 'China');
INSERT INTO Developer VALUES	(8, 'Gearbox Publications', 1300, 'Studio', 'USA');

INSERT INTO	Game VALUES	(1, 'Red Dead Redemption 2', 30, 1);
INSERT INTO	Game VALUES	(2, 'FIFA 23', 89.99, 5);
INSERT INTO	Game VALUES	(3, 'Lost Ark', 0.00, 6);
INSERT INTO	Game VALUES	(4, 'Gunfire Reborn', 24.99, 7);
INSERT INTO	Game VALUES	(5, 'Risk of Rain 2', 27.99, 8);
INSERT INTO	Game VALUES	(6, 'Rogue Legacy 2', 27.99, 8);
INSERT INTO	Game VALUES	(7, 'Dead Cells', 27.99, 8);
INSERT INTO	Game VALUES	(8, 'Enter the Gungeon', 27.99, 8);
INSERT INTO	Game VALUES	(9, 'Spelunky', 27.99, 8);
INSERT INTO GAME VALUES (10, 'Faster Than Light', 10.98, 8);
INSERT INTO	Game VALUES	(11, 'NHL 23', 89.99, 5);
INSERT INTO	Game VALUES	(12, 'NHL 22', 89.99, 5);
INSERT INTO	Game VALUES	(13, 'MLB The Show 23', 89.99, 5);
INSERT INTO	Game VALUES	(14, 'NBA 2K22', 89.99, 5);
INSERT INTO GAME VALUES (15, 'FIFA 22', 89.99, 5);





INSERT INTO Genre VALUES	('Sport', '11/2/1989', 4);
INSERT INTO Genre VALUES	('First-Person Shooter', '07/15/2001',5);
INSERT INTO Genre VALUES	('Sandbox', '02/29/1991', 5);
INSERT INTO Genre VALUES	('Role-Playing', '05/08/2005', 4);
INSERT INTO Genre VALUES	('Horror', '07/07/2000', 3);
INSERT INTO Genre VALUES	('Rogue Like', '06/21/1980', 9);

INSERT INTO IsOf Values ('11/2/1989', 2, 'Sport');
INSERT INTO IsOf Values ('11/2/1989', 11, 'Sport');
INSERT INTO IsOf Values ('11/2/1989', 12, 'Sport');
INSERT INTO IsOf Values ('11/2/1989', 13, 'Sport');
INSERT INTO IsOf Values ('11/2/1989', 14, 'Sport');
INSERT INTO IsOf Values ('11/2/1989', 15, 'Sport');
INSERT INTO IsOf Values ('07/15/2001', 4,'First-Person Shooter');
INSERT INTO IsOf Values ('02/29/1991', 1,'Sandbox');
INSERT INTO IsOf Values ('05/08/2005', 3,'Role-Playing');
INSERT INTO IsOf Values ('06/21/1980', 5,'Rogue Like');
INSERT INTO IsOf Values ('06/21/1980', 6,'Rogue Like');
INSERT INTO IsOf Values ('06/21/1980', 7,'Rogue Like');
INSERT INTO IsOf Values ('06/21/1980', 8,'Rogue Like');
INSERT INTO IsOf Values ('06/21/1980', 9,'Rogue Like');
INSERT INTO IsOf Values ('06/21/1980', 10,'Rogue Like');


INSERT INTO	Customer VALUES	('Roy-Boy', 'Roy Tao', 1234567890);
INSERT INTO	Customer VALUES	('orangeballs', 'Jerry Wang', 2345678901);
INSERT INTO	Customer VALUES	('jerome_ac24', 'Jerome Ah Ching', 3456789012);
INSERT INTO	Customer VALUES	('MorningStarX', 'John Doe', 4567890123);
INSERT INTO	Customer VALUES	('PrimeMaster_', 'Jane Smith', 5678901234);

INSERT INTO	Rating VALUES	(1, 5, 'Great story and amazing gameplay', 1, 'jerome_ac24');
INSERT INTO	Rating VALUES	(2, 1, 'Same game as every year, pace is everything', 2, 'jerome_ac24');
INSERT INTO	Rating VALUES	(3, 4, 'Good dose of nostalgia, but nothing groundbreaking', 4, 'jerome_ac24');
INSERT INTO	Rating VALUES	(4, 5, 'Kept me hooked from start to end, opened my eyes to how good roguelikes can be', 5, 'Roy-Boy');
INSERT INTO	Rating VALUES	(5, 1, 'Played for 100 hours, really bad game', 3, 'orangeballs');
INSERT INTO	Rating VALUES	(6, 4, 'This is an ok game', 3, 'jerome_ac24');
INSERT INTO	Rating VALUES	(7, 3, 'Nothing to ride home about', 5, 'jerome_ac24');
INSERT INTO	Rating VALUES	(8, 2, 'The most meh game ever', 6, 'jerome_ac24');
INSERT INTO	Rating VALUES	(9, 5, 'A true masterpiece', 7, 'jerome_ac24');
INSERT INTO	Rating VALUES	(10, 1, 'Would not play again', 8, 'jerome_ac24');
INSERT INTO	Rating VALUES	(11, 2, 'This is a decent game, but way too laggy', 9, 'jerome_ac24');
INSERT INTO	Rating VALUES	(12, 3, 'Would play again if very bored', 10, 'jerome_ac24');
INSERT INTO	Rating VALUES	(13, 4, 'Fun all around, but nothing truly great', 11, 'jerome_ac24');
INSERT INTO	Rating VALUES	(14, 1, 'Would burn the CD', 12, 'jerome_ac24');
INSERT INTO	Rating VALUES	(15, 4, 'Mostly decent, great at times', 13, 'jerome_ac24');
INSERT INTO	Rating VALUES	(16, 5, 'Would recommend to anyone', 14, 'jerome_ac24');
INSERT INTO	Rating VALUES	(17, 2, 'Drop the ball hard', 15, 'jerome_ac24');

INSERT INTO About VALUES(2, 1);
INSERT INTO About VALUES(1, 3);
INSERT INTO About VALUES(1, 4);
INSERT INTO About VALUES(5, 2);
INSERT INTO About VALUES(3, 2);

INSERT INTO Retailer VALUES (1);
INSERT INTO Retailer VALUES (2);
INSERT INTO Retailer VALUES (3);
INSERT INTO Retailer VALUES (4);
INSERT INTO Retailer VALUES (5);
INSERT INTO Retailer VALUES (6);
INSERT INTO Retailer VALUES (7);
INSERT INTO Retailer VALUES (8);
INSERT INTO Retailer VALUES (9);
INSERT INTO Retailer VALUES (10);

INSERT INTO BuysFrom VALUES('jerome_ac24', 1);
INSERT INTO BuysFrom VALUES('jerome_ac24', 4);
INSERT INTO BuysFrom VALUES('jerome_ac24', 2);
INSERT INTO BuysFrom VALUES('jerome_ac24', 9);
INSERT INTO BuysFrom VALUES('jerome_ac24', 3);


CREATE TABLE Device (
	DeviceID INT,
	ReleaseYear INT,
	Model CHAR(20),
	Username CHAR(20) NOT NULL,
	PRIMARY KEY	(DeviceID, Username),
	FOREIGN KEY	(Username) REFERENCES Customer ON DELETE CASCADE
	);

grant select on Device to public;


CREATE TABLE Run (
	GameID INT,	
	DeviceID INT,
	Username CHAR(20),
	PRIMARY KEY	(GameID, DeviceID, Username),
	FOREIGN KEY	(GameID) REFERENCES	Game ON DELETE CASCADE,
	FOREIGN KEY	(DeviceID, Username) REFERENCES	Device(DeviceID, Username) ON DELETE CASCADE
);

grant select on Run to public;

CREATE TABLE Stocks (
	Quantity	INT,
	RetailerID	INT,
	GameID	INT,
	PRIMARY KEY	(GameID, RetailerID),
	FOREIGN KEY	(GameID) REFERENCES	Game ON DELETE CASCADE,
	FOREIGN KEY	(RetailerID) REFERENCES Retailer ON DELETE CASCADE
);

grant select on Stocks to public;




INSERT INTO	Physical_R VALUES	(1, '798 Granville St Suite 200', 'Vancouver', 'V6Z3C3');
INSERT INTO	Physical_R VALUES	(2, '2220 Cambie St', 'Vancouver', 'V5Z2T7');
INSERT INTO	Physical_R VALUES	(3, '65 Dundas St W', 'Toronto', 'M5G2C3');
INSERT INTO	Physical_R VALUES	(4, '457 W 8th Ave #10', 'Vancouver', 'V5Y3Z5');
INSERT INTO	Physical_R VALUES	(5, '677 Saint-Catherine St W', 'Montreal', 'H3V5K4');

INSERT INTO Online_R VALUES	(6, 'https://store.steampowered.com/');
INSERT INTO Online_R VALUES	(7, 'https://store.epicgames.com/en-US/');
INSERT INTO Online_R VALUES	(8, 'https://www.xbox.com/en-CA/microsoft-store');
INSERT INTO Online_R VALUES	(9, 'https://store.playstation.com/en-ca/pages/latest');
INSERT INTO Online_R VALUES	(10, 'https://www.nintendo.com/en-ca/');

INSERT INTO	Device VALUES	(1, 2013, 'Xbox One', 'jerome_ac24');
INSERT INTO	Device VALUES	(2, 2017, 'Nintendo Switch', 'jerome_ac24');
INSERT INTO	Device VALUES	(3, 1974, 'PC', 'orangeballs');
INSERT INTO	Device VALUES	(4, 2020, 'Playstation 5', 'Roy-Boy');
INSERT INTO	Device VALUES	(5, 2019,  'Google Stadia', 'Roy-Boy');

INSERT INTO Run VALUES (1, 1, 'jerome_ac24');
INSERT INTO Run VALUES (2, 2, 'jerome_ac24');
INSERT INTO Run VALUES (3, 3, 'orangeballs');
INSERT INTO Run VALUES (4, 4, 'Roy-Boy');
INSERT INTO Run VALUES (5, 5, 'Roy-Boy');

INSERT INTO Stocks VALUES (1000, 1, 1);
INSERT INTO Stocks VALUES (2000, 2, 2);
INSERT INTO Stocks VALUES (1000, 3, 3);
INSERT INTO Stocks VALUES (7900, 4, 4);
INSERT INTO Stocks VALUES (5300, 5, 5);
INSERT INTO Stocks VALUES (50, 6, 6);
INSERT INTO Stocks VALUES (100, 7, 7);
INSERT INTO Stocks VALUES (23000, 8, 8);
INSERT INTO Stocks VALUES (54340, 9, 9);
INSERT INTO Stocks VALUES (390, 10, 10);
