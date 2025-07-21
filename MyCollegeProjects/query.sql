-- Schema: IIMS Cinemas - Full Movie Ticket Booking System
drop database if exists IIMSCinemaDB;
CREATE DATABASE IIMSCinemaDB;
USE IIMSCinemaDB;

-- 1. Customers (Users)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    ContactNumber VARCHAR(15),
    Email VARCHAR(100),
    Preferences TEXT
);

-- 2. Employees (Admins)
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Role VARCHAR(50),
    ContactNumber VARCHAR(15),
    Email VARCHAR(100)
);

-- 3. Theatres
CREATE TABLE Theatres (
    TheatreID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    City VARCHAR(50),
    Address VARCHAR(200)
);

-- 4. Screens (within theatres)
CREATE TABLE Screens (
    ScreenID INT PRIMARY KEY AUTO_INCREMENT,
    TheatreID INT,
    ScreenName VARCHAR(50),
    TotalSeats INT,
    FOREIGN KEY (TheatreID) REFERENCES Theatres(TheatreID)
);

-- 5. SeatClass (Gold, Silver, Economy)
CREATE TABLE SeatClass (
    ClassID INT PRIMARY KEY AUTO_INCREMENT,
    ClassName ENUM('Gold', 'Silver', 'Economy')
);

-- 6. ScreenSeatClass (available seats of each class per screen)
CREATE TABLE ScreenSeatClass (
    ScreenSeatClassID INT PRIMARY KEY AUTO_INCREMENT,
    ScreenID INT,
    ClassID INT,
    SeatCount INT,
    FOREIGN KEY (ScreenID) REFERENCES Screens(ScreenID),
    FOREIGN KEY (ClassID) REFERENCES SeatClass(ClassID)
);

-- 7. Movies
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(150),
    Language VARCHAR(50),
    Duration TIME,
    Genre VARCHAR(50),
    Rating VARCHAR(10),
    ProductionCompany VARCHAR(100),
    AddedByEmployeeID INT,
    FOREIGN KEY (AddedByEmployeeID) REFERENCES Employees(EmployeeID)
);

-- 8. Shows (each movie on each screen with time and prices)
CREATE TABLE Shows (
    ShowID INT PRIMARY KEY AUTO_INCREMENT,
    MovieID INT,
    ScreenID INT,
    StartTime DATETIME,
    EndTime DATETIME,
    TicketPriceGold DECIMAL(6,2),
    TicketPriceSilver DECIMAL(6,2),
    TicketPriceEconomy DECIMAL(6,2),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (ScreenID) REFERENCES Screens(ScreenID)
);
select * from Shows; 
-- 9. Seats (actual seat numbers)
CREATE TABLE Seats (
    SeatID INT PRIMARY KEY AUTO_INCREMENT,
    ScreenID INT,
    SeatNumber VARCHAR(10),
    ClassID INT,
    FOREIGN KEY (ScreenID) REFERENCES Screens(ScreenID),
    FOREIGN KEY (ClassID) REFERENCES SeatClass(ClassID)
);

-- 10. Bookings
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    ShowID INT,
    BookingDateTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(8,2),
    Status ENUM('Booked', 'Cancelled', 'Rescheduled') DEFAULT 'Booked',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ShowID) REFERENCES Shows(ShowID)
);


-- ticket
CREATE TABLE Tickets (
    TicketID INT PRIMARY KEY AUTO_INCREMENT,
    IssueDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Price DECIMAL(8,2),
    QRCode VARCHAR(255) -- Optional for future stuff
);

-- 11. BookingDetails (tracks seats per booking)

CREATE TABLE BookingDetails (
    BookingDetailID INT PRIMARY KEY AUTO_INCREMENT,
    BookingID INT,
    SeatID INT,
    TicketID INT,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (SeatID) REFERENCES Seats(SeatID),
    FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID)
);


