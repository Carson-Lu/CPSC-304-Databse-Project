-- Dropping all tables
-- Code taken from: https://stackoverflow.com/questions/1690404/how-to-drop-all-user-tables

BEGIN
    FOR cur_rec IN (SELECT object_name, object_type
                    FROM user_objects
                    WHERE object_type IN
                          ('TABLE',
                           'VIEW',
                           'MATERIALIZED VIEW',
                           'PACKAGE',
                           'PROCEDURE',
                           'FUNCTION',
                           'SEQUENCE',
                           'SYNONYM',
                           'PACKAGE BODY'
                              ))
        LOOP
            BEGIN
                IF cur_rec.object_type = 'TABLE'
                THEN
                    EXECUTE IMMEDIATE 'DROP '
                        || cur_rec.object_type
                        || ' "'
                        || cur_rec.object_name
                        || '" CASCADE CONSTRAINTS';
                ELSE
                    EXECUTE IMMEDIATE 'DROP '
                        || cur_rec.object_type
                        || ' "'
                        || cur_rec.object_name
                        || '"';
                END IF;
            EXCEPTION
                WHEN OTHERS
                    THEN
                        DBMS_OUTPUT.put_line('FAILED: DROP '
                            || cur_rec.object_type
                            || ' "'
                            || cur_rec.object_name
                            || '"'
                            );
            END;
        END LOOP;
    FOR cur_rec IN (SELECT *
                    FROM all_synonyms
                    WHERE table_owner IN (SELECT USER FROM dual))
        LOOP
            BEGIN
                EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ' || cur_rec.synonym_name;
            END;
        END LOOP;
END;
/

-- Creating tables
-- NOTE: UserData used to be called User but sql*plus does not like that so the name was changed
CREATE TABLE UserData
(
    Email       varchar2(50) PRIMARY KEY,
    FirstName   varchar2(50),
    LastName    varchar2(50),
    Age         integer,
    Country     varchar2(60),
    PhoneNumber integer UNIQUE
);

CREATE TABLE OnlineService
(
    ServiceProvider varchar2(50) PRIMARY KEY
);


-- NOTE DEVICE DECOMPOSED INTO TWO TABLES (they have been renamed from the decomposition):

CREATE TABLE DeviceOS
(
    OperatingSystem varchar2(50) PRIMARY KEY,
    Platform        varchar2(50)
);

CREATE TABLE DeviceModel
(
    ModelNumber     integer,
    Brand           varchar2(50),
    Year            integer,
    OperatingSystem varchar2(50),
    PRIMARY KEY (ModelNumber, Brand)
);

-- DECOMPOSED SUBSCRIPTION TABLES:
CREATE TABLE SubscriptionCosts
(
    BillingFrequency varchar2(50),
    CostPerPayment   number(*, 2),
    YearlyCost       number(*, 2),
    PRIMARY KEY (BillingFrequency, CostPerPayment)
);

CREATE TABLE SubscriptionProvider
(
    ServiceProvider  varchar2(50),
    BillingFrequency varchar2(50),
    CostPerPayment   number(*, 2),
    PRIMARY KEY (ServiceProvider, BillingFrequency, CostPerPayment),
    FOREIGN KEY (ServiceProvider) REFERENCES OnlineService (ServiceProvider)
);

-- SERVICE DATA CONTAINS DECOMPOSED TABLES:
CREATE TABLE ServiceDataContainsVersion
(
    Month   integer,
    Year    integer,
    Version varchar2(10),
    PRIMARY KEY (Month, Year)
);

CREATE TABLE ServiceDataContainsCost
(
    MonthlyCost    integer,
    MonthlyRevenue integer,
    MonthlyProfit  integer,
    PRIMARY KEY (MonthlyCost, MonthlyRevenue)
);

CREATE TABLE ServiceDataContainsProvider
(
    ServiceProvider varchar2(50),
    Version         varchar2(10),
    MonthlyUsers    integer,
    MonthlyCosts    integer,
    MonthlyRevenue  integer,
    Year            integer,
    Month           integer,
    PRIMARY KEY (ServiceProvider, Version),
    FOREIGN KEY (ServiceProvider) REFERENCES OnlineService (ServiceProvider)
);

