PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

INSERT INTO
    users (fname, lname)
VALUES
    ("AA", "BB"), ("CC","DD");


CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,
    
    FOREIGN KEY(author_id) REFERENCES users(id)
);

INSERT INTO
    questions (title, body, author_id)
VALUES
    ("Q1", "body of Q1", (SELECT id FROM users WHERE fname = "AA" AND lname = "BB")),
    ("Q2", "body of Q2", (SELECT id FROM users WHERE fname = "CC" AND lname = "DD"));

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    author_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY(author_id) REFERENCES users(id),
    FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO
    question_follows(author_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = "AA" AND lname = "BB"),
    (SELECT id FROM questions where title = "Q1")),

    ((SELECT id FROM users WHERE fname = "CC" AND lname = "DD"),
    (SELECT id FROM questions where title = "Q1"));

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,
    parent_reply_id INTEGER,


    FOREIGN KEY(question_id) REFERENCES questions(id),
    FOREIGN KEY(author_id) REFERENCES users(id),
    FOREIGN KEY(parent_reply_id) REFERENCES replies(id)
);

INSERT INTO
    replies (question_id, author_id, body, parent_reply_id)
VALUES
    (
        (SELECT id FROM questions WHERE title = "Q1"),
        (SELECT id FROM users WHERE fname = "AA" AND lname = "BB"),
        "parent Reply",
        NULL
    );

INSERT INTO
    replies (question_id, author_id, body, parent_reply_id)
VALUES   
    (
        (SELECT id FROM questions WHERE title = "Q1"),
        (SELECT id FROM users WHERE fname = "AA" AND lname = "BB"),
        "Child Reply",
        (SELECT id FROM replies WHERE body = "parent Reply")
    );

CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    author_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY(author_id) REFERENCES users(id),
    FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO question_likes (author_id, question_id) VALUES (1, 1);
INSERT INTO question_likes (author_id, question_id) VALUES (1, 2);