-- 12. BookingHistory (logs changes for audit)
CREATE TABLE BookingHistory (
    HistoryID INT PRIMARY KEY AUTO_INCREMENT,
    BookingID INT,
    ChangeReason TEXT,
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

-- 13. Payments
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    BookingID INT,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    AmountPaid DECIMAL(8,2),
    PaymentMode ENUM('Cash', 'Card', 'Online'),
    CardNumber VARCHAR(20),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

-- 14. UserPreferences (optional for personalization)
CREATE TABLE UserPreferences (
    PreferenceID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    GenrePreference VARCHAR(50),
    LanguagePreference VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 15. Notifications (triggered for overbookings, alerts)
CREATE TABLE Notifications (
    NotificationID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    Message TEXT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- set auto increment

-- 1. MOVIES TABLE - Should start from MovieID = 6
-- Reset auto-increment to 6 before inserting data
ALTER TABLE Movies AUTO_INCREMENT = 6;

-- 2. SHOWS TABLE - Should start from ShowID = 134 
-- Reset auto-increment to 134 before inserting data
ALTER TABLE Shows AUTO_INCREMENT = 134;

-- 3. BOOKINGS TABLE - Should start from BookingID = 81
-- Reset auto-increment to 81 before inserting data  
ALTER TABLE Bookings AUTO_INCREMENT = 81;

-- 4. PAYMENTS TABLE - Should start from PaymentID = 101 (to match bookings 81-121)
-- Reset auto-increment to 101 before inserting data
ALTER TABLE Payments AUTO_INCREMENT = 101;

-- 5. BOOKING HISTORY TABLE - Should start from HistoryID = 101 (to match bookings)
-- Reset auto-increment to 101 before inserting data
ALTER TABLE BookingHistory AUTO_INCREMENT = 101;

-- end of setting auto increment


 -- Inserting data in tables
 
 -- Independent tables
 INSERT INTO Customers (Name, ContactNumber, Email, Preferences) VALUES
('Aryan Joshi', '9811111111', 'aryan@example.com', 'Action, Hindi'),
('Sita Lama', '9822222222', 'sita@example.com', 'Romance, Nepali'),
('Niraj Thapa', '9833333333', 'niraj@example.com', 'Horror, English'),
('Priya Sharma', '9844444444', 'priya@example.com', 'Drama, Hindi'),
('Ravi Basnet', '9855555555', 'ravi@example.com', 'Comedy, Nepali'),
('Sneha Giri', '9866666666', 'sneha@example.com', 'Thriller, English'),
('Anil Khadka', '9877777777', 'anil@example.com', 'Animation, English'),
('Puja Rai', '9888888888', 'puja@example.com', 'Horror, Hindi'),
('Ramesh Yadav', '9899999999', 'ramesh@example.com', 'Drama, Nepali'),
('Meena Karki', '9800000000', 'meena@example.com', 'Romance, English'),
('Rohan Chaudhary', '9810101010', 'rohan@example.com', 'Action, Hindi'),
('Kabita Gurung', '9820202020', 'kabita@example.com', 'Horror, Nepali'),
('Sunil Bhatt', '9830303030', 'sunil@example.com', 'Drama, English'),
('Aayush Singh', '9840404040', 'aayush@example.com', 'Thriller, Hindi'),
('Kiran Rana', '9850505050', 'kiran@example.com', 'Action, English'),
('Shreya KC', '9860606060', 'shreya@example.com', 'Comedy, Hindi'),
('Dipak Sharma', '9870707070', 'dipak@example.com', 'Animation, Nepali'),
('Manisha Joshi', '9880808080', 'manisha@example.com', 'Drama, Hindi'),
('Suman Neupane', '9890909090', 'suman@example.com', 'Romance, Nepali'),
('Aarav Bista', '9801010101', 'aarav@example.com', 'Action, Hindi');
select * from Customers;

INSERT INTO Employees (EmployeeID, Name, Role, ContactNumber, Email)
VALUES
(1, 'Aarya Sharma', 'Manager', '9800000001', 'aarya.sharma@retailclothing.com'),
(2, 'Bishal Thapa', 'Salesperson', '9800000002', 'bishal.thapa@retailclothing.com'),
(3, 'Kriti Bhandari', 'Inventory Staff', '9800000003', 'kriti.bhandari@retailclothing.com'),
(4, 'Roshan Gurung', 'Cashier', '9800000004', 'roshan.gurung@retailclothing.com'),
(5, 'Sabina Shrestha', 'Customer Support', '9800000005', 'sabina.shrestha@retailclothing.com');

INSERT INTO Theatres (Name, City, Address) VALUES
('QFX Labim Mall', 'Kathmandu', 'Labim Mall, Pulchowk, Lalitpur'),
('Bhatbhateni Cinema', 'Pokhara', 'Bhatbhateni Complex, Prithvi Chowk'),
('Big Movies', 'Kathmandu', 'City Center, Kamalpokhari'),
('Cine De Chitwan', 'Chitwan', 'Sahid Chowk, Bharatpur'),
('FCube Cinemas', 'Kathmandu', 'KL Tower, Chabahil');

INSERT INTO SeatClass (ClassName) VALUES
('Gold'),
('Silver'),
('Economy');


-- Dependent tables
INSERT INTO Movies (Title, Language, Duration, Genre, Rating, ProductionCompany, AddedByEmployeeID) VALUES
('The Haunted House', 'English', '02:00:00', 'Horror', 'PG-13', 'Ghost Films Ltd.', 1),
('Love in Kathmandu', 'Nepali', '01:45:00', 'Romance', 'U', 'Nepali Dreams', 1),
('Warrior Returns', 'Hindi', '02:30:00', 'Action', 'U/A', 'Battle Studios', 1),
('Animated Heroes', 'English', '01:30:00', 'Animation', 'U', 'Cartoonverse Inc.', 1),
('Dark Secrets', 'Hindi', '02:10:00', 'Thriller', 'PG-13', 'SuspenseWorks', 1);

INSERT INTO Screens (TheatreID, ScreenName, TotalSeats) VALUES
(1, 'Screen A', 100),
(1, 'Screen B', 80),
(2, 'Main Hall', 120),
(2, 'Screen X', 90),
(3, 'Gold Room', 75),
(3, 'Screen Z', 60),
(4, 'Screen 1', 85),
(5, 'VIP Lounge', 50),
(5, 'Mini Hall', 40);

INSERT INTO ScreenSeatClass (ScreenID, ClassID, SeatCount) VALUES
(1, 1, 20),  -- Gold
(1, 2, 30),  -- Silver
(1, 3, 50),  -- Economy
(2, 2, 30),
(2, 3, 50),
(3, 1, 25),
(3, 3, 95),
(4, 2, 40),
(4, 3, 50),
(5, 1, 15),
(5, 3, 60),
(6, 2, 30),
(6, 3, 30),
(7, 1, 25),
(7, 3, 60),
(8, 1, 10),
(8, 2, 20),
(9, 3, 40);
SELECT MovieID, Title FROM Movies;

INSERT INTO Shows (MovieID, ScreenID, StartTime, EndTime, TicketPriceGold, TicketPriceSilver, TicketPriceEconomy) VALUES
(6, 1, '2025-07-18 10:00:00', '2025-07-18 12:00:00', 500, 350, 200),
(6, 1, '2025-07-18 14:00:00', '2025-07-18 16:00:00', 500, 350, 200),
(6, 1, '2025-07-18 18:00:00', '2025-07-18 20:00:00', 500, 350, 200),
(6, 1, '2025-07-19 10:00:00', '2025-07-19 12:00:00', 500, 350, 200),
(6, 1, '2025-07-19 14:00:00', '2025-07-19 16:00:00', 500, 350, 200),

(7, 1, '2025-07-18 11:00:00', '2025-07-18 12:45:00', 450, 300, 180),
(8, 1, '2025-07-18 16:00:00', '2025-07-18 17:45:00', 450, 300, 180),
(8, 1, '2025-07-19 11:00:00', '2025-07-19 12:45:00', 450, 300, 180),
(7, 1, '2025-07-19 16:00:00', '2025-07-19 17:45:00', 450, 300, 180),
(7, 1, '2025-07-19 19:00:00', '2025-07-19 20:45:00', 450, 300, 180),

(8, 1, '2025-07-18 09:00:00', '2025-07-18 11:30:00', 600, 400, 250),
(8, 1, '2025-07-18 13:00:00', '2025-07-18 15:30:00', 600, 400, 250),
(8, 1, '2025-07-18 17:00:00', '2025-07-18 19:30:00', 600, 400, 250),
(8, 1, '2025-07-19 09:00:00', '2025-07-19 11:30:00', 600, 400, 250),
(9, 1, '2025-07-19 13:00:00', '2025-07-19 15:30:00', 600, 400, 250),

(9, 1, '2025-07-18 12:00:00', '2025-07-18 13:30:00', 400, 250, 150),
(9, 1, '2025-07-19 12:00:00', '2025-07-19 13:30:00', 400, 250, 150),
(10, 1, '2025-07-18 20:00:00', '2025-07-18 22:10:00', 550, 370, 220),
(10, 1, '2025-07-19 20:00:00', '2025-07-19 22:10:00', 550, 370, 220);

 -- More dependent tables
 select * from Shows;
INSERT INTO Bookings (ShowID, CustomerID, BookingDateTime, TotalAmount, Status) VALUES
(141, 1, NOW(), 1000.00, 'Booked'),
(142, 2, NOW(), 600.00, 'Booked'),
(143, 3, NOW(), 700.00, 'Booked'),
(134, 4, NOW(), 800.00, 'Booked'),
(135, 5, NOW(), 300.00, 'Booked'),
(146, 6, NOW(), 1050.00, 'Booked'),
(138, 7, NOW(), 900.00, 'Booked'),
(134, 8, NOW(), 1100.00, 'Booked'),
(134, 9, NOW(), 500.00, 'Booked'),
(135, 10, NOW(), 750.00, 'Booked'),
(141, 11, NOW(), 1200.00, 'Booked'),
(134, 12, NOW(), 950.00, 'Booked'),
(135, 13, NOW(), 400.00, 'Booked'),
(141, 14, NOW(), 300.00, 'Booked'),
(141, 15, NOW(), 1000.00, 'Booked'),
(143, 16, NOW(), 650.00, 'Booked'),
(141, 17, NOW(), 450.00, 'Booked'),
(134, 18, NOW(), 550.00, 'Booked'),
(134, 19, NOW(), 700.00, 'Booked'),
(134, 20, NOW(), 600.00, 'Booked');
select * from Bookings;

INSERT INTO UserPreferences (CustomerID, GenrePreference, LanguagePreference) VALUES
(1, 'Action', 'Hindi'),
(2, 'Romance', 'Nepali'),
(3, 'Horror', 'English'),
(4, 'Drama', 'Hindi'),
(5, 'Comedy', 'Nepali'),
(6, 'Thriller', 'English'),
(7, 'Animation', 'English'),
(8, 'Horror', 'Hindi'),
(9, 'Drama', 'Nepali'),
(10, 'Romance', 'English'),
(11, 'Action', 'Hindi'),
(12, 'Horror', 'Nepali'),
(13, 'Drama', 'English'),
(14, 'Thriller', 'Hindi'),
(15, 'Action', 'English'),
(16, 'Comedy', 'Hindi'),
(17, 'Animation', 'Nepali'),
(18, 'Drama', 'Hindi'),
(19, 'Romance', 'Nepali'),
(20, 'Action', 'Hindi');


INSERT INTO Payments (BookingID, PaymentDate, AmountPaid, PaymentMode, CardNumber) VALUES
(81, NOW(), 1000.00, 'Card', '1111-2222-3333-4444'),
(82, NOW(), 600.00, 'Card', '2222-3333-4444-5555'),
(83, NOW(), 700.00, 'Cash', NULL),
(84, NOW(), 800.00, 'Card', '3333-4444-5555-6666'),
(85, NOW(), 300.00, 'Online', NULL),
(86, NOW(), 1050.00, 'Card', '4444-5555-6666-7777'),
(87, NOW(), 900.00, 'Cash', NULL),
(88, NOW(), 1100.00, 'Card', '5555-6666-7777-8888'),
(89, NOW(), 500.00, 'Online', NULL),
(90, NOW(), 750.00, 'Card', '6666-7777-8888-9999'),
(91, NOW(), 1200.00, 'Card', '7777-8888-9999-0000'),
(92, NOW(), 950.00, 'Cash', NULL),
(93, NOW(), 400.00, 'Card', '8888-9999-0000-1111'),
(94, NOW(), 300.00, 'Online', NULL),
(95, NOW(), 1000.00, 'Card', '9999-0000-1111-2222'),
(96, NOW(), 650.00, 'Card', '0000-1111-2222-3333'),
(97, NOW(), 450.00, 'Cash', NULL),
(98, NOW(), 550.00, 'Online', NULL),
(99, NOW(), 700.00, 'Card', '1111-3333-5555-7777'),
(100, NOW(), 600.00, 'Card', '2222-4444-6666-8888');


-- Gold Seats for Screen 1
INSERT INTO Seats (ScreenID, SeatNumber, ClassID) VALUES
(1, 'G01', 1), (1, 'G02', 1), (1, 'G03', 1), (1, 'G04', 1), (1, 'G05', 1),
(1, 'G06', 1), (1, 'G07', 1), (1, 'G08', 1), (1, 'G09', 1), (1, 'G10', 1),
(1, 'G11', 1), (1, 'G12', 1), (1, 'G13', 1), (1, 'G14', 1), (1, 'G15', 1),
(1, 'G16', 1), (1, 'G17', 1), (1, 'G18', 1), (1, 'G19', 1), (1, 'G20', 1);

-- Silver Seats for Screen 1
INSERT INTO Seats (ScreenID, SeatNumber, ClassID) VALUES
(1, 'S01', 2), (1, 'S02', 2), (1, 'S03', 2), (1, 'S04', 2), (1, 'S05', 2),
(1, 'S06', 2), (1, 'S07', 2), (1, 'S08', 2), (1, 'S09', 2), (1, 'S10', 2),
(1, 'S11', 2), (1, 'S12', 2), (1, 'S13', 2), (1, 'S14', 2), (1, 'S15', 2),
(1, 'S16', 2), (1, 'S17', 2), (1, 'S18', 2), (1, 'S19', 2), (1, 'S20', 2),
(1, 'S21', 2), (1, 'S22', 2), (1, 'S23', 2), (1, 'S24', 2), (1, 'S25', 2),
(1, 'S26', 2), (1, 'S27', 2), (1, 'S28', 2), (1, 'S29', 2), (1, 'S30', 2);

-- Economy Seats for Screen 1
INSERT INTO Seats (ScreenID, SeatNumber, ClassID) VALUES
(1, 'E01', 3), (1, 'E02', 3), (1, 'E03', 3), (1, 'E04', 3), (1, 'E05', 3),
(1, 'E06', 3), (1, 'E07', 3), (1, 'E08', 3), (1, 'E09', 3), (1, 'E10', 3),
(1, 'E11', 3), (1, 'E12', 3), (1, 'E13', 3), (1, 'E14', 3), (1, 'E15', 3),
(1, 'E16', 3), (1, 'E17', 3), (1, 'E18', 3), (1, 'E19', 3), (1, 'E20', 3),
(1, 'E21', 3), (1, 'E22', 3), (1, 'E23', 3), (1, 'E24', 3), (1, 'E25', 3),
(1, 'E26', 3), (1, 'E27', 3), (1, 'E28', 3), (1, 'E29', 3), (1, 'E30', 3),
(1, 'E31', 3), (1, 'E32', 3), (1, 'E33', 3), (1, 'E34', 3), (1, 'E35', 3),
(1, 'E36', 3), (1, 'E37', 3), (1, 'E38', 3), (1, 'E39', 3), (1, 'E40', 3),
(1, 'E41', 3), (1, 'E42', 3), (1, 'E43', 3), (1, 'E44', 3), (1, 'E45', 3),
(1, 'E46', 3), (1, 'E47', 3), (1, 'E48', 3), (1, 'E49', 3), (1, 'E50', 3);

INSERT INTO Tickets (Price) VALUES
(450.00), (600.00), (300.00), (750.00), (500.00),
(800.00), (400.00), (650.00), (550.00), (700.00),
(600.00), (750.00), (300.00), (850.00), (500.00),
(950.00), (400.00), (1000.00), (650.00), (450.00),
(600.00), (720.00), (310.00), (730.00), (520.00),
(810.00), (420.00), (630.00), (560.00), (740.00),
(620.00), (760.00), (320.00), (870.00), (510.00),
(990.00), (410.00), (1010.00), (660.00), (470.00);

INSERT INTO BookingDetails (BookingID, SeatID, TicketID) VALUES
(81, 1, 1),
(82, 2, 2),
(83, 3, 3),
(84, 4, 4),
(85, 5, 5),
(86, 6, 6),
(87, 7, 7),
(88, 8, 8),
(89, 9, 9),
(90, 10, 10),
(91, 11, 11),
(92, 12, 12),
(93, 13, 13),
(94, 14, 14),
(95, 15, 15),
(96, 16, 16),
(97, 17, 17),
(98, 18, 18),
(99, 19, 19),
(100, 19, 19);


INSERT INTO BookingHistory (BookingID, ChangeReason) VALUES
(81, 'Seat changed from E10 to E12'),
(82, 'Customer updated contact info'),
(83, 'Booking upgraded to Gold class'),
(84, 'Discount applied manually'),
(85, 'Customer canceled and rebooked'),
(86, 'Payment retried after failure'),
(87, 'Show timing updated by admin'),
(88, 'Partial refund issued'),
(89, 'Seat changed due to maintenance'),
(90, 'Customer changed from Economy to Silver'),
(91, 'Duplicate booking removed'),
(92, 'Customer requested aisle seat'),
(93, 'System auto-corrected show time'),
(94, 'Card payment retried and succeeded'),
(95, 'Customer upgraded to Silver class'),
(96, 'Child discount manually applied'),
(97, 'Customer added snacks to booking'),
(98, 'System flagged duplicate transaction'),
(99, 'Refund processed for unavailable seat');



-- ===================================================================
-- adding more data for 10 ticket customer query
-- Insert 1 Customer
INSERT INTO Customers (Name, ContactNumber, Email, Preferences) VALUES
('Rajesh Maharjan', '9812345678', 'rajesh@example.com', 'Action, Comedy, Hindi');

-- Insert 1 Movie
INSERT INTO Movies (Title, Language, Duration, Genre, Rating, ProductionCompany, AddedByEmployeeID) VALUES
('Mumbai Express', 'Hindi', '02:15:00', 'Action', 'U/A', 'Bollywood Action Films', 1);

-- Insert 1 Screen (assuming we're adding to an existing theatre, let's use TheatreID = 2)
INSERT INTO Screens (TheatreID, ScreenName, TotalSeats) VALUES
(2, 'Screen Premium', 150);

-- Insert corresponding ScreenSeatClass for the new screen (assuming ScreenID will be 10)
INSERT INTO ScreenSeatClass (ScreenID, ClassID, SeatCount) VALUES
(10, 1, 30),  -- Gold
(10, 2, 50),  -- Silver  
(10, 3, 70);  -- Economy

-- Insert 1 Show (using the new movie and screen)
INSERT INTO Shows (MovieID, ScreenID, StartTime, EndTime, TicketPriceGold, TicketPriceSilver, TicketPriceEconomy) VALUES
(10, 1, '2025-07-21 19:00:00', '2025-07-21 21:15:00', 650, 450, 300);

-- Insert 12 Seats for the new screen (mix of different classes)
INSERT INTO Seats (ScreenID, SeatNumber, ClassID) VALUES
(1, 'G01', 1), -- Gold seat
(1, 'G02', 1), -- Gold seat
(1, 'S01', 2), -- Silver seat
(1, 'S02', 2), -- Silver seat
(1, 'S03', 2), -- Silver seat
(1, 'S04', 2), -- Silver seat
(1, 'E01', 3), -- Economy seat
(1, 'E02', 3), -- Economy seat
(1, 'E03', 3), -- Economy seat
(1, 'E04', 3), -- Economy seat
(1, 'E05', 3), -- Economy seat
(1, 'E06', 3); -- Economy seat

-- Insert 12 Tickets with appropriate prices
INSERT INTO Tickets (Price) VALUES
(650.00), -- Gold ticket 1
(650.00), -- Gold ticket 2
(450.00), -- Silver ticket 1
(450.00), -- Silver ticket 2
(450.00), -- Silver ticket 3
(450.00), -- Silver ticket 4
(300.00), -- Economy ticket 1
(300.00), -- Economy ticket 2
(300.00), -- Economy ticket 3
(300.00), -- Economy ticket 4
(300.00), -- Economy ticket 5
(300.00); -- Economy ticket 6

-- Insert 1 Booking for the customer (total amount = 2*650 + 4*450 + 6*300 = 1300 + 1800 + 1800 = 4900)
INSERT INTO Bookings (CustomerID, ShowID, BookingDateTime, TotalAmount, Status) VALUES
(21, 136, NOW(), 4900.00, 'Booked');

-- Insert 12 BookingDetails linking the booking to seats and tickets
-- Note: You'll need to adjust the SeatID and TicketID values based on the actual auto-incremented IDs
-- Assuming the new seats will have IDs starting from 101 and tickets from 41
INSERT INTO BookingDetails (BookingID, SeatID, TicketID) VALUES
(100, 101, 41), -- Gold seat G01
(100, 102, 42), -- Gold seat G02
(100, 103, 43), -- Silver seat S01
(100, 104, 44), -- Silver seat S02
(100, 105, 45), -- Silver seat S03
(100, 106, 46), -- Silver seat S04
(100, 107, 47), -- Economy seat E01
(100, 108, 48), -- Economy seat E02
(100, 109, 49), -- Economy seat E03
(100, 110, 50), -- Economy seat E04
(100, 111, 51), -- Economy seat E05
(100, 112, 52); -- Economy seat E06

-- Optional: Add payment record for this booking
INSERT INTO Payments (BookingID, PaymentDate, AmountPaid, PaymentMode, CardNumber) VALUES
(100, NOW(), 4900.00, 'Card', '1234-5678-9012-3456');

-- Optional: Add booking history entry
INSERT INTO BookingHistory (BookingID, ChangeReason) VALUES
(100, 'Group booking for family event - 12 tickets purchased together');

-- end of customer with  more then 10 tickets
-- ===================================================================








-- select queries
-- 1. Movies That Require Parental Guidance
SELECT * 
FROM Movies 
WHERE Genre IN ('Horror', 'Thriller', 'Crime', 'Action');

-- 2. People Who Booked More Than 10 Tickets 
SELECT 
    C.CustomerID,
    C.Name,
    C.Email,
    COUNT(BD.SeatID) AS TotalTicketsBooked
FROM 
    Customers C
JOIN 
    Bookings B ON C.CustomerID = B.CustomerID
JOIN 
    BookingDetails BD ON B.BookingID = BD.BookingID
GROUP BY 
    C.CustomerID
HAVING 
    TotalTicketsBooked > 10;


-- 3. User Details by Card Number Used in Payment
SELECT 
    C.CustomerID,
    C.Name,
    C.Email,
    P.CardNumber
FROM 
    Payments P
JOIN 
    Bookings B ON P.BookingID = B.BookingID
JOIN 
    Customers C ON B.CustomerID = C.CustomerID
WHERE 
    P.CardNumber IS NOT NULL;


-- 4. Total Earnings Per Movie (Descending Order)

SELECT 
    M.MovieID,
    M.Title,
    SUM(B.TotalAmount) AS TotalEarnings
FROM 
    Movies M
JOIN 
    Shows S ON M.MovieID = S.MovieID
JOIN 
    Bookings B ON S.ShowID = B.ShowID
WHERE 
    B.Status = 'Booked'
GROUP BY 
    M.MovieID
ORDER BY 
    TotalEarnings DESC;


-- 5. Theatre Details by ScreenID

SELECT 
    T.*
FROM 
    Screens S
JOIN 
    Theatres T ON S.TheatreID = T.TheatreID
WHERE 
    S.ScreenID = 3; 

-- 6. User Details Based on Ticket ID

SELECT 
    C.CustomerID,
    C.Name,
    C.Email,
    BD.SeatID AS TicketID
FROM 
    BookingDetails BD
JOIN 
    Bookings B ON BD.BookingID = B.BookingID
JOIN 
    Customers C ON B.CustomerID = C.CustomerID
WHERE 
    BD.SeatID = 9; 