CREATE TABLE SubscribesTo
(
    Email            varchar2(50),
    ServiceProvider  varchar2(50),
    BillingFrequency varchar2(50),
    CostPerPayment   number(*, 2),
    YearlyCost       number(*, 2),
    PRIMARY KEY (Email, ServiceProvider, BillingFrequency, CostPerPayment),
    FOREIGN KEY (Email) REFERENCES UserData (Email),
    FOREIGN KEY (ServiceProvider) REFERENCES OnlineService (ServiceProvider),
    FOREIGN KEY (ServiceProvider, BillingFrequency, CostPerPayment) REFERENCES SubscriptionProvider (ServiceProvider, BillingFrequency, CostPerPayment)
);

-- REVIEW DECOMPOSED TABLES:
CREATE TABLE ReviewDetails
(
    ReviewID integer PRIMARY KEY,
    Rating   integer
);

CREATE TABLE ReviewOverview
(
    Email           varchar2(50),
    ReviewID        integer,
    ServiceProvider varchar2(50),
    PRIMARY KEY (Email, ReviewID),
    FOREIGN KEY (Email) REFERENCES UserData (Email),
    FOREIGN KEY (ServiceProvider) REFERENCES OnlineService (ServiceProvider)
        ON DELETE SET NULL
);


CREATE TABLE MusicService
(
    ServiceProvider  varchar2(50) PRIMARY KEY,
    MusicServiceName varchar2(50) UNIQUE NOT NULL,
    FOREIGN KEY (ServiceProvider) REFERENCES OnlineService (ServiceProvider)
);

CREATE TABLE MovieService
(
    ServiceProvider  varchar2(50) PRIMARY KEY,
    MovieServiceName varchar2(50) UNIQUE NOT NULL,
    FOREIGN KEY (ServiceProvider) REFERENCES OnlineService (ServiceProvider)
);

CREATE TABLE GameService
(
    ServiceProvider varchar2(50) PRIMARY KEY,
    GameServiceName varchar2(50) UNIQUE NOT NULL,
    FOREIGN KEY (ServiceProvider) REFERENCES OnlineService (ServiceProvider)
);

CREATE TABLE Artist
(
    ArtistName varchar2(50) PRIMARY KEY
);

CREATE TABLE MovieCompany
(
    MCompanyName varchar2(50) PRIMARY KEY
);

CREATE TABLE Developer
(
    DevName varchar2(50) PRIMARY KEY
);

CREATE TABLE Song
(
    SongName  varchar2(50),
    SongYear  integer,
    SongGenre varchar2(50),
    PRIMARY KEY (SongName, SongYear)
);

CREATE TABLE Movie
(
    MovieName    varchar2(50),
    MovieYear    integer,
    MovieGenre   varchar2(50),
    MCompanyName varchar2(50),
    PRIMARY KEY (MovieName, MovieYear),
    FOREIGN KEY (MCompanyName) REFERENCES MovieCompany (MCompanyName)
);

CREATE TABLE VideoGame
(
    GameName  varchar2(50),
    GameYear  integer,
    GameGenre varchar2(50),
    PRIMARY KEY (GameName, GameYear)
);

CREATE TABLE Uses
(
    Email       varchar2(50),
    ModelNumber integer,
    Brand       varchar2(50),
    FOREIGN KEY (Email) REFERENCES UserData (Email),
    FOREIGN KEY (ModelNumber, Brand) REFERENCES DeviceModel (ModelNumber, Brand),
    PRIMARY KEY (Email, ModelNumber, Brand)
);

CREATE TABLE Accesses
(
    ModelNumber     integer,
    Brand           varchar2(50),
    ServiceProvider varchar2(50),
    FOREIGN KEY (ModelNumber, Brand) REFERENCES DeviceModel (ModelNumber, Brand),
    FOREIGN KEY (ServiceProvider) REFERENCES OnlineService (ServiceProvider),
    PRIMARY KEY (ModelNumber, Brand, ServiceProvider)
);


CREATE TABLE Plays
(
    ServiceProvider varchar2(50),
    SongName        varchar2(50),
    SongYear        integer,
    NumPlays        integer,
    PRIMARY KEY (ServiceProvider, SongName, SongYear),
    FOREIGN KEY (ServiceProvider) REFERENCES OnlineService (ServiceProvider),
    FOREIGN KEY (SongName, SongYear) REFERENCES Song (SongName, SongYear)
);

