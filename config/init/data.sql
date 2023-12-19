CREATE DATABASE `library`;
USE `library`

CREATE TABLE authors (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL
);

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(200) NOT NULL,
    published_year INT,
    isbn VARCHAR(20)
);

CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    PRIMARY KEY (book_id, author_id)
);
