use library
GO

drop PROCEDURE if EXISTS dbo.p_insert_reader
drop PROCEDURE if EXISTS dbo.p_insert_employee
drop PROCEDURE if EXISTS dbo.p_insert_author
drop PROCEDURE if EXISTS dbo.p_insert_category
drop PROCEDURE if EXISTS dbo.p_insert_paper_book
drop PROCEDURE if EXISTS dbo.p_insert_e_book
drop PROCEDURE if EXISTS dbo.p_insert_paper_book_comment
drop PROCEDURE if EXISTS dbo.p_insert_e_book_comment
drop PROCEDURE if EXISTS dbo.p_borrowed_paper_book
drop PROCEDURE if EXISTS dbo.p_borrowed_e_book




go
create PROCEDURE dbo.p_insert_reader(
    @firstname varchar(50),
    @lastname varchar(50),
    @pw varchar(50),
    @email VARCHAR(50)

)
as BEGIN
    begin TRY
        begin TRANSACTION
        if exists(select * from readers where reader_email = @email) 
        throw 50002, 'p-insert_reader: email exist',1
        
        else BEGIN
            
            insert into readers ( reader_firstname,reader_lastname,reader_pw,reader_email)
                VALUES (@firstname,@lastname,@pw,@email)
            if @@ROWCOUNT <> 1 throw 50002, 'p-insert_reader: Insert Erroe',1
        END
        COMMIT
    end try
    begin catch 
         rollback;
         throw
    end CATCH
end


go 


create PROCEDURE dbo.p_insert_employee(
    @firstname varchar(50),
    @lastname varchar(50),
    @title varchar(50),
    @email VARCHAR(50)

)
as BEGIN
    begin TRY
        begin TRANSACTION
        if exists(select * from employees where employee_email = @email) 
        throw 50002, 'p-insert_reader: email exist',1
        
        else BEGIN
            
            insert into employees ( employee_firstname,employee_lastname,employee_pw,employee_email,employee_title)
                VALUES (@firstname,@lastname,'1234',@email,@title)
            if @@ROWCOUNT <> 1 throw 50002, 'p-insert_reader: Insert Erroe',1
        END
        COMMIT
    end try
    begin catch 
         rollback;
         throw
    end CATCH
end

GO
create PROCEDURE dbo.p_insert_author(
    @name varchar(50)
)
as BEGIN
    begin TRY
        begin TRANSACTION
        if exists(select * from authors where author_name = @name) 
        throw 50002, 'p-insert_reader: author exists',1
        
        else BEGIN
            
            insert into authors ( author_name)
                VALUES (@name)
            if @@ROWCOUNT <> 1 throw 50002, 'p-insert_reader: Insert Erroe',1
        END
        COMMIT
    end try
    begin catch 
         rollback;
         throw
    end CATCH
end



GO
create PROCEDURE dbo.p_insert_category(
    @cat varchar(50)
)
as BEGIN
    begin TRY
        begin TRANSACTION
        if exists(select * from categories where category_name = @cat) 
        throw 50002, 'p-insert_reader: author exists',1
        
        else BEGIN
            
            insert into categories ( category_name)
                VALUES (@cat)
            if @@ROWCOUNT <> 1 throw 50002, 'p-insert_reader: Insert Erroe',1
        END
        COMMIT
    end try
    begin catch 
         rollback;
         throw
    end CATCH
end
drop PROCEDURE if EXISTS dbo.p_test

go
create PROCEDURE dbo.p_insert_paper_book(
    @name varchar(50),
    @ISBN varchar(50),
    @price money,
    @page int,
    @adder varchar(50),
    @publisher varchar(50)
)
as BEGIN
    begin TRY
        begin TRANSACTION
        if not exists(select * from publishers where publisher_name = @publisher) 
        throw 50002, 'p-insert_reader: publisher not exists',1

        if not exists(select * from employees where employee_email = @adder) 
        throw 50002, 'p-insert_reader: employee not exists',1

        if exists (select * from paper_books where paper_book_ISBN = @ISBN)
        throw 50002, 'p-insert_reader: book exists',1

        else BEGIN
            declare @employee   int = (select employee_id from employees where employee_email = @adder) 
            print(@employee)
            declare @publisher_id  int = (select publisher_id from publishers where publisher_name = @publisher) 
            print(@publisher_id)
            insert into paper_books(paper_book_name,paper_book_ISBN,paper_book_price,paper_book_page,paper_book_status,paper_book_stored_date,paper_book_added_by_id,paper_book_publisher_id)
            values(@name,@ISBN,@price,@page,'Available',CAST(getdate() AS date),@employee,@publisher_id)
        END
        COMMIT
    end try
    begin catch 
         rollback;
         throw
    end CATCH
end

go 