CREATE TABLE Streams
(
    ServiceProvider varchar2(50),
    MovieName       varchar2(50),
    MovieYear       integer,
    NumStreams      integer,
    PRIMARY KEY (ServiceProvider, MovieName, MovieYear),
    FOREIGN KEY (ServiceProvider) REFERENCES OnlineService (ServiceProvider),
    FOREIGN KEY (MovieName, MovieYear) REFERENCES Movie (MovieName, MovieYear)
);

CREATE TABLE Provides
(
    ServiceProvider varchar2(50),
    GameName        varchar2(50),
    GameYear        integer,
    TimePlayed      integer,
    PRIMARY KEY (ServiceProvider, GameName, GameYear),
    FOREIGN KEY (ServiceProvider) REFERENCES OnlineService (ServiceProvider),
    FOREIGN KEY (GameName, GameYear) REFERENCES VideoGame (GameName, GameYear)
);

CREATE TABLE Writes
(
    SongName   varchar2(50),
    SongYear   integer,
    ArtistName varchar2(50),
    PRIMARY KEY (SongName, SongYear, ArtistName),
    FOREIGN KEY (SongName, SongYear) REFERENCES Song (SongName, SongYear),
    FOREIGN KEY (ArtistName) REFERENCES Artist (ArtistName)
);

CREATE TABLE Makes
(
    GameName varchar2(50),
    GameYear integer,
    DevName  varchar2(50),
    PRIMARY KEY (GameName, GameYear, DevName),
    FOREIGN KEY (GameName, GameYear) REFERENCES VideoGame (GameName, GameYear),
    FOREIGN KEY (DevName) REFERENCES DEVELOPER (DevName)
);

-- Adding ON DELETE CASCADE
CREATE OR REPLACE TRIGGER UserDataUpdateForeignKeys
    BEFORE DELETE OR UPDATE
    ON UserData
    FOR EACH ROW
BEGIN
    IF DELETING THEN
        DELETE FROM ReviewOverview WHERE Email = :OLD.Email;
        DELETE
        FROM ReviewDetails
        WHERE ReviewID IN (SELECT ReviewID
                           FROM ReviewOverview
                           WHERE Email = :OLD.Email);
        DELETE FROM Uses WHERE Email = :OLD.Email;
        DELETE FROM SubscribesTo WHERE Email = :OLD.Email;
    END IF;
    IF UPDATING THEN
        UPDATE ReviewOverview
        SET Email = :NEW.Email
        WHERE Email = :OLD.Email;
        UPDATE Uses
        SET Email = :NEW.Email
        WHERE Email = :OLD.Email;
        UPDATE SubscribesTo
        SET Email = :NEW.Email
        WHERE Email = :OLD.Email;
    END IF;
END;
--
-- CREATE OR REPLACE TRIGGER OnlineServiceUpdateForeignKeys
--     BEFORE DELETE OR UPDATE
--     ON OnlineService
--     FOR EACH ROW
-- BEGIN
--     IF DELETING THEN
--         DELETE
--         FROM ServiceDataContainsVersion v
--         WHERE (v.Month, v.Year) IN (SELECT Month, Year
--                                 FROM ServiceDataContainsProvider
--                                 WHERE ServiceProvider = :OLD.ServiceProvider);
--         DELETE
--         FROM ServiceDataContainsCost c
--         WHERE (c.MonthlyCosts, c.MonthlyRevenue) IN (SELECT MonthlyCosts, MonthlyRevenue
--                                                  FROM ServiceDataContainsProvider
--                                                  WHERE ServiceProvider = :OLD.ServiceProvider);
--         DELETE
--         FROM ServiceDataContainsProvider
--         WHERE ServiceProvider = :OLD.ServiceProvider;
--         DELETE
--         FROM SubscriptionProvider
--         WHERE ServiceProvider = :OLD.ServiceProvider;
--     END IF;
--
--     IF UPDATING THEN
--         UPDATE ServiceDataContainsProvider
--         SET ServiceProvider = :NEW.ServiceProvider
--         WHERE ServiceProvider = :OLD.ServiceProvider;
--     END IF;
-- END;


--Creating Inserts

