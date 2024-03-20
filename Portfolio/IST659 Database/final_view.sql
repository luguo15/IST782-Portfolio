use library

drop view if exists user_view_paper_books
drop view if exists user_view_e_books
drop view if exists employee_view_paper_books
drop view if exists view_e_book_download
drop view if exists view_paper_book_rent_history
drop view if exists view_reader
drop view if exists view_employee
drop view if exists view_e_book_rating
drop view if exists view_paper_book_rating

go 

create view user_view_paper_books as
with temp(paper_book_id,category_name)  as 
    (select paper_book_id,STRING_AGG(category_name, '; ') 
    from paper_book_categories join categories on paper_book_categories.category_id  = categories.category_id
    group by paper_book_id)

SELECT paper_book_name,paper_book_ISBN,paper_book_page,paper_book_status,category_name,publisher_name from paper_books 
    join  temp on temp.paper_book_id=paper_books.paper_book_id
    join publishers on paper_book_publisher_id=publisher_id

go 

create view user_view_e_books as 
with temp(e_book_id,category_name)  as 
    (select e_book_id,STRING_AGG(category_name, '; ') 
    from e_book_categories join categories on e_book_categories.category_id  = categories.category_id
    group by e_book_id)

SELECT e_book_name,e_book_ISBN,e_book_page,e_book_status,category_name,publisher_name from e_books 
    join  temp on temp.e_book_id=e_books.e_book_id
    join publishers on e_book_publisher_id=publisher_id

go 

create view employee_view_paper_books as 
with temp(paper_book_id,category_name)  as 
    (select paper_book_id,STRING_AGG(category_name, '; ') 
    from paper_book_categories join categories on paper_book_categories.category_id  = categories.category_id
    group by paper_book_categories.paper_book_id)
select paper_book_name,paper_book_ISBN,paper_book_price,paper_book_page,paper_book_status,paper_book_stored_date,employee_firstname + ' ' + employee_lastname as stored_by ,
    publisher_name,category_name from paper_books
    join  temp on temp.paper_book_id=paper_books.paper_book_id
    join employees on paper_books.paper_book_added_by_id = employees.employee_id
    join publishers on paper_book_publisher_id=publisher_id
    

go

create view view_e_book_download as 
select reader_firstname + ' ' + reader_lastname as downloader , e_book_name, e_book_download_date from e_books_download_history
    join readers on e_book_downloader = reader_id
    join e_books on e_book_id = e_book_download_book_id

go 

create view view_paper_book_rent_history as 
select reader_firstname + ' ' + reader_lastname as borrower, paper_book_name, paper_book_borrowed_date, paper_book_return_date,paper_book_due_date from paper_books_borrowed_history
    join readers on paper_book_borrowed_id = reader_id
    join paper_books on paper_books.paper_book_id = paper_books_borrowed_history.paper_book_id


go 

create view view_reader as 
select reader_firstname + ' ' + reader_lastname as reader_name, reader_email from readers

go 

create view view_employee as 
select employee_firstname + ' ' + employee_lastname as employee_name, employee_email from employees

go 


create view view_e_book_rating as 
select reader_firstname + ' ' + reader_lastname as rater , e_book_name , rating_star,rating_comment from e_books_rating
    join readers on rating_name_id = reader_id
    join e_books on e_books_rating.e_book_id = e_books.e_book_id

go 

create view view_paper_book_rating as 
select reader_firstname + ' ' + reader_lastname as rater , paper_book_name , rating_star,rating_comment from paper_books_rating
    join readers on rating_name_id = reader_id
    join paper_books on paper_books.paper_book_id = paper_books_rating.paper_book_id




go 

