--create database library
--GO
use library

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_paper_books_paper_book_added_by_id')
    alter table paper_books drop CONSTRAINT fk_paper_books_paper_book_added_by_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_paper_books_paper_book_publisher_id')
    alter table paper_books drop CONSTRAINT fk_paper_books_paper_book_publisher_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_e_books_e_book_added_by_id')
    alter table e_books drop CONSTRAINT fk_e_books_e_book_added_by_id
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_e_books_e_book_publisher_id')
    alter table e_books drop CONSTRAINT fk_e_books_e_book_publisher_id
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_paper_books_borrowed_history_paper_book_id')
    alter table paper_books_borrowed_history drop CONSTRAINT fk_paper_books_borrowed_history_paper_book_id
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_paper_books_borrowed_history_paper_book_borrowed_id')
    alter table paper_books_borrowed_history drop CONSTRAINT fk_paper_books_borrowed_history_paper_book_borrowed_id
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_e_books_download_history_e_book_downloader')
    alter table e_books_download_history drop CONSTRAINT fk_e_books_download_history_e_book_downloader
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_e_books_download_history_e_book_download_book_id')
    alter table e_books_download_history drop CONSTRAINT fk_e_books_download_history_e_book_download_book_id
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_paper_books_rating_paper_book_id')
    alter table paper_books_rating drop CONSTRAINT fk_paper_books_rating_paper_book_id
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_paper_books_rating_rating_name_id')
    alter table paper_books_rating drop CONSTRAINT fk_paper_books_rating_rating_name_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_e_books_rating_e_book_rating_id')
    alter table e_books_rating drop CONSTRAINT fk_e_books_rating_e_book_rating_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_e_books_rating_rating_name_id')
    alter table e_books_rating drop CONSTRAINT fk_e_books_rating_rating_name_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_paper_book_categories_paper_books_id')
    alter table paper_book_categories drop CONSTRAINT fk_paper_book_categories_paper_books_id
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_paper_book_categories_categories_id')
    alter table paper_book_categories drop CONSTRAINT fk_paper_book_categories_categories_id
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_e_book_categories_e_books_id')
    alter table e_book_categories drop CONSTRAINT fk_e_book_categories_e_books_id
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_e_book_categories_categories_id')
    alter table e_book_categories drop CONSTRAINT fk_e_book_categories_categories_id
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_paper_book_author_paper_books_id')
    alter table paper_book_author drop CONSTRAINT fk_paper_book_author_paper_books_id
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_paper_book_author_author_id')
    alter table paper_book_author drop CONSTRAINT fk_paper_book_author_author_id
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_e_book_author_e_books_id')
    alter table e_book_author drop CONSTRAINT fk_e_book_author_e_books_id
    
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_NAME ='fk_e_book_author_author_id')
    alter table e_book_author drop CONSTRAINT fk_e_book_author_author_id

drop table if exists categories
drop table if exists authors
drop table if exists employees
drop table if exists publishers
drop table if exists readers
drop table if exists paper_books
drop table if exists e_books
drop table if exists paper_books_borrowed_history
drop table if exists e_books_download_history
drop table if exists paper_books_rating
drop table if exists e_books_rating
drop table if exists paper_book_categories
drop table if exists e_book_categories
drop table if exists paper_book_author
drop table if exists e_book_author


create table categories(
    category_id int IDENTITY not null,
    category_name varchar(50) not null,
    constraint pk_categories_category_id primary key(category_id)
)

create table authors (
    author_id int IDENTITY not null,
    author_name varchar(50) not null,
    constraint pk_authors_author_id primary key(author_id)
)

create table employees(
    employee_id int IDENTITY not null,
    employee_firstname varchar(50) not null,
    employee_lastname varchar(50) not null,
    employee_pw varchar(50) not null,
    employee_title varchar(50) not null,
    employee_email varchar(50) not null,
    constraint u_employee_email unique (employee_email),
    constraint pk_employee_employee_id primary key(employee_id)
)