INSERT INTO UserData (Email, FirstName, LastName, Age, Country, PhoneNumber)
VALUES ('JohnDoe@gmail.com', 'John', 'Doe', 25, 'United States', 1234567890);
INSERT INTO UserData (Email, FirstName, LastName, Age, Country, PhoneNumber)
VALUES ('JaneSmith@outlook.com', 'Jane', 'Smith', 30, 'Canada', 9876543210);
INSERT INTO UserData (Email, FirstName, LastName, Age, Country, PhoneNumber)
VALUES ('MichaelJohnson@hotmail.com', 'Michael', 'Johnson', 40, 'Australia', 5678901234);
INSERT INTO UserData (Email, FirstName, LastName, Age, Country, PhoneNumber)
VALUES ('EmilyBrown@yahoo.com', 'Emily', 'Brown', 35, 'United Kingdom', 9012345678);
INSERT INTO UserData (Email, FirstName, LastName, Age, Country, PhoneNumber)
VALUES ('DavidWilson@webmail.com', 'David', 'Wilson', 28, 'Germany', 3456789012);

-- Music Service Providers
INSERT INTO OnlineService (ServiceProvider)
VALUES ('Spotify');
INSERT INTO OnlineService (ServiceProvider)
VALUES ('Tidal');
INSERT INTO OnlineService (ServiceProvider)
VALUES ('Deezer');
INSERT INTO OnlineService (ServiceProvider)
VALUES ('Pandora');

-- Music and Movie Service Providers
INSERT INTO OnlineService (ServiceProvider)
VALUES ('Amazon Prime');

-- Movie Service Providers
INSERT INTO OnlineService (ServiceProvider)
VALUES ('Netflix');
INSERT INTO OnlineService (ServiceProvider)
VALUES ('Hulu');
INSERT INTO OnlineService (ServiceProvider)
VALUES ('Disney+');
INSERT INTO OnlineService (ServiceProvider)
VALUES ('HBO Max');

-- Game Service Providers
INSERT INTO OnlineService (ServiceProvider)
VALUES ('Steam');
INSERT INTO OnlineService (ServiceProvider)
VALUES ('Epic Games');
INSERT INTO OnlineService (ServiceProvider)
VALUES ('Origin');
INSERT INTO OnlineService (ServiceProvider)
VALUES ('Xbox Game Pass');
INSERT INTO OnlineService (ServiceProvider)
VALUES ('PlayStation Now');

INSERT INTO DeviceOS (OperatingSystem, Platform)
VALUES ('iOS', 'Mobile');
INSERT INTO DeviceOS (OperatingSystem, Platform)
VALUES ('Windows', 'PC');
INSERT INTO DeviceOS (OperatingSystem, Platform)
VALUES ('Android', 'Mobile');
INSERT INTO DeviceOS (OperatingSystem, Platform)
VALUES ('macOS', 'PC');
INSERT INTO DeviceOS (OperatingSystem, Platform)
VALUES ('Linux', 'PC');

INSERT INTO DeviceModel (ModelNumber, Brand, Year, OperatingSystem)
VALUES (12345, 'Samsung', 2022, 'Android');
INSERT INTO DeviceModel (ModelNumber, Brand, Year, OperatingSystem)
VALUES (54321, 'Google', 2023, 'Linux');
INSERT INTO DeviceModel (ModelNumber, Brand, Year, OperatingSystem)
VALUES (67890, 'Apple', 2021, 'iOs');
INSERT INTO DeviceModel (ModelNumber, Brand, Year, OperatingSystem)
VALUES (98765, 'Microsoft', 2020, 'macOS');
INSERT INTO DeviceModel (ModelNumber, Brand, Year, OperatingSystem)
VALUES (23456, 'Sony', 2022, 'Windows');

INSERT INTO SubscriptionCosts (BillingFrequency, CostPerPayment, YearlyCost)
VALUES ('Monthly', 9.99, 119.88);
INSERT INTO SubscriptionCosts (BillingFrequency, CostPerPayment, YearlyCost)
VALUES ('Quarterly', 24.99, 99.96);
INSERT INTO SubscriptionCosts (BillingFrequency, CostPerPayment, YearlyCost)
VALUES ('Yearly', 89.99, 89.99);
INSERT INTO SubscriptionCosts (BillingFrequency, CostPerPayment, YearlyCost)
VALUES ('Monthly', 12.99, 155.88);
INSERT INTO SubscriptionCosts (BillingFrequency, CostPerPayment, YearlyCost)
VALUES ('Yearly', 49.99, 49.99);

