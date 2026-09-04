-- Create Database
CREATE DATABASE RaceDayDB;
GO
USE RaceDayDB;
GO
 
-- 1. Roles Table
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName VARCHAR(50) NOT NULL UNIQUE
);
 
-- 2. Users Table
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    RoleID INT NOT NULL,
    FullName VARCHAR(150) NOT NULL,
    EmailAddress VARCHAR(150) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);
 
-- 3. Events Table
CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    Title VARCHAR(150) NOT NULL,
    ScheduledDate DATE NOT NULL,
    Description VARCHAR(MAX) NOT NULL,
    FOREIGN KEY (OrganiserID) REFERENCES Users(UserID)
);
 
-- 4. Sponsors Table (Extra Entity)
CREATE TABLE Sponsors (
    SponsorID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CompanyName VARCHAR(100) NOT NULL,
    SponsorshipTier VARCHAR(50) DEFAULT 'Bronze',
    FOREIGN KEY (EventID) REFERENCES Events(EventID) ON DELETE CASCADE
);
 
-- 5. Categories Table
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    TypeName VARCHAR(100) NOT NULL,
    DistanceKM DECIMAL(6,2) NOT NULL,
    FOREIGN KEY (EventID) REFERENCES Events(EventID) ON DELETE CASCADE
);
 
-- 6. Enrolments Table
CREATE TABLE Enrolments (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CategoryID INT NOT NULL,
    Status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
 
-- 7. Results Table
CREATE TABLE Results (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE,
    TimeRecorded VARCHAR(20) NOT NULL,
    MedalType VARCHAR(50) NOT NULL,
    FOREIGN KEY (EnrolmentID) REFERENCES Enrolments(EnrolmentID)
);
 
-- ==========================================
-- SEED DATA 
-- ==========================================
 
-- Seed Roles
INSERT INTO Roles (RoleName) VALUES ('Organiser'), ('Participant');
 
-- Seed Users (2 Organisers, 2 Participants)
INSERT INTO Users (RoleID, FullName, EmailAddress, PasswordHash)
VALUES 
(1, 'David Meyer', 'david@raceadmin.co.za', 'hashed_pass'),
(1, 'Lerato Khumalo', 'lerato@raceadmin.co.za', 'hashed_pass'),
(2, 'Sipho Ndlovu', 'sipho.runner@gmail.com', 'hashed_pass'),
(2, 'Alice Johnson', 'alice.cycles@gmail.com', 'hashed_pass');
 
-- Seed Events (3 Events) based on SA culture
INSERT INTO Events (OrganiserID, Title, ScheduledDate, Description)
VALUES 
(1, 'Two Oceans Marathon 2026', '2026-04-10', 'The worlds most beautiful marathon.'),
(2, '947 Ride Joburg 2026', '2026-11-15', 'Tough urban cycling event in Johannesburg.'),
(1, 'Sanlam Cape Town Marathon', '2026-10-18', 'A prestigious gold label status marathon.');
 
-- Seed Sponsors
INSERT INTO Sponsors (EventID, CompanyName, SponsorshipTier)
VALUES 
(1, 'Old Mutual', 'Gold'),
(2, 'Virgin Active', 'Silver');
 
-- Seed Categories
INSERT INTO Categories (EventID, TypeName, DistanceKM)
VALUES 
(1, 'Ultra Marathon', 56.00),
(1, 'Half Marathon', 21.10),
(2, 'Full Route', 97.00),
(3, 'Marathon', 42.20),
(3, 'Peace Run', 10.00);
 
-- Seed Enrolments
INSERT INTO Enrolments (UserID, CategoryID, Status)
VALUES 
(3, 2, 'Confirmed'), -- Sipho in Two Oceans Half
(4, 3, 'Confirmed'), -- Alice in 947 Ride Joburg
(3, 5, 'Confirmed'); -- Sipho in Cape Town Peace Run
 
-- Seed Results
INSERT INTO Results (EnrolmentID, TimeRecorded, MedalType)
VALUES 
(1, '01:50:23', 'Silver'),
(2, '03:15:40', 'Bronze');
GO