create table publishers(
    publisher_id int IDENTITY not null,
    publisher_name varchar(50) not null,
    publisher_primary_address varchar(50) not null,
    publisher_secondary_address varchar(50),
    publisher_city varchar(50) not null,
    publisher_region varchar(50) not null,
    publisher_zipcode varchar(50) not null,
    publisher_country varchar(50) not null,
    constraint u_publisher_name unique (publisher_name),
    constraint pk_publishers_publisher_id primary key(publisher_id)
)

create table readers(
    reader_id int IDENTITY not null,
    reader_firstname varchar(50) not null,
    reader_lastname varchar(50) not null,
    reader_pw varchar(50) not null,
    reader_email varchar(50) not null,
    constraint u_reader_email unique (reader_email),
    constraint pk_reader_reader_id primary key(reader_id)
)

create table paper_books(
    paper_book_id int IDENTITY not null,
    paper_book_name varchar(50) not null,
    paper_book_ISBN varchar(50) not null,
    paper_book_price money,
    paper_book_page int,
    paper_book_status varchar(50) not null,
    paper_book_stored_date date not null,
    paper_book_added_by_id int not null,
    paper_book_publisher_id int not null,
    constraint u_paper_book_ISBN unique (paper_book_ISBN),
    constraint pk_paper_books_paper_book_id primary key(paper_book_id)
)




create table e_books(
    e_book_id int IDENTITY not null,
    e_book_name varchar(50) not null,
    e_book_ISBN varchar(50) not null,
    e_book_price money,
    e_book_page int,
    e_book_status varchar(50) not null,
    e_book_stored_date date,
    e_book_added_by_id int not null,
    e_book_publisher_id int not null,
    e_book_url varchar(100) not null,
    constraint u_e_book_ISBN unique (e_book_ISBN),
    constraint pk_e_books_e_book_id primary key(e_book_id)
)




create table paper_books_borrowed_history(
    paper_book_borrowed_history_id int IDENTITY not null,
    paper_book_id int not null,
    paper_book_borrowed_id int not null,
    paper_book_borrowed_date date not null,
    paper_book_return_date date,
    paper_book_due_date date not null,
    constraint pk_paper_books_borrowed_history_paper_book_borrowed_history_id primary key(paper_book_borrowed_history_id)
)




create table e_books_download_history(
    e_books_download_history_id int IDENTITY not null,
    e_book_downloader int not null,
    e_book_download_date date not null,
    e_book_download_book_id int not null,
    constraint pk_e_books_borrowed_history_e_books_download_history_id primary key(e_books_download_history_id)
)



create table paper_books_rating(
    paper_book_rating_id int IDENTITY not null,
    paper_book_id int not null,
    rating_name_id int not null,
    rating_star int not null,
    rating_comment varchar(50),
    constraint pk_paper_books_rating_paper_book_rating_id primary key(paper_book_rating_id)

)



create table e_books_rating(
    e_book_rating_id int IDENTITY not null,
    e_book_id int not null,
    rating_name_id int not null,
    rating_star int not null,
    rating_comment varchar(50),
    constraint pk_e_books_rating_e_book_rating_id primary key(e_book_rating_id)

)

create table paper_book_categories(
    paper_book_id int not null,
    category_id int not null
)



create table e_book_categories(
    e_book_id int not null,
    category_id int not null
)



create table paper_book_author(
    paper_book_id int not null,
    author_id int not null
)



create table e_book_author(
    e_book_id int not null,
    author_id int not null
)


    

alter table paper_books
    add CONSTRAINT fk_paper_books_paper_book_added_by_id foreign key (paper_book_added_by_id)
        references employees(employee_id)

alter table paper_books
    add CONSTRAINT fk_paper_books_paper_book_publisher_id foreign key (paper_book_publisher_id)
        references publishers(publisher_id)

alter table e_books
    add CONSTRAINT fk_e_books_e_book_added_by_id foreign key (e_book_added_by_id)
        references employees(employee_id)

alter table e_books
    add CONSTRAINT fk_e_books_e_book_publisher_id foreign key (e_book_publisher_id)
        references publishers(publisher_id)