INSERT INTO SubscriptionProvider (ServiceProvider, BillingFrequency, CostPerPayment)
VALUES ('Netflix', 'Monthly', 9.99);
INSERT INTO SubscriptionProvider (ServiceProvider, BillingFrequency, CostPerPayment)
VALUES ('Hulu', 'Monthly', 11.99);
INSERT INTO SubscriptionProvider (ServiceProvider, BillingFrequency, CostPerPayment)
VALUES ('Amazon Prime', 'Yearly', 119.00);
INSERT INTO SubscriptionProvider (ServiceProvider, BillingFrequency, CostPerPayment)
VALUES ('Disney+', 'Yearly', 79.99);
INSERT INTO SubscriptionProvider (ServiceProvider, BillingFrequency, CostPerPayment)
VALUES ('Xbox Game Pass', 'Monthly', 9.99);

INSERT INTO ReviewDetails (ReviewID, Rating)
VALUES (1, 4);
INSERT INTO ReviewDetails (ReviewID, Rating)
VALUES (2, 5);
INSERT INTO ReviewDetails (ReviewID, Rating)
VALUES (3, 3);
INSERT INTO ReviewDetails (ReviewID, Rating)
VALUES (4, 4);
INSERT INTO ReviewDetails (ReviewID, Rating)
VALUES (5, 2);

INSERT INTO ReviewOverview (Email, ReviewID, ServiceProvider)
VALUES ('JohnDoe@gmail.com', 1, 'Netflix');
INSERT INTO ReviewOverview (Email, ReviewID, ServiceProvider)
VALUES ('JaneSmith@outlook.com', 2, 'Amazon Prime');
INSERT INTO ReviewOverview (Email, ReviewID, ServiceProvider)
VALUES ('MichaelJohnson@hotmail.com', 3, 'Hulu');
INSERT INTO ReviewOverview (Email, ReviewID, ServiceProvider)
VALUES ('EmilyBrown@yahoo.com', 4, 'Disney+');
INSERT INTO ReviewOverview (Email, ReviewID, ServiceProvider)
VALUES ('DavidWilson@webmail.com', 5, 'Spotify');

INSERT INTO ServiceDataContainsVersion (Month, Year, Version)
VALUES (1, 2023, '1.0');
INSERT INTO ServiceDataContainsVersion (Month, Year, Version)
VALUES (2, 2023, '1.1');
INSERT INTO ServiceDataContainsVersion (Month, Year, Version)
VALUES (3, 2023, '1.2');
INSERT INTO ServiceDataContainsVersion (Month, Year, Version)
VALUES (4, 2023, '1.3');
INSERT INTO ServiceDataContainsVersion (Month, Year, Version)
VALUES (5, 2023, '1.4');

INSERT INTO ServiceDataContainsCost (MonthlyCost, MonthlyRevenue, MonthlyProfit)
VALUES (1000, 5000, 4000);
INSERT INTO ServiceDataContainsCost (MonthlyCost, MonthlyRevenue, MonthlyProfit)
VALUES (1500, 6000, 4500);
INSERT INTO ServiceDataContainsCost (MonthlyCost, MonthlyRevenue, MonthlyProfit)
VALUES (1200, 5500, 4300);
INSERT INTO ServiceDataContainsCost (MonthlyCost, MonthlyRevenue, MonthlyProfit)
VALUES (1800, 7000, 5200);
INSERT INTO ServiceDataContainsCost (MonthlyCost, MonthlyRevenue, MonthlyProfit)
VALUES (900, 4500, 3600);
INSERT INTO ServiceDataContainsCost (MonthlyCost, MonthlyRevenue, MonthlyProfit)
VALUES (1000, 6000, 5000);

INSERT INTO ServiceDataContainsProvider (ServiceProvider, Version, MonthlyUsers, MonthlyCosts, MonthlyRevenue, Year,
                                         Month)
VALUES ('Netflix', '1.0', 100000, 1000, 5000, 2023, 1);
INSERT INTO ServiceDataContainsProvider (ServiceProvider, Version, MonthlyUsers, MonthlyCosts, MonthlyRevenue, Year,
                                         Month)
VALUES ('Hulu', '1.0', 80000, 1500, 6000, 2023, 2);
INSERT INTO ServiceDataContainsProvider (ServiceProvider, Version, MonthlyUsers, MonthlyCosts, MonthlyRevenue, Year,
                                         Month)