create PROCEDURE dbo.p_insert_e_book(
    @name varchar(50),
    @ISBN varchar(50),
    @price money,
    @page int,
    @adder varchar(50),
    @publisher varchar(50),
    @url varchar(50)
)
as BEGIN
    begin TRY
        begin TRANSACTION
        if not exists(select * from publishers where publisher_name = @publisher) 
        throw 50002, 'p-insert_reader: publisher not exists',1

        if not exists(select * from employees where employee_email = @adder) 
        throw 50002, 'p-insert_reader: employee not exists',1

        if exists (select * from e_books where e_book_ISBN = @ISBN)
        throw 50002, 'p-insert_reader: book exists',1

        else BEGIN
            declare @employee   int = (select employee_id from employees where employee_email = @adder) 
            print(@employee)
            declare @publisher_id  int = (select publisher_id from publishers where publisher_name = @publisher) 
            print(@publisher_id)
            insert into e_books(e_book_name,e_book_ISBN,e_book_price,e_book_page,e_book_status,e_book_stored_date,e_book_added_by_id,e_book_publisher_id,e_book_url)
            values(@name,@ISBN,@price,@page,'Available',CAST(getdate() AS date),@employee,@publisher_id,@url)
        END
        COMMIT
    end try
    begin catch 
         rollback;
         throw
    end CATCH
end

go

create PROCEDURE dbo.p_insert_paper_book_comment(
    @rater varchar(50),
    @star int,
    @book varchar(50),
    @comment varchar(50)
)
as BEGIN
    begin TRY
        begin TRANSACTION
        if not exists(select * from readers where reader_email = @rater) 
        throw 50002, 'p-insert_reader: rater not exists',1

        if not exists(select * from paper_books where paper_book_name = @book) 
        throw 50002, 'p-insert_reader: book not exists',1

        if @star > 5 
        throw 50002, 'p-insert_reader: wrong rating value',1

        if @star < 0 
        throw 50002, 'p-insert_reader: wrong rating value',1


        else BEGIN
            declare @rater_id   int = (select reader_id from readers where reader_email = @rater) 
            print(@rater_id)
            declare @book_id  int = (select paper_book_id from paper_books where paper_book_name = @book) 
            print(@book_id)
            insert into paper_books_rating(paper_book_id,rating_name_id,rating_star,rating_comment)
            values(@book_id,@rater_id,@star,@comment)
        END
        COMMIT
    end try
    begin catch 
         rollback;
         throw
    end CATCH
end

go

create PROCEDURE dbo.p_insert_e_book_comment(
    @rater varchar(50),
    @star int,
    @book varchar(50),
    @comment varchar(50)
)
as BEGIN
    begin TRY
        begin TRANSACTION
        if not exists(select * from readers where reader_email = @rater) 
        throw 50002, 'p-insert_reader: rater not exists',1

        if not exists(select * from e_books where e_book_name = @book) 
        throw 50002, 'p-insert_reader: book not exists',1

        if @star > 5 
        throw 50002, 'p-insert_reader: wrong rating value',1

        if @star < 0 
        throw 50002, 'p-insert_reader: wrong rating value',1


        else BEGIN
            declare @rater_id   int = (select reader_id from readers where reader_email = @rater) 
            print(@rater_id)
            declare @book_id  int = (select e_book_id from e_books where e_book_name = @book) 
            print(@book_id)
            insert into e_books_rating(e_book_id,rating_name_id,rating_star,rating_comment)
            values(@book_id,@rater_id,@star,@comment)
        END
        COMMIT
    end try
    begin catch 
         rollback;
         throw
    end CATCH
end




go
create PROCEDURE dbo.p_borrowed_paper_book(
    @borrower VARCHAR(50),
    @book_id int
)
as BEGIN
    begin TRY
        begin TRANSACTION
        if not exists(select * from readers where reader_email = @borrower) 
        throw 50002, 'p-insert_reader: user not exists',1

        if not exists(select * from paper_books where paper_book_id = @book_id) 
        throw 50002, 'p-insert_reader: book not exists',1

        declare @check VARCHAR(50) = (select paper_book_status from paper_books where paper_book_id = @book_id)
        if (@check = 'Unavailable')
        throw 50002, 'p-insert_reader: book Unavailable',1

        else BEGIN
            declare @due  date = DATEADD (day , 30 , CAST(getdate() AS date) )  
            declare @now  date= getdate() 
            declare @id  int = (select reader_id from readers where reader_email = @borrower)

            insert into paper_books_borrowed_history(paper_book_id,paper_book_borrowed_id,paper_book_borrowed_date,paper_book_due_date)
            values(@book_id,@id,@now,@due)
            update paper_books set paper_book_status = 'Unavailable' where paper_book_id = @book_id
        END
        COMMIT
    end try
    begin catch 
         rollback;
         throw
    end CATCH
end


go 
create PROCEDURE dbo.p_borrowed_e_book(
    @borrower VARCHAR(50),
    @book_id int
)
as BEGIN
    begin TRY
        begin TRANSACTION
        if not exists(select * from readers where reader_email = @borrower) 
        throw 50002, 'p-insert_reader: user not exists',1

        if not exists(select * from e_books where e_book_id = @book_id) 
        throw 50002, 'p-insert_reader: book not exists',1

        

        else BEGIN
            
            declare @now  date= getdate() 
            declare @id  int = (select reader_id from readers where reader_email = @borrower)

            insert into e_books_download_history(e_book_download_book_id,e_book_download_date,e_book_downloader)
            values(@book_id,@now,@id)
            
        END
        COMMIT
    end try
    begin catch 
         rollback;
         throw
    end CATCH
end



go 

