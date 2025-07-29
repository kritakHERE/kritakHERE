CREATE DATABASE ConstructionDB;
USE ConstructionDB;

-- Table: Project
CREATE TABLE Project (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL
);
-- Table: Worker
CREATE TABLE Worker (
    WorkerID INT PRIMARY KEY,
    WorkerName VARCHAR(100) NOT NULL,
    Age INT CHECK (Age >= 18),
    SkillSet VARCHAR(100)
);

-- Table: Task
CREATE TABLE Task (
    TaskID INT PRIMARY KEY,
    TaskName VARCHAR(100) NOT NULL,
    TaskType VARCHAR(50),
    ProjectID INT,
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);

-- Table: Assignment
CREATE TABLE Assignment (
    AssignmentID INT PRIMARY KEY,
    WorkerID INT,
    TaskID INT,
    AssignedDate DATE,
    FOREIGN KEY (WorkerID) REFERENCES Worker(WorkerID),
    FOREIGN KEY (TaskID) REFERENCES Task(TaskID),
    UNIQUE (WorkerID, TaskID)
);

-- Table: Budget
CREATE TABLE Budget (
    BudgetID INT PRIMARY KEY,
    ProjectID INT,
    EstimatedAmount FLOAT NOT NULL CHECK (EstimatedAmount >= 0),
    SpentAmount FLOAT CHECK (SpentAmount >= 0),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);

-- Table: Timeline
CREATE TABLE Timeline (
    TimelineID INT PRIMARY KEY,
    ProjectID INT,
    Phase VARCHAR(50),
    PhaseStart DATE,
    PhaseEnd DATE,
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);
INSERT INTO Project VALUES (1, 'Bridge Construction', '2025-01-10', '2025-10-10');
INSERT INTO Project VALUES (2, 'Road Expansion', '2025-02-01', '2025-08-15');

-- Worker
INSERT INTO Worker VALUES (101, 'Ram Bahadur', 35, 'Carpentry');
INSERT INTO Worker VALUES (102, 'Sita Kumari', 29, 'Masonry');

-- Task
INSERT INTO Task VALUES (1001, 'Foundation Work', 'Structural', 1);
INSERT INTO Task VALUES (1002, 'Paving', 'Finishing', 2);

-- Assignment
INSERT INTO Assignment VALUES (1, 101, 1001, '2025-01-15');
INSERT INTO Assignment VALUES (2, 102, 1002, '2025-02-10');

-- Budget
INSERT INTO Budget VALUES (1, 1, 2000000, 500000);
INSERT INTO Budget VALUES (2, 2, 1000000, 300000);

-- Timeline
INSERT INTO Timeline VALUES (1, 1, 'Planning', '2024-12-01', '2025-01-09');
INSERT INTO Timeline VALUES (2, 2, 'Execution', '2025-02-01', '2025-06-01');

SELECT * FROM Worker;

UPDATE Budget SET SpentAmount = 550000 WHERE BudgetID = 1;
DELETE FROM Timeline WHERE TimelineID = 3;
SELECT ProjectID, SUM(SpentAmount) AS TotalSpent FROM Budget GROUP BY ProjectID;
SELECT * FROM Worker WHERE SkillSet LIKE '%ry';
SELECT * FROM Project WHERE StartDate BETWEEN '2025-01-01' AND '2025-12-31';
SELECT w.WorkerName, t.TaskName
FROM Worker w
JOIN Assignment a ON w.WorkerID = a.WorkerID
JOIN Task t ON t.TaskID = a.TaskID;
CREATE VIEW ActiveProjects AS
SELECT ProjectName, StartDate, EndDate FROM Project WHERE EndDate >= CURDATE();

CREATE VIEW WorkerAssignments AS
SELECT WorkerName, TaskName FROM Worker
JOIN Assignment ON Worker.WorkerID = Assignment.WorkerID
JOIN Task ON Assignment.TaskID = Task.TaskID;