VALUES ('Amazon Prime', '1.0', 120000, 1200, 5500, 2023, 3);
INSERT INTO ServiceDataContainsProvider (ServiceProvider, Version, MonthlyUsers, MonthlyCosts, MonthlyRevenue, Year,
                                         Month)
VALUES ('Disney+', '1.0', 90000, 1800, 7000, 2023, 4);
INSERT INTO ServiceDataContainsProvider (ServiceProvider, Version, MonthlyUsers, MonthlyCosts, MonthlyRevenue, Year,
                                         Month)
VALUES ('Spotify', '1.0', 110000, 900, 4500, 2023, 5);
INSERT INTO ServiceDataContainsProvider (ServiceProvider, Version, MonthlyUsers, MonthlyCosts, MonthlyRevenue, Year,
                                         Month)
VALUES ('Spotify', '1.1', 230000, 1000, 6000, 2023, 5);

INSERT INTO MusicService (ServiceProvider, MusicServiceName)
VALUES ('Spotify', 'Spotify Music');
INSERT INTO MusicService (ServiceProvider, MusicServiceName)
VALUES ('Amazon Prime', 'Amazon Prime Music');
INSERT INTO MusicService (ServiceProvider, MusicServiceName)
VALUES ('Tidal', 'Tidal Music');
INSERT INTO MusicService (ServiceProvider, MusicServiceName)
VALUES ('Deezer', 'Deezer Music');
INSERT INTO MusicService (ServiceProvider, MusicServiceName)
VALUES ('Pandora', 'Pandora Music');

INSERT INTO MovieService (ServiceProvider, MovieServiceName)
VALUES ('Netflix', 'Netflix Movies');
INSERT INTO MovieService (ServiceProvider, MovieServiceName)
VALUES ('Amazon Prime', 'Amazon Prime Video');
INSERT INTO MovieService (ServiceProvider, MovieServiceName)
VALUES ('Hulu', 'Hulu Movies');
INSERT INTO MovieService (ServiceProvider, MovieServiceName)
VALUES ('Disney+', 'Disney+ Movies');
INSERT INTO MovieService (ServiceProvider, MovieServiceName)
VALUES ('HBO Max', 'HBO Max Movies');

INSERT INTO GameService (ServiceProvider, GameServiceName)
VALUES ('Steam', 'Steam Games');
INSERT INTO GameService (ServiceProvider, GameServiceName)
VALUES ('Epic Games', 'Epic Games Store');
INSERT INTO GameService (ServiceProvider, GameServiceName)
VALUES ('Origin', 'Origin Games');
INSERT INTO GameService (ServiceProvider, GameServiceName)
VALUES ('Xbox Game Pass', 'Xbox Game Pass');
INSERT INTO GameService (ServiceProvider, GameServiceName)
VALUES ('PlayStation Now', 'PlayStation Now Games');

INSERT INTO Song (SongName, SongYear, SongGenre)
VALUES ('Song 1', 2020, 'Pop');
INSERT INTO Song (SongName, SongYear, SongGenre)
VALUES ('Song 2', 2019, 'Rock');
INSERT INTO Song (SongName, SongYear, SongGenre)
VALUES ('Song 3', 2021, 'Hip Hop');
INSERT INTO Song (SongName, SongYear, SongGenre)
VALUES ('Song 4', 2018, 'Hip Hop');
INSERT INTO Song (SongName, SongYear, SongGenre)
VALUES ('Song 5', 2018, 'Hip Hop');

INSERT INTO MovieCompany (MCompanyName)
VALUES ('Warner Bros.');
INSERT INTO MovieCompany (MCompanyName)
VALUES ('Universal Pictures');
INSERT INTO MovieCompany (MCompanyName)
VALUES ('Columbia Pictures');
INSERT INTO MovieCompany (MCompanyName)
VALUES ('Walt Disney Pictures');
INSERT INTO MovieCompany (MCompanyName)
VALUES ('Marvel Studios');