alter table paper_books_borrowed_history
    add CONSTRAINT fk_paper_books_borrowed_history_paper_book_id foreign key (paper_book_id)
        references paper_books(paper_book_id)

alter table paper_books_borrowed_history
    add CONSTRAINT fk_paper_books_borrowed_history_paper_book_borrowed_id  foreign key (paper_book_borrowed_id )
        references readers(reader_id)

alter table e_books_download_history
    add CONSTRAINT fk_e_books_download_history_e_book_downloader foreign key (e_book_downloader)
        references e_books(e_book_id)

alter table e_books_download_history
    add CONSTRAINT fk_e_books_download_history_e_book_download_book_id  foreign key (e_book_download_book_id )
        references readers(reader_id)

alter table paper_books_rating
    add CONSTRAINT fk_paper_books_rating_paper_book_id foreign key (paper_book_id)
        references paper_books(paper_book_id)

alter table paper_books_rating
    add CONSTRAINT fk_paper_books_rating_rating_name_id  foreign key (rating_name_id )
        references readers(reader_id)


alter table e_books_rating
    add CONSTRAINT fk_e_books_rating_e_book_rating_id foreign key (e_book_rating_id)
        references e_books(e_book_id)

alter table e_books_rating
    add CONSTRAINT fk_e_books_rating_rating_name_id  foreign key (rating_name_id )
        references readers(reader_id)


alter table paper_book_categories
    add CONSTRAINT fk_paper_book_categories_paper_books_id foreign key (paper_book_id)
        references paper_books(paper_book_id)

alter table paper_book_categories
    add CONSTRAINT fk_paper_book_categories_categories_id  foreign key (category_id )
        references categories(category_id)


alter table e_book_categories
    add CONSTRAINT fk_e_book_categories_e_books_id foreign key (e_book_id)
        references e_books(e_book_id)

alter table e_book_categories
    add CONSTRAINT fk_e_book_categories_categories_id  foreign key (category_id )
        references categories(category_id)



alter table paper_book_author
    add CONSTRAINT fk_paper_book_author_paper_books_id foreign key (paper_book_id)
        references paper_books(paper_book_id)

alter table paper_book_author
    add CONSTRAINT fk_paper_book_author_author_id  foreign key (author_id)
        references authors(author_id)

alter table e_book_author
    add CONSTRAINT fk_e_book_author_e_books_id foreign key (e_book_id)
        references e_books(e_book_id)

alter table e_book_author
    add CONSTRAINT fk_e_book_author_author_id  foreign key (author_id)
        references authors(author_id)


-- the below code is used to add data
--1.employee table
DELETE FROM employees;
INSERT INTO employees (Employee_FirstName, Employee_LastName, Employee_Pw, Employee_Title, Employee_Email)
VALUES ('Amber', 'Smith', '1234', 'librarian', 'amber@syr.edu'),
       ('Lily', 'Green', '1234', 'librarian', 'lily@syr.edu'),
       ('Bob', 'King', '1234', 'manager', 'bob@syr.edu');

--2. readers
delete from readers
INSERT INTO readers (reader_firstname, reader_lastname, reader_pw, reader_email)
VALUES ('Julia', 'Green', '1234', 'julia.green@email.com'),
       ('John', 'Smith', '1234', 'john.smith@email.com'),
       ('Rachel', 'Jones', '1234', 'rachel.jones@email.com'),
       ('Simon', 'Williams', '1234', 'simon.williams@email.com'),
       ('Lily', 'Brown', '1234', 'lily.brown@email.com');

GO


