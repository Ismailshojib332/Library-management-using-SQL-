-- identify the members with overdue books( overdue when  a member don't return withhin 30 days
 -- we need to find their id ,name,book name book title issue date and days of overdue
select 
ist.issued_member_id ,
m.member_id,
bk.book_title,
ist.issued_date,
rs.return_date,
datediff(current_date,issued_date) - 30  as overdue


from issued_status as ist
join members as m 
     on m.member_id = ist.issued_member_id
join
books as bk
on bk.isbn = ist.issued_book_isbn
 left join
return_status as rs
on rs.issued_id = ist.issued_id
where rs.return_date is null
and
 datediff(current_date,issued_date) > 30 ;
 
 
 --- update the books status on return
 -- write   a query to update the status of books in the books table to "yes" when they returned .
-- based on entries in the return_status_table

select * from issued_status;
select * from books
where isbn = "978-0-330-25864-8" ;


update books
set status = "no"
where isbn = "978-0-330-25864-8"

--
INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
VALUES ('RS125', 'IS130', CURRENT_DATE, 'good');

SELECT * FROM return_status;

 -- store procedures

DROP PROCEDURE IF EXISTS add_return_record;
DELIMITER //

CREATE PROCEDURE add_return_record(
    IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(10),
    IN p_book_quality VARCHAR(20)
)
BEGIN
    DECLARE v_isbn VARCHAR(20);

    SELECT issued_book_isbn
    INTO v_isbn
    FROM issued_status
    WHERE issued_id = p_issued_id
    LIMIT 1;

    INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURDATE(), p_book_quality);

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;
END //

DELIMITER ;

-- branch performance report
-- create a query that generates a performance report for each branch,showing the number of books issued,the
-- number of book returned,and the total  revenue generated from the rentals.alter
 select * from branch;
 select * from employees;
create table branch_reports
 SELECT 
 b.branch_id,
 b.manager_id,
 count(ist.issued_id) as number_books_issued,
 count(rs.return_id) as number_books_returned,
 sum(bk.rental_price) as total_revenue
 
 
FROM issued_status AS ist
JOIN employees AS e
    ON e.emp_id = ist.issued_emp_id
JOIN branch AS b
    ON e.branch_id = b.branch_id
 left JOIN return_status AS rs
    ON rs.issued_id = ist.issued_id
    join books as bk
    on ist.issued_book_isbn = bk.isbn
    group by 1,2
    select * from branch_reports;
    -- active members checking
    CREATE TABLE active_members AS
SELECT DISTINCT
    m.member_id,
    m.member_name,
    m.member_address,
    m.reg_date
FROM members m
JOIN issued_status ist
    ON m.member_id = ist.issued_member_id
WHERE ist.issued_date >= CURDATE() - INTERVAL 30 DAY;
select * from active_members;