INSERT INTO Movie (MovieName, MovieYear, MovieGenre, MCompanyName)
VALUES ('Ready Player One', 2020, 'Sci-fi', 'Warner Bros.');
INSERT INTO Movie (MovieName, MovieYear, MovieGenre, MCompanyName)
VALUES ('Jurrasic World', 2019, 'Action', 'Universal Pictures');
INSERT INTO Movie (MovieName, MovieYear, MovieGenre, MCompanyName)
VALUES ('Skyfall', 2021, 'Drama', 'Columbia Pictures');
INSERT INTO Movie (MovieName, MovieYear, MovieGenre, MCompanyName)
VALUES ('Pokémon Detective Pikachu', 2018, 'Adventure', 'Warner Bros.');
INSERT INTO Movie (MovieName, MovieYear, MovieGenre, MCompanyName)
VALUES ('Furious 7', 2022, 'Science Fiction', 'Universal Pictures');

INSERT INTO VideoGame (GameName, GameYear, GameGenre)
VALUES ('Game 1', 2020, 'Action');
INSERT INTO VideoGame (GameName, GameYear, GameGenre)
VALUES ('Game 2', 2019, 'Adventure');
INSERT INTO VideoGame (GameName, GameYear, GameGenre)
VALUES ('Game 3', 2021, 'RPG');
INSERT INTO VideoGame (GameName, GameYear, GameGenre)
VALUES ('Game 4', 2018, 'Shooter');
INSERT INTO VideoGame (GameName, GameYear, GameGenre)
VALUES ('Game 5', 2022, 'Sports');

INSERT INTO Artist (ArtistName)
VALUES ('Artist 1');
INSERT INTO Artist (ArtistName)
VALUES ('Artist 2');
INSERT INTO Artist (ArtistName)
VALUES ('Artist 3');
INSERT INTO Artist (ArtistName)
VALUES ('Artist 4');
INSERT INTO Artist (ArtistName)
VALUES ('Artist 5');

INSERT INTO Developer (DevName)
VALUES ('Developer 1');
INSERT INTO Developer (DevName)
VALUES ('Developer 2');
INSERT INTO Developer (DevName)
VALUES ('Developer 3');
INSERT INTO Developer (DevName)
VALUES ('Developer 4');
INSERT INTO Developer (DevName)
VALUES ('Developer 5');

INSERT INTO Uses (Email, ModelNumber, Brand)
VALUES ('JohnDoe@gmail.com', 12345, 'Samsung');
INSERT INTO Uses (Email, ModelNumber, Brand)
VALUES ('JaneSmith@outlook.com', 67890, 'Apple');
INSERT INTO Uses (Email, ModelNumber, Brand)
VALUES ('MichaelJohnson@hotmail.com', 54321, 'Google');
INSERT INTO Uses (Email, ModelNumber, Brand)
VALUES ('EmilyBrown@yahoo.com', 98765, 'Microsoft');
INSERT INTO Uses (Email, ModelNumber, Brand)
VALUES ('DavidWilson@webmail.com', 23456, 'Sony');

INSERT INTO Writes (SongName, SongYear, ArtistName)
VALUES ('Song 1', 2020, 'Artist 1');
INSERT INTO Writes (SongName, SongYear, ArtistName)
VALUES ('Song 2', 2019, 'Artist 2');
INSERT INTO Writes (SongName, SongYear, ArtistName)
VALUES ('Song 3', 2021, 'Artist 3');
INSERT INTO Writes (SongName, SongYear, ArtistName)
VALUES ('Song 4', 2018, 'Artist 4');
INSERT INTO Writes (SongName, SongYear, ArtistName)
VALUES ('Song 5', 2018, 'Artist 5');

INSERT INTO Makes (GameName, GameYear, DevName)
VALUES ('Game 1', 2020, 'Developer 1');
INSERT INTO Makes (GameName, GameYear, DevName)
VALUES ('Game 2', 2019, 'Developer 2');
INSERT INTO Makes (GameName, GameYear, DevName)
VALUES ('Game 3', 2021, 'Developer 3');
INSERT INTO Makes (GameName, GameYear, DevName)
VALUES ('Game 4', 2018, 'Developer 4');
INSERT INTO Makes (GameName, GameYear, DevName)
VALUES ('Game 5', 2022, 'Developer 5');

INSERT INTO Accesses (ModelNumber, Brand, ServiceProvider)
VALUES (12345, 'Samsung', 'Netflix');
INSERT INTO Accesses (ModelNumber, Brand, ServiceProvider)
VALUES (67890, 'Apple', 'Hulu');
INSERT INTO Accesses (ModelNumber, Brand, ServiceProvider)
VALUES (54321, 'Google', 'Amazon Prime');
INSERT INTO Accesses (ModelNumber, Brand, ServiceProvider)
VALUES (98765, 'Microsoft', 'Disney+');
INSERT INTO Accesses (ModelNumber, Brand, ServiceProvider)
VALUES (23456, 'Sony', 'Spotify');

