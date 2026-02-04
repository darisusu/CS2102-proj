--
-- Group Number: 123
-- Group Members: 4
--   1. Eldridge Ng
--   2. Darius Deng
--   3. Beh Shao Ren
--   4. Yu Tingan
--

-- Drop tables if they exist to allow re-execution
DROP TABLE IF EXISTS exit CASCADE;
DROP TABLE IF EXISTS result CASCADE;
DROP TABLE IF EXISTS stage CASCADE;
DROP TABLE IF EXISTS rider CASCADE;
DROP TABLE IF EXISTS team CASCADE;
DROP TABLE IF EXISTS location CASCADE;
DROP TABLE IF EXISTS country CASCADE;

-- Country table
-- A country is uniquely identified by IOC code (3-letter code)
-- We record countries even if no team is associated with them
CREATE TABLE country (
    ioc_code CHAR(3) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    region VARCHAR(50) NOT NULL,
    CHECK (LENGTH(ioc_code) = 3)
);

-- Location table
-- A location belongs to exactly one country
-- Identified by name (assuming location names are unique globally)
CREATE TABLE location (
    name VARCHAR(100) PRIMARY KEY,
    country_code CHAR(3) NOT NULL,
    FOREIGN KEY (country_code) REFERENCES country(ioc_code) ON UPDATE CASCADE
);

-- Team table
-- Each team is uniquely identified by its name
-- Each team belongs to exactly one country
CREATE TABLE team (
    name VARCHAR(100) PRIMARY KEY,
    country_code CHAR(3) NOT NULL,
    FOREIGN KEY (country_code) REFERENCES country(ioc_code) ON UPDATE CASCADE
);

-- Rider table
-- A rider is uniquely identified by bib number
-- A rider belongs to exactly one team
-- A rider may belong to at most one country (can be NULL)
CREATE TABLE rider (
    bib INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    team_name VARCHAR(100) NOT NULL,
    country_code CHAR(3),
    FOREIGN KEY (team_name) REFERENCES team(name) ON UPDATE CASCADE,
    FOREIGN KEY (country_code) REFERENCES country(ioc_code) ON UPDATE CASCADE,
    CHECK (bib > 0)
);

-- Stage table
-- Each stage is uniquely identified by stage number
-- Stage types: flat, hilly, mountain, individual time-trial, team time-trial
CREATE TABLE stage (
    stage_number INTEGER PRIMARY KEY,
    day DATE NOT NULL UNIQUE,
    start_location VARCHAR(100) NOT NULL,
    finish_location VARCHAR(100) NOT NULL,
    length NUMERIC(5,1) NOT NULL,
    type VARCHAR(30) NOT NULL,
    FOREIGN KEY (start_location) REFERENCES location(name) ON UPDATE CASCADE,
    FOREIGN KEY (finish_location) REFERENCES location(name) ON UPDATE CASCADE,
    CHECK (stage_number > 0),
    CHECK (length > 0),
    CHECK (type IN ('flat', 'hilly', 'mountain', 'individual time-trial', 'team time-trial'))
);

-- Result table
-- Individual results for each rider in each stage
-- Composite primary key: (bib, stage_number)
-- Rank should be unique per stage (no two riders with same rank in same stage)
CREATE TABLE result (
    bib INTEGER,
    stage_number INTEGER,
    rank INTEGER NOT NULL,
    time INTEGER NOT NULL,
    bonus INTEGER NOT NULL DEFAULT 0,
    penalty INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (bib, stage_number),
    FOREIGN KEY (bib) REFERENCES rider(bib) ON UPDATE CASCADE,
    FOREIGN KEY (stage_number) REFERENCES stage(stage_number) ON UPDATE CASCADE,
    UNIQUE (stage_number, rank),
    CHECK (rank > 0),
    CHECK (time > 0),
    CHECK (bonus >= 0),
    CHECK (penalty >= 0)
);

-- Exit table
-- Records when a rider exits from the race at the beginning of a particular stage
-- A rider can only exit once
-- Reasons: withdrawal, DNS (do not start), and potentially others in future
CREATE TABLE exit (
    bib INTEGER PRIMARY KEY,
    stage_number INTEGER NOT NULL,
    reason VARCHAR(50) NOT NULL,
    FOREIGN KEY (bib) REFERENCES rider(bib) ON UPDATE CASCADE,
    FOREIGN KEY (stage_number) REFERENCES stage(stage_number) ON UPDATE CASCADE,
    CHECK (reason IN ('withdrawal', 'DNS'))
);
