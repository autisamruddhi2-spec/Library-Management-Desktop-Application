CREATE DATABASE library_db;
USE library_db;

CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    year INT,
    quantity INT NOT NULL,
    available INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address TEXT,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role ENUM('ADMIN', 'USER') DEFAULT 'USER'
);
INSERT INTO users (username, password, role)
VALUES ('admin', 'admin123', 'ADMIN');

CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('BORROWED', 'RETURNED', 'OVERDUE') DEFAULT 'BORROWED',

    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE
);

CREATE INDEX idx_book_title ON books(title);
CREATE INDEX idx_book_author ON books(author);
CREATE INDEX idx_member_name ON members(name);

INSERT INTO books (isbn, title, author, genre, year, quantity, available)
VALUES
('9780134685991', 'Effective Java', 'Joshua Bloch', 'Programming', 2018, 10, 10),
('9780596009205', 'Head First Java', 'Kathy Sierra', 'Programming', 2020, 8, 8),
('9780132350884', 'Clean Code', 'Robert Martin', 'Programming', 2008, 5, 5);

INSERT INTO members (name, email, phone, address)
VALUES
('Alice Johnson', 'alice@email.com', '9876543210', 'City A'),
('Bob Smith', 'bob@email.com', '8765432109', 'City B');

DELIMITER $$

CREATE TRIGGER after_borrow
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    UPDATE books
    SET available = available - 1
    WHERE id = NEW.book_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER after_return
AFTER UPDATE ON transactions
FOR EACH ROW
BEGIN
    IF NEW.status = 'RETURNED' THEN
        UPDATE books
        SET available = available + 1
        WHERE id = NEW.book_id;
    END IF;
END$$

DELIMITER ;

select * from books;
select * from members;
select * from transactions;