INSERT INTO Plays (ServiceProvider, SongName, SongYear, NumPlays)
VALUES ('Spotify', 'Song 1', 2020, 100);
INSERT INTO Plays (ServiceProvider, SongName, SongYear, NumPlays)
VALUES ('Amazon Prime', 'Song 2', 2019, 50);
INSERT INTO Plays (ServiceProvider, SongName, SongYear, NumPlays)
VALUES ('Tidal', 'Song 3', 2021, 75);
INSERT INTO Plays (ServiceProvider, SongName, SongYear, NumPlays)
VALUES ('Deezer', 'Song 4', 2018, 120);
INSERT INTO Plays (ServiceProvider, SongName, SongYear, NumPlays)
VALUES ('Pandora', 'Song 5', 2018, 90);

INSERT INTO Streams (ServiceProvider, MovieName, MovieYear, NumStreams)
VALUES ('Amazon Prime', 'Ready Player One', 2020, 200);
INSERT INTO Streams (ServiceProvider, MovieName, MovieYear, NumStreams)
VALUES ('Netflix', 'Jurrasic World', 2019, 150);
INSERT INTO Streams (ServiceProvider, MovieName, MovieYear, NumStreams)
VALUES ('Hulu', 'Skyfall', 2021, 180);
INSERT INTO Streams (ServiceProvider, MovieName, MovieYear, NumStreams)
VALUES ('Disney+', 'Pokémon Detective Pikachu', 2018, 220);
INSERT INTO Streams (ServiceProvider, MovieName, MovieYear, NumStreams)
VALUES ('HBO Max', 'Furious 7', 2022, 160);

INSERT INTO Provides (ServiceProvider, GameName, GameYear, TimePlayed)
VALUES ('Steam', 'Game 1', 2020, 10);
INSERT INTO Provides (ServiceProvider, GameName, GameYear, TimePlayed)
VALUES ('Epic Games', 'Game 2', 2019, 8);
INSERT INTO Provides (ServiceProvider, GameName, GameYear, TimePlayed)
VALUES ('Origin', 'Game 3', 2021, 12);
INSERT INTO Provides (ServiceProvider, GameName, GameYear, TimePlayed)
VALUES ('Xbox Game Pass', 'Game 4', 2018, 15);
INSERT INTO Provides (ServiceProvider, GameName, GameYear, TimePlayed)
VALUES ('PlayStation Now', 'Game 5', 2022, 20);

INSERT INTO SubscribesTo (Email, ServiceProvider, BillingFrequency, CostPerPayment, YearlyCost)
VALUES ('JohnDoe@gmail.com', 'Netflix', 'Monthly', 9.99, 119.88);
INSERT INTO SubscribesTo (Email, ServiceProvider, BillingFrequency, CostPerPayment, YearlyCost)
VALUES ('JohnDoe@gmail.com', 'Hulu', 'Monthly', 11.99, 143.88);
INSERT INTO SubscribesTo (Email, ServiceProvider, BillingFrequency, CostPerPayment, YearlyCost)
VALUES ('JohnDoe@gmail.com', 'Amazon Prime', 'Yearly', 119.00, 119.00);
INSERT INTO SubscribesTo (Email, ServiceProvider, BillingFrequency, CostPerPayment, YearlyCost)
VALUES ('JaneSmith@outlook.com', 'Hulu', 'Monthly', 11.99, 143.88);
INSERT INTO SubscribesTo (Email, ServiceProvider, BillingFrequency, CostPerPayment, YearlyCost)
VALUES ('MichaelJohnson@hotmail.com', 'Amazon Prime', 'Yearly', 119.00, 119.00);
INSERT INTO SubscribesTo (Email, ServiceProvider, BillingFrequency, CostPerPayment, YearlyCost)
VALUES ('EmilyBrown@yahoo.com', 'Disney+', 'Yearly', 79.99, 79.99);
INSERT INTO SubscribesTo (Email, ServiceProvider, BillingFrequency, CostPerPayment, YearlyCost)
VALUES ('DavidWilson@webmail.com', 'Xbox Game Pass', 'Monthly', 9.99, 119.88);