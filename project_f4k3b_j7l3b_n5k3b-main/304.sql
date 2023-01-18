DROP TABLE Stocks;
DROP TABLE Run;
DROP TABLE Game;
DROP TABLE Device;
DROP TABLE Online_R;
DROP TABLE Physical_R;
DROP TABLE Retailer;
DROP TABLE Customer;

CREATE TABLE Customer (
	Username CHAR(20),
	C_Name CHAR(20),
	Phone# INT,
    PRIMARY KEY (Username),
	UNIQUE(Phone#)
);

grant select on Customer to public;

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

CREATE TABLE Device (
	DeviceID INT,
	ReleaseYear INT,
	Model CHAR(20),
	Username CHAR(20) NOT NULL,
	PRIMARY KEY	(DeviceID, Username),
	FOREIGN KEY	(Username) REFERENCES Customer ON DELETE CASCADE
	);

grant select on Device to public;

CREATE TABLE Game (
	GameID INT not null,
	G_Title	CHAR(100),
	Price	FLOAT,
	DeveloperID	INT not null,
	primary key(GameID),
	FOREIGN KEY	(DeveloperID) references Developer ON DELETE CASCADE,
	UNIQUE(G_Title)
);

grant select on Game to public;

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

-- CREATE TABLE Rating (
-- 	RatingID		INT,
-- 	Stars			INT,
-- 	Title			CHAR(100) 
-- 	Game			INT NOT NULL,
-- 	R_Username		CHAR(20) NOT NULL,
-- 	PRIMARY KEY	(RatingID, R_Username),
-- 	FOREIGN KEY	(Title)	REFERENCES	Game(GameID) ON DELETE CASCADE ON UPDATE CASCADE,
-- 	FOREIGN KEY	(R_Username) REFERENCES Customer(R_Username) ON DELETE CASCADE ON UPDATE CASCADE,
-- 	UNIQUE(Title)
-- );

-- CREATE TABLE Genre (
-- 	G_Name			CHAR(20),
-- 	TagCreationDate	CHAR(20),
-- 	Popularity		INT
-- 	PRIMARY KEY (Name, TagCreationDate)
-- );

-- CREATE TABLE Game (
-- 	GameID		INT	PRIMARY KEY,
-- 	Title		CHAR(100),
-- 	Price		FLOAT,
-- 	Genre		CHAR(20),
-- 	DeveloperID	INT	NOT NULL,
-- 	FOREIGN KEY	(DeveloperID) REFERENCES Developer(DeveloperID) ON DELETE CASCADE ON UPDATE CASCADE,
-- 	UNIQUE(Title)
-- 	);

-- CREATE TABLE Developer (
--     DeveloperID INT not null,
-- 	D_Name varchar(40) not null,
-- 	NumOfEmployees int not null,
-- 	D_Type char(40),
-- 	Country varchar(40),
--     primary key (DeveloperID),
-- 	UNIQUE (D_Name)
-- 	);
 
-- grant select on Developer to public;

-- CREATE TABLE About (
-- 	RatingID		INT,		
-- 	GameID		INT,
-- 	PRIMARY KEY	(RatingID, GameID),
-- 	FOREIGN KEY	(RatingID)	REFERENCES	Rating(RatingID),
-- 	FOREIGN KEY	(GameID)	REFERENCES	Game(GameID),
-- 		ON DELETE CASCADE,
-- 		ON UPDATE CASCADE
-- 	);

-- CREATE TABLE BuysFrom (
-- 	B_Username	CHAR(20),
-- 	RetailerID	INT,
-- 	PRIMARY KEY	(B_Username, RetailerID),
-- 	FOREIGN KEY	(B_Username)	REFERENCES	Customer(C_Username),
-- 		ON DELETE CASCADE,
-- 		ON UPDATE CASCADE,
-- 	FOREIGN KEY	(RetailerID)	REFERENCES	Retailer(RetailerID),
-- 		ON DELETE CASCADE,
-- 		ON UPDATE CASCADE
-- 	);




-- CREATE TABLE IsOf (
-- 	TagCreationDate	CHAR(20),
-- 	GameID		    INT NOT NULL,
-- 	Name		    CHAR(20),
-- 	PRIMARY KEY	    (TagCreationDate, GameID, Name)
-- 	FOREIGN KEY	    (TagCreationDate)	REFERENCES 	Genre(TagCreationDate),
-- 	FOREIGN KEY	    (Name)	REFERENCES 	Genre(Name),
-- 		ON DELETE CASCADE,
-- 		ON UPDATE CASCADE,
-- 	FOREIGN KEY	    (GameID)REFERENCES	Game(GameID),
-- 		ON DELETE CASCADE,
-- 		ON UPDATE CASCADE
-- );

INSERT INTO	Customer VALUES	('Roy-Boy', 'Roy Tao', 1234567890);
INSERT INTO	Customer VALUES	('orangeballs', 'Jerry Wang', 2345678901);
INSERT INTO	Customer VALUES	('jerome_ac24', 'Jerome Ah Ching', 3456789012);
INSERT INTO	Customer VALUES	('MorningStarX', 'John Doe', 4567890123);
INSERT INTO	Customer VALUES	('PrimeMaster_', 'Jane Smith', 5678901234);

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

INSERT INTO	Game VALUES	(1, 'Red Dead Redemption 2', 30, 1);
INSERT INTO	Game VALUES	(2,  'FIFA 23', 89.99, 5);
INSERT INTO	Game VALUES	(3,  'Lost Ark', 0.00, 6);
INSERT INTO	Game VALUES	(4, 'Gunfire Reborn', 24.99, 7);
INSERT INTO	Game VALUES	(5, 'Risk of Rain 2', 27.99, 8);

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

-- INSERT INTO	Rating VALUES	(1, 5, 'Great story and amazing gameplay', 1, 'Jerome Ah Ching');
-- INSERT INTO	Rating VALUES	(2, 1, 'Same game as every year, pace is everything', 2, 'Jerome Ah Ching');
-- INSERT INTO	Rating VALUES	(3, 4, 'Good dose of nostalgia, but nothing groundbreaking', 6, 'Jerome Ah Ching');
-- INSERT INTO	Rating VALUES	(4, 5, 'Kept me hooked from start to end, opened my eyes to how good roguelikes can be', 5, 'Roy Tao');
-- INSERT INTO	Rating VALUES	(5, 1, 'Played for 100 hours, really bad game', 3, Jerry Wang);

-- INSERT INTO Genre VALUES	('Sport', '11/2/1989', 4);
-- INSERT INTO Genre VALUES	('First-Person Shooter', '07/15/2001', 5);
-- INSERT INTO Genre VALUES	('Sandbox', '02/29/1991', 5);
-- INSERT INTO Genre VALUES	('Role-Playing', '05/08/2005', 4);
-- INSERT INTO Genre VALUES	('Horror', '07/07/2000', 3);

-- INSERT INTO	Developer VALUES	(1, 'Rockstar Games', 2000, 'Studio', 'USA');
-- INSERT INTO	Developer VALUES	(2, 'Activision-Blizzard', 9800, 'Studio', 'USA');
-- INSERT INTO	Developer VALUES	(3, 'Game Freak', 169, 'Studio',  'Japan');
-- INSERT INTO	Developer VALUES	(4, 'Gattai Games', 10, 'Indie', 'Singapore');
-- INSERT INTO	Developer VALUES	(5, 'EA', 12000, 'Studio',  'USA');
-- INSERT INTO	Developer VALUES	(6, 'Tripod Studios', 20, 'Indie', 'Japan');
-- INSERT INTO	Developer VALUES	(7, 'Duoyi Games', 6, 'Indie', 'China');
-- INSERT INTO Developer VALUES	(8, 'Gearbox Publications', 1300, 'Studio', 'USA');

-- INSERT INTO IsOf Values ('05/08/2005', 3);
-- INSERT INTO IsOf Values ('11/2/1989', 2);
-- INSERT INTO isOf Values ('07/15/2001', 1);
-- INSERT INTO isOf Values ('07/15/2001', 4);
-- INSERT INTO isOf Values ('02/29/1991', 5);

-- INSERT INTO About (2, 1);
-- INSERT INTO About (1, 3);
-- INSERT INTO About (1, 4);
-- INSERT INTO About (5, 2);
-- INSERT INTO About (3, 2);

-- INSERT INTO BuysFrom (1, 1);
-- INSERT INTO BuysFrom (2, 3);
-- INSERT INTO BuysFrom (5, 2);
-- INSERT INTO BuysFrom (3, 1);
-- INSERT INTO BuysFrom (4, 3);