--3. publishers
delete from publishers
INSERT INTO publishers (publisher_name, publisher_primary_address, publisher_city, publisher_region, publisher_zipcode, publisher_country)
VALUES ('Scholastic', '1230 Avenue of the Americas', 'New York', 'NY', '10020', 'USA'),
('Nimble Books', '60 S. Market St. #100', 'San Jose', 'CA', '95113', 'USA'),
('Gramercy Books', '2424 E Main St', 'Bexley', 'Oh', '43209', 'USA'),
('Del Rey Books', '1745 Broadway', 'New York', 'NY', '10020', 'USA'),
('Crown', '1745 Broadway Fl 13', 'New York', 'NY', '10019', 'USA'),
('Random House Audio', '10807 New Allegiance Drive, Suite 500', 'New York', 'NY', '10019', 'USA'),
('Wings Books', '814 N. Franklin St.', 'Chicago', 'IL', '60610', 'USA'),
('Broadway Books', '1745 Broadway', 'New York', 'NY', '10019', 'USA'),
('William Morrow Paperbacks', '1745 Broadway', 'New York', 'NY', '10019', 'USA'),
('Ballantine Books', '1745 Broadway', 'New York', 'NY', '10019', 'USA'),
('Houghton Mifflin Harcourt', '222 Berkeley Street', 'Boston', 'MA', '21160', 'USA'),
('Signet', '1745 Broadway', 'New York', 'NY', '10019', 'USA'),
('Simply Media', '1230 Avenue of the Americas', 'New York', 'NY', '10020', 'USA'),
('Caedmon', '1745 Broadway', 'New York', 'NY', '10019', 'USA'),
('Recorded Books', '1745 Broadway', 'New York', 'NY', '10019', 'USA');
go

--4. authors
delete from authors
INSERT INTO authors (author_name) VALUES ('J.K. Rowling'), ('W. Frederick Zimmerman'), ('Douglas Adams'), ('Bill Bryson'), ('J.R.R. Tolkien'), ('Stephen Fry'), ('J.D. Salinger'), ('F. Scott Fitzgerald'), ('Harper Lee'), ('Various'), ('Antoine de Saint-Exupéry'), ('Paulo Coelho'), ('Khaled Hosseini'), ('Suzanne Collins'), ('John Steinbeck'), ('Ernest Hemingway'), ('Miyamoto Musashi'), ('Sun Tzu'), ('George Orwell');

--5.categories
delete from categories;
INSERT INTO categories (category_name) 
VALUES ('Fiction'), ('Romance'), ('Mystery'), ('Thriller'), ('Horror'), ('Science'), ('Fantasy'), ('History'), ('Classics'), ('Biography'), ('Politics'), ('Cookbooks'), ('Education'), ('Travel'), ('Religious'), ('Philosophy');


--6.paper_books
delete from paper_books;
INSERT INTO paper_books (paper_book_name, paper_book_ISBN, paper_book_price, paper_book_page, paper_book_status, paper_book_stored_date, paper_book_added_by_id, paper_book_publisher_id)
VALUES ('Harry Potter and the Chamber of Secrets', '439554896', 14.42, 352, 'Available', '03/03/2020', 1, 1),
('Unauthorized Harry Potter Book Seven News', '976540606', 13.74, 152, 'Available', '05/10/2020', 1, 2),
('Harry Potter Collection#1-6', '439827604', 4.73, 3342, 'Available', '06/15/2020', 1, 1),
('Five Complete Novels and One Story5)', '517226952', 24.38, 815, 'Available', '07/20/2020', 1, 3),
('The Ultimate Hitchhikers Guide to the Galaxy#1-5', '345453743', 34.38, 815, 'Available', '08/30/2020', 2, 4),
('The Hitchhikers Guide to the Galaxy #1', '1400052920', 24.22, 215, 'Available', '09/05/2020', 2, 5),
('The Hitchhikers Guide to the Galaxy', '739322206', 44.22, 6, 'Available', '10/10/2020', 2, 6),
('The Ultimate Hitchhikers Guide', '517149257', 14.38, 815, 'Available', '10/20/2020', 2, 7),
('A Short History of Nearly Everything', '076790818X', 14.21, 544, 'Available', '11/15/2020', 1, 8),
('Bill Brysons African Diary', '767915062', 3.44, 55, 'Available', '11/25/2020', 1, 8),
('Brysons Dictionary of Troublesome Words', '767910435', 3.87, 256, 'Available', '12/01/2020', 1, 8),
('In a Sunburned Country', '767903862', 4.07, 335, 'Available', '12/10/2020', 1, 8),
('Im a Stranger Here Myself', '076790382X', 3.9, 304, 'Available', '12/20/2020', 1, 8),
('The Lost Continent: Travels in Small Town America', '60920084', 13.83, 299, 'Available', '01/03/2021', 1, 9),
('Neither Here nor There: Travels in Europe', '380713802', 3.86, 254, 'Available', '01/15/2021', 1, 9),
('Notes from a Small Island', '380727501', 13.91, 324, 'Available', '03/03/2021', 2, 9),
('The Mother Tongue: English and How It Got That Way', '380715430', 23.93, 270, 'Available', '05/10/2021', 2, 9),
('The Hobbit and The Lord of the Rings', '345538374', 14.59, 1728, 'Available', '06/15/2021', 2, 10),
('The Lord of the Rings#1-3', '618517650', 4.5, 1184, 'Available', '07/20/2021', 2, 11),
('The Fellowship of the Ring #1', '618346252', 4.36, 398, 'Available', '08/30/2021', 2, 11);


