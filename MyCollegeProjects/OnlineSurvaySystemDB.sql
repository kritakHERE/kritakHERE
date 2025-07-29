CREATE DATABASE IF NOT EXISTS OnlineSurveySystem;
USE OnlineSurveySystem;


CREATE TABLE USER (
    userID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    gender ENUM('male', 'female', 'other') NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    userType ENUM('admin', 'regular') NOT NULL,
    registrationDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    password VARCHAR(255) NOT NULL
);


CREATE TABLE SURVEY (
    surveyID INT PRIMARY KEY AUTO_INCREMENT,
    adminID INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    status ENUM('active', 'inactive', 'completed') DEFAULT 'inactive',
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (adminID) REFERENCES USER(userID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (startDate <= endDate)
);


CREATE TABLE QUESTION (
    questionID INT PRIMARY KEY AUTO_INCREMENT,
    questionContent TEXT NOT NULL,
    questionType ENUM('MCQ', 'FreeText', 'Rating', 'YesNo') NOT NULL,
    options TEXT,               -- Only used for MCQ
    maxLength INT,              -- Only used for Fr￼eeText
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE SURVEY_QUESTIONS (
    surveyQuestionID INT PRIMARY KEY AUTO_INCREMENT,
    surveyID INT NOT NULL,
    questionID INT NOT NULL,
    questionOrder INT NOT NULL CHECK (questionOrder > 0),
    isRequired BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (surveyID) REFERENCES SURVEY(surveyID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (questionID) REFERENCES QUESTION(questionID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE RESPONSE (
    responseID INT PRIMARY KEY AUTO_INCREMENT,
    surveyQuestionID INT NOT NULL,
    responderID INT NOT NULL,
    responseText TEXT,       -- Used for FreeText, YesNo, Rating
    selectedOption INT,      -- Used for MCQ (index or position of selected option)
    submittedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    ipAddress VARCHAR(45),
    FOREIGN KEY (surveyQuestionID) REFERENCES SURVEY_QUESTIONS(surveyQuestionID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (responderID) REFERENCES USER(userID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Insert Admin Users
INSERT INTO USER (name, gender, email, userType, password) VALUES
('John Smith', 'male', 'john.admin@survey.com', 'admin', 'hashedpassword1'),
('Sarah Johnson', 'female', 'sarah.admin@survey.com', 'admin', 'hashedpassword2'),
('Mike Wilson', 'male', 'mike.admin@survey.com', 'admin', 'hashedpassword3');

-- Insert Regular Users (20-30 records as required)
INSERT INTO USER (name, gender, email, userType, password) VALUES
('Alice Brown', 'female', 'alice@email.com', 'regular', 'userpass1'),
('Bob Davis', 'male', 'bob@email.com', 'regular', 'userpass2'),
('Carol White', 'female', 'carol@email.com', 'regular', 'userpass3'),
('David Green', 'male', 'david@email.com', 'regular', 'userpass4'),
('Emma Taylor', 'female', 'emma@email.com', 'regular', 'userpass5'),
('Frank Miller', 'male', 'frank@email.com', 'regular', 'userpass6'),
('Grace Lee', 'female', 'grace@email.com', 'regular', 'userpass7'),
('Henry Clark', 'male', 'henry@email.com', 'regular', 'userpass8'),
('Ivy Rodriguez', 'female', 'ivy@email.com', 'regular', 'userpass9'),
('Jack Thompson', 'male', 'jack@email.com', 'regular', 'userpass10'),
('Kate Anderson', 'female', 'kate@email.com', 'regular', 'userpass11'),
('Liam Garcia', 'male', 'liam@email.com', 'regular', 'userpass12'),
('Maya Patel', 'female', 'maya@email.com', 'regular', 'userpass13'),
('Noah Martinez', 'male', 'noah@email.com', 'regular', 'userpass14'),
('Olivia Johnson', 'female', 'olivia@email.com', 'regular', 'userpass15'),
('Peter Kim', 'male', 'peter@email.com', 'regular', 'userpass16'),
('Quinn Zhang', 'other', 'quinn@email.com', 'regular', 'userpass17'),
('Rachel Cooper', 'female', 'rachel@email.com', 'regular', 'userpass18'),
('Sam Foster', 'male', 'sam@email.com', 'regular', 'userpass19'),
('Tina Liu', 'female', 'tina@email.com', 'regular', 'userpass20'),
('Victor Santos', 'male', 'victor@email.com', 'regular', 'userpass21'),
('Wendy Adams', 'female', 'wendy@email.com', 'regular', 'userpass22'),
('Xavier Bell', 'male', 'xavier@email.com', 'regular', 'userpass23'),
('Yuki Tanaka', 'female', 'yuki@email.com', 'regular', 'userpass24'),
('Zoe Phillips', 'female', 'zoe@email.com', 'regular', 'userpass25');


-- Insert Surveys created by admin users
INSERT INTO SURVEY (adminID, title, description, startDate, endDate, status) VALUES
(1, 'Customer Satisfaction Survey', 'Evaluate customer satisfaction with our services', '2025-08-01', '2025-08-31', 'active'),
(1, 'Product Feedback Survey', 'Gather feedback on new product features', '2025-07-15', '2025-08-15', 'active'),
(2, 'Employee Engagement Survey', 'Measure employee satisfaction and engagement', '2025-08-05', '2025-09-05', 'inactive'),
(2, 'Market Research Survey', 'Understanding market trends and preferences', '2025-07-20', '2025-08-20', 'active'),
(3, 'Website Usability Survey', 'Evaluate website user experience', '2025-08-10', '2025-09-10', 'inactive');

-- Insert Questions of different types
INSERT INTO QUESTION (questionContent, questionType, options, maxLength) VALUES
('How satisfied are you with our service?', 'Rating', NULL, NULL),
('What is your age group?', 'MCQ', '18-25,26-35,36-45,46-55,55+', NULL),
('Please describe your experience with our product', 'FreeText', NULL, 500),
('Would you recommend our service to others?', 'YesNo', NULL, NULL),
('Which features do you use most frequently?', 'MCQ', 'Feature A,Feature B,Feature C,Feature D', NULL),
('What improvements would you suggest?', 'FreeText', NULL, 1000),
('How often do you use our service?', 'MCQ', 'Daily,Weekly,Monthly,Rarely', NULL),
('Rate the user interface design', 'Rating', NULL, NULL),
('Do you find our pricing reasonable?', 'YesNo', NULL, NULL),
('Additional comments or suggestions', 'FreeText', NULL, 2000);

-- Link questions to surveys with order and requirements
INSERT INTO SURVEY_QUESTIONS (surveyID, questionID, questionOrder, isRequired) VALUES
-- Customer Satisfaction Survey (Survey 1)
(1, 1, 1, TRUE),   -- Satisfaction rating
(1, 2, 2, TRUE),   -- Age group
(1, 3, 3, FALSE),  -- Experience description
(1, 4, 4, TRUE),   -- Recommendation

-- Product Feedback Survey (Survey 2)
(2, 5, 1, TRUE),   -- Features used
(2, 6, 2, FALSE),  -- Improvements
(2, 8, 3, TRUE),   -- UI rating

-- Employee Engagement Survey (Survey 3)
(3, 1, 1, TRUE),   -- Satisfaction rating
(3, 7, 2, TRUE),   -- Usage frequency
(3, 10, 3, FALSE), -- Additional comments

-- Market Research Survey (Survey 4)
(4, 2, 1, TRUE),   -- Age group
(4, 7, 2, TRUE),   -- Usage frequency
(4, 9, 3, TRUE),   -- Pricing opinion

-- Website Usability Survey (Survey 5)
(5, 8, 1, TRUE),   -- UI rating
(5, 3, 2, FALSE),  -- Experience description
(5, 4, 3, TRUE);   -- Recommendation

-- Insert sample responses from regular users
INSERT INTO RESPONSE (surveyQuestionID, responderID, responseText, selectedOption) VALUES
-- Responses to Customer Satisfact￼ion Survey
(1, 4, '4', NULL),    -- Alice rates satisfaction as 4
(2, 4, NULL, 2),      -- Alice selects age group 26-35
(3, 4, 'Great service, very helpful staff', NULL),
(4, 4, 'Yes', NULL),

(1, 5, '5', NULL),    -- Bob rates satisfaction as 5
(2, 5, NULL, 1),      -- Bob selects age group 18-25
(4, 5, 'Yes', NULL),

-- Responses to Product Feedback Survey
(5, 6, NULL, 1),      -- Carol uses Feature A most
(6, 6, 'Add more customization options', NULL),
(7, 6, '4', NULL),    -- Carol rates UI as 4

(5, 7, NULL, 3),      -- David uses Feature C most
(7, 7, '3', NULL),    -- David rates UI as 3

-- More responses for statistical analysis
(1, 8, '3', NULL),    -- Emma rates satisfaction as 3
(2, 8, NULL, 3),      -- Emma selects age group 36-45
(4, 8, 'Maybe', NULL),

(5, 9, NULL, 2),      -- Frank uses Feature B most
(6, 9, 'Improve loading speed', NULL),
(7, 9, '5', NULL),    -- Frank rates UI as 5

(1, 10, '4', NULL),   -- Grace rates satisfaction as 4
(2, 10, NULL, 2),     -- Grace selects age group 26-35
(3, 10, 'Good overall experience', NULL),
(4, 10, 'Yes', NULL),

-- Additional responses for aggregate function demonstrations
(1, 11, '5', NULL), (1, 12, '4', NULL), (1, 13, '3', NULL), (1, 14, '5', NULL),
(1, 15, '4', NULL), (1, 16, '5', NULL), (1, 17, '3', NULL), (1, 18, '4', NULL);




-- COUNT: Count number of records
-- Syntax: SELECT COUNT(column) FROM table WHERE condition

-- Example 1: Count total number of users
SELECT COUNT(*) AS total_users FROM USER;
-- Returns the total number of registered users

-- Example 2: Count responses per survey
SELECT s.title, COUNT(r.responseID) AS response_count
FROM SURVEY s
LEFT JOIN SURVEY_QUESTIONS sq ON s.surveyID = sq.surveyID
LEFT JOIN RESPONSE r ON sq.surveyQuestionID = r.surveyQuestionID
GROUP BY s.surveyID, s.title;
-- Shows how many responses each survey has received

-- SELECT Operation - Get all active surveys
SELECT surveyID, title, startDate, endDate, status 
FROM SURVEY 
WHERE status = 'active';

-- UPDATE Operation - Update survey status
UPDATE SURVEY 
SET status = 'completed' 
WHERE endDate < CURDATE() AND status = 'active';

-- DELETE Operation - Delete old inactive surveys
DELETE FROM SURVEY 
WHERE status = 'inactive' 
AND createdAt < DATE_SUB(NOW(), INTERVAL 6 MONTH);

-- COUNT() - Count responses per survey
SELECT s.title, COUNT(r.responseID) as total_responses
FROM SURVEY s
LEFT JOIN SURVEY_QUESTIONS sq ON s.surveyID = sq.surveyID
LEFT JOIN RESPONSE r ON sq.surveyQuestionID = r.surveyQuestionID
GROUP BY s.surveyID, s.title, u.name, s.status, s.startDate, s.endDate;

-- Create User Activity View
CREATE VIEW UserActivity AS
SELECT 
    u.userID,
    u.name,
    u.email,
    u.userType,
    u.registrationDate,
    CASE 
        WHEN u.userType = 'admin' THEN 
            (SELECT COUNT(*) FROM SURVEY WHERE adminID = u.userID)
        ELSE 0 
    END as surveys_created,
    CASE 
        WHEN u.userType = 'regular' THEN 
            (SELECT COUNT(DISTINCT sq.surveyID) 
             FROM RESPONSE r 
             JOIN SURVEY_QUESTIONS sq ON r.surveyQuestionID = sq.surveyQuestionID 
             WHERE r.responderID = u.userID)
        ELSE 0 
    END as surveys_participated,
    CASE 
        WHEN u.userType = 'regular' THEN 
            (SELECT COUNT(*) FROM RESPONSE WHERE responderID = u.userID)
        ELSE 0 
    END as total_responses
FROM USER u;

-- =====================================================
-- SECTION 7: JOIN OPERATIONS
-- =====================================================

-- INNER JOIN - Get all survey responses with user details
SELECT 
    u.name as respondent_name,
    s.title as survey_title,
    q.questionContent,
    r.responseText,
    r.submittedAt
FROM RESPONSE r
INNER JOIN SURVEY_QUESTIONS sq ON r.surveyQuestionID = sq.surveyQuestionID
INNER JOIN SURVEY s ON sq.surveyID = s.surveyID
INNER JOIN QUESTION q ON sq.questionID = q.questionID
INNER JOIN USER u ON r.responderID = u.userID
ORDER BY r.submittedAt DESC;

-- LEFT JOIN - All surveys with response counts (including surveys with no responses)
SELECT 
    s.surveyID,
    s.title,
    s.status,
    COUNT(r.responseID) as response_count
FROM SURVEY s
LEFT JOIN SURVEY_QUESTIONS sq ON s.surveyID = sq.surveyID
LEFT JOIN RESPONSE r ON sq.surveyQuestionID = r.surveyQuestionID
GROUP BY s.surveyID, s.title, s.status
ORDER BY response_count DESC;

-- RIGHT JOIN - All questions with usage count in surveys
SELECT 
    q.questionID,
    q.questionContent,
    q.questionType,
    COUNT(sq.surveyID) as used_in_surveys
FROM SURVEY_QUESTIONS sq
RIGHT JOIN QUESTION q ON sq.questionID = q.questionID
GROUP BY q.questionID, q.questionContent, q.questionType
ORDER BY used_in_surveys DESC;

-- FULL OUTER JOIN (Using UNION) - Complete user and survey relationship
SELECT 
    u.name as user_name,
    u.userType,
    s.title as survey_title,
    'Creator' as relationship_type
FROM USER u
LEFT JOIN SURVEY s ON u.userID = s.adminID
WHERE s.surveyID IS NOT NULL

UNION

SELECT 
    u.name as user_name,
    u.userType,
    s.title as survey_title,
    'Participant' as relationship_type
FROM USER u
LEFT JOIN RESPONSE r ON u.userID = r.responderID
LEFT JOIN SURVEY_QUESTIONS sq ON r.surveyQuestionID = sq.surveyQuestionID
LEFT JOIN SURVEY s ON sq.surveyID = s.surveyID
WHERE s.surveyID IS NOT NULL;

-- SELF JOIN - Find users registered on the same day
SELECT 
    u1.name as user1,
    u2.name as user2,
    DATE(u1.registrationDate) as registration_date
FROM USER u1
JOIN USER u2 ON DATE(u1.registrationDate) = DATE(u2.registrationDate)
WHERE u1.userID < u2.userID
ORDER BY registration_date;

-- CROSS JOIN - All possible user-question combinations (limited)
SELECT 
    u.name as user_name,
    q.questionContent,
    q.questionType
FROM USER u
CROSS JOIN QUESTION q
WHERE u.userType = 'regular'
AND q.questionType IN ('YesNo', 'Rating')
LIMIT 20;
