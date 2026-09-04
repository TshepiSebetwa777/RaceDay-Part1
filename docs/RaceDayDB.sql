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