--7.e_books
delete from e_books
INSERT INTO e_books (e_book_name, e_book_ISBN, e_book_price, e_book_page, e_book_status, e_book_stored_date, e_book_added_by_id, e_book_publisher_id, e_book_url)
VALUES ('The Catcher in the Rye', '9780140237506', '$10.99', 215, 'Available', '03/03/2020', 1, 12, 'https://www.amazon.com/Animal-Farm-George-Orwell'),
('The Great Gatsby', '9788374859727', '$9.99', 180, 'Available', '05/10/2020', 1, 13, 'https://www.amazon.com/The-Great-Gatsby/dp/B08R7V41DH'),
('To Kill a Mockingbird', '9780061120084', '$8.99', 280, 'Available', '06/15/2020', 1, 14, 'https://www.amazon.com/To-Kill-Mockingbird-Harper-Lee-audiobook'),
('The Bible', '9780828003033', '$19.99', 1220, 'Available', '07/20/2020', 1, 14, 'www.amazon.com/thebible'),
('The Lord of the Rings', '9780261102355', '$14.99', 952, 'Available', '08/30/2020', 2, 15, 'www.amazon.com/thelordoftherings'),
('The Little Prince', '9780156012195', '$7.99', 77, 'Available', '09/05/2020', 2, 15, 'www.amazon.com/thelittleprince'),
('The Alchemist', '9780061122415', '$10.99', 197, 'Available', '10/10/2020', 2, 1, 'www.amazon.com/thealchemist'),
('The Hitchhikers Guide to the Galaxy', '9780345391803', '$11.99', 223, 'Available', '10/20/2020', 2, 2, 'www.amazon.com/thehitchhikersguidetothegalaxy'),
('The Kite Runner', '9780330440751', '$9.99', 344, 'Available', '11/15/2020', 1, 3, 'www.amazon.com/thekiterunner'),
('The Hunger Games', '9780439023528', '$12.99', 374, 'Available', '11/25/2020', 1, 6, 'www.amazon.com/thehungergames'),
('The Grapes of Wrath', '9780670025581', '$13.99', 456, 'Available', '12/01/2020', 1, 7, 'www.amazon.com/thegrapesofwrath'),
('The Sun Also Rises', '9780684830493', '$14.99', 234, 'Available', '12/10/2020', 1, 8, 'www.amazon.com/thesunalsorises'),
('The Book of Five Rings', '9780870406744', '$8.99', 112, 'Available', '12/20/2020', 1, 9, 'www.amazon.com/thebookoffiverings'),
('The Art of War', '9780804834373', '$9.99', 150, 'Available', '01/03/2021', 1, 4, 'www.amazon.com/theartofwar'),
('Animal Farm', '9780143135081', '$10.99', 124, 'Available', '01/15/2021', 1, 4, 'www.amazon.com/animalfarm');



--8.e_book_author
delete from e_book_author;
INSERT INTO e_book_author(e_book_id, author_id)
VALUES (1,7), (2,8), (3,9), (4,9), (5,5), (6,11), (7,12), (8,3), (9,13), (10,14), (11,15), (12,16), (13,17), (14,18), (15,19);

--9.e_book_categories
delete from e_book_categories;
INSERT INTO e_book_categories (e_book_id, category_id)
VALUES (1, 1), (2, 1), (3, 1), (4, 1), (5, 7), (6, 1), (7, 1), (8, 1), (9, 1), (10, 1), (11, 1), (12, 1), (13, 16), (14, 16), (15, 1), (4, 5), (8, 6);


--10.e_books_download_history
delete from e_books_download_history;
INSERT INTO e_books_download_history (e_book_downloader, e_book_download_date, e_book_download_book_id)
VALUES (1, '2022/1/2', 1), (2, '2022/1/3', 1), (1, '2022/1/4', 1), (2, '2022/1/5', 2), (4, '2022/1/6', 2), (3, '2022/1/7', 2), (5, '2022/1/8', 3);

--11.e_books_rating
delete from e_books_rating;
INSERT INTO e_books_rating (e_book_id, rating_name_id, rating_star, rating_comment)
VALUES
(1, 1, 5, 'So good'),
(1, 2, 4, 'Nice'),
(1, 1, 5, 'Very good'),
(2, 2, 4, 'I like it'),
(2, 4, 1, 'Bad'),
(2, 3, 2, 'just so so'),
(3, 5, 3, 'OK');


--12.paper_book_author
delete from paper_book_author
INSERT INTO paper_book_author (paper_book_id, author_id) VALUES (1,1), (2,2), (3,1), (4,3), (5,3), (6,3), (7,3), (7,6), (8,3), (9,4), (10,4), (11,4), (12,4), (13,4), (14,4), (15,4), (16,4), (17,4), (18,5), (19,5), (20,5);


--13.paper_book_categories
delete from paper_book_categories;
INSERT INTO paper_book_categories
(paper_book_id, category_id)
VALUES
(1,1),
(2,3),
(3,1),
(4,2),
(5,2),
(6,2),
(7,2),
(8,2),
(9,8),
(10,14),
(11,13),
(12,13),
(13,9),
(14,14),
(15,14),
(16,10),
(17,13),
(18,1),
(19,1),
(20,1),
(1,3),
(3,3),
(4,9),
(5,9),
(6,9),
(7,9),
(8,9);


--14.paper_books_borrowed_history
delete from paper_books_borrowed_history;
INSERT INTO paper_books_borrowed_history (paper_book_id, paper_book_borrowed_id, paper_book_borrowed_date, paper_book_return_date, paper_book_due_date)
VALUES (1, 1, '2020/2/1', '2020/2/5', '2020/3/1'),
(2, 2, '2020/2/2', '2020/2/20', '2020/3/2'),
(3, 3, '2020/2/3', '2020/2/13', '2020/3/3'),
(4, 4, '2020/2/4', '2020/2/14', '2020/3/4'),
(3, 1, '2020/5/5', '2020/5/15', '2020/6/5'),
(4, 2, '2020/4/6', '2020/4/16', '2020/5/6'),
(3, 4, '2020/7/7', '2020/7/17', '2020/8/7'),
(5, 4, '2020/2/8', '2020/2/18', '2020/3/8');


--15.paper_books_rating
delete from paper_books_rating;
INSERT INTO paper_books_rating (paper_book_id, rating_name_id, rating_star, rating_comment)
VALUES (1, 1, 5, 'So good'), (2, 2, 4, 'nice'), (3, 3, 5, 'Very good'), (4, 4, 4, 'I like it'), (3, 1, 1, 'bad'), (4, 2, 2, 'just so so'), (3, 4, 3, 'OK'), (5, 4, 5, 'Pretty!');


select count(*) from employees
select count(*) from readers
select count(*) from publishers
select count(*) from authors
select count(*) from categories
select count(*) from paper_books
select count(*) from e_books
select count(*) from e_book_author
select count(*) from e_book_categories
select count(*) from e_books_download_history
select count(*) from e_books_rating
select count(*) from paper_book_author
select count(*) from paper_book_categories
select count(*) from paper_books_borrowed_history
select count(*) from paper_books_rating

