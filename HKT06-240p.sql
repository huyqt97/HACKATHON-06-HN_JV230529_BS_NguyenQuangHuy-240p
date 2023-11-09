create database quanlybanhang;
use quanlybanhang;
create table customers(
customer_id varchar(4) primary key not null,
name varchar(100) not null,
email varchar(100) not null,
phone varchar(25) not null,
address varchar(255) not null
);
create table orders(
order_id varchar(4) primary key not null,
customer_id varchar(4) not null,
order_date date not null,
total_amount double not null,
foreign key(customer_id) references customers(customer_id)
);
create table products(
product_id varchar(4) primary key not null,
name varchar(255) not null,
description text,
price double not null,
status bit default 1
);
create table orders_details(
order_id varchar(4) not  null,
product_id varchar(4) not null,
quantity int(11) not  null,
price double not null,
primary key (order_id, product_id),
foreign key(order_id) references orders(order_id),
foreign key(product_id) references products(product_id)
);
-- bai2 thêm dữ liệu vào bảng
insert into customers(customer_id,name,email,phone,address) values("C001","Nguyễn Trung Mạnh","manhnt@gmail.com","984756322","Cầy Giấy, Hà Nội"),
("C002","Hồ Hải Nam","namhh@gmail.com","984875926","Ba Vì, Hà Nội"),
("C003","Tô Ngọc Vũ","vutn@gmail.com","904725784","Mộc Châu, Sơn La"),
("C004","Phạm Ngọc Anh","anhpn@gmail.com","984635365","Vinh , Nghệ An"),
("C005","Trương Minh Cường","cuongtm@gmail.com","9897356242","Hai Bà Trưng, Hà Nội");
insert into products(product_id,name,description,price) values("P001","Iphone 13proMax","Bản 512GB, xanh lá",22999999),
("P002","Dell Vostro V3510","Core i5, RAM 8GB",14999999),
("P003","Macbook Pro M2","8CPU 10GPU 8GB 256GB",28999999),
("P004","Apple Watch Ultra","Titanium Alpine loop Small",18999999),
("P005","Airpods 2 2022","Spatial Audio",4090000);
insert into orders(order_id, customer_id, total_amount,order_date) value
("H001","C001",52999997,"2023/2/22"),
("H002","C001",80999997,"2023/3/11"),
("H003","C002",54359998,"2023/1/22"),
("H004","C003",102999995,"2023/3/14"),
("H005","C003",80999997,"2022/3/12"),
("H006","C004",110449994,"2023/2/1"),
("H007","C004",79999996,"2023/3/29"),
("H008","C005",29999998,"2023/2/14"),
("H009","C005",28999999,"2023/1/10"),
("H010","C005",149999994,"2023/4/1");
insert into orders_details(order_id, product_id, price,quantity) value
("H001", "P002", 14999999,1),
("H001", "P004", 18999999,2),
("H002", "P001", 22999999,1),
("H002", "P003", 28999999,2),
("H003", "P004", 18999999,2),
("H003", "P005", 4090000,4),
("H004", "P002", 14999999,3),
("H004", "P003", 28999999,2),
("H005", "P001", 12999999,1),
("H005", "P003", 28999999,2),
("H006", "P005", 4090000,5),
("H006", "P002", 14999999,6),
("H007", "P004", 18999999,3),
("H007", "P001", 22999999,1),
("H008", "P002", 14999999,2),
("H009", "P003", 28999999,1),
("H010", "P003", 28999999,2),
("H010", "P001", 22999999,4);
-- Bài 3: Truy vấn dữ liệu
-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .

select name,email,phone,address from customers;
-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
-- thoại và địa chỉ khách hàng).

select c.name, c.phone, c.address from customers as c join orders as o on c.customer_id = o.customer_id
 where month(o.order_date) = 3 and year(o.order_date) = 2023;

-- 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
-- tháng và tổng doanh thu ).
select month(order_date), sum(total_amount) from orders
 where year(order_date) = 2023
 group by month(order_date)
 order by month(order_date);
 --  4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
-- hàng, địa chỉ , email và số điên thoại).

select * from customers c join orders as o on c.customer_id = o.customer_id
where month(o.order_date) != 2 and year(o.order_date) = 2023;
-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
-- sản phẩm, tên sản phẩm và số lượng bán ra).

select p.product_id,p.name,sum(od.quantity) from products as p join orders_details as od on p.product_id = od.product_id
join orders as o on od.order_id = o.order_id
where month(o.order_date) = 3 and year(o.order_date) = 2023
group by p.product_id;

-- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
-- tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).
select c.customer_id,c.name, sum(o.total_amount) from customers as c join orders as o on c.customer_id = o.customer_id 
group by c.customer_id
order by sum(o.total_amount) desc;

-- 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) .
select c.name as ten_nguoi_mua, o.total_amount as "Tổng tiền", o.order_date as "Ngày", sum(od.quantity) as "Tổng sản phẩm"
from customers as c
join orders as o on c.customer_id = o.customer_id
join orders_details as od on o.order_id = od.order_id
group by c.name, o.total_amount, o.order_date
having sum(od.quantity) >= 5;

-- Bài 4: Tạo View, Procedure
-- 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
-- tiền và ngày tạo hoá đơn .
create view view_customer_order as
select c.name, c.phone,c.address,o.total_amount, o.order_date from customers as c join orders as o on c.customer_id = o.customer_id;
select * from view_customer_order;

-- 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
-- số đơn đã đặt.
create view view_sum_order_customer as
select c.name ,c.address ,c.phone ,COUNT(o.order_id) from customers as c left join orders as o on c.customer_id = o.customer_id
GROUP BY c.name, c.address, c.phone;
select * from view_sum_order_customer;

-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
-- bán ra của mỗi sản phẩm
create view product_info as
select p.name,p.description,p.price,SUM(od.quantity) from products as p
left join orders_details as od on p.product_id = od.product_id
group by p.name, p.description, p.price;
select * from product_info;

-- 4. Đánh Index cho trường `phone` và `email` của bảng Customer.
create index index_phone on customers(phone);
create index index_email on customers(email);

-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
delimiter //
create procedure get_find_by_id(in in_customer_id varchar(4))
begin
    select * from customers
    where customer_id = in_customer_id;
end //
delimiter ;
call get_find_by_id("C001");

-- 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm.
delimiter //
create procedure get_all_products()
begin
    select * from products;
end //
delimiter ;
call get_all_products;

-- 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng.
delimiter //
create procedure get_order_find_customer(in in_customer_id varchar(4))
begin
    select * from orders
    where customer_id = in_customer_id;
end //
delimiter ; 
call get_order_find_customer("C001");

-- 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
-- tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo.
delimiter //
create procedure create_new_order(in in_order_id varchar(4),in in_customer_id varchar(4),in total_amount double,in order_date date)
begin
    insert into orders (order_id,customer_id, total_amount, order_date)
    values (in_order_id,in_customer_id, total_amount, order_date);
    select in_order_id;
end //
delimiter ;
call create_new_order("H024","C005", 1000, "2023-11-08")

-- 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
-- thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc.
delimiter //
create procedure sales_statistics(in start_date date,in end_date date)
begin
    select p.product_id,p.name,sum(od.quantity) as "Số lượng bán ra"from products as p
    join orders_details as od on p.product_id = od.product_id
    join orders as o on od.order_id = o.order_id
    where o.order_date between start_date and end_date
    group by p.product_id, p.name;
end //
delimiter ;
call sales_statistics('2023-01-01', '2023-12-31');

-- 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
-- giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê.
DELIMITER //
CREATE PROCEDURE SalesStatisticsByMonth(
    IN target_month INT,
    IN target_year INT
)
BEGIN
    SELECT 
        p.product_id AS ma_san_pham,
        p.name AS ten_san_pham,
        SUM(od.quantity) AS so_luong_ban_ra
    FROM products AS p
    JOIN orders_details AS od ON p.product_id = od.product_id
    JOIN orders AS o ON od.order_id = o.order_id
    WHERE MONTH(o.order_date) = target_month
        AND YEAR(o.order_date) = target_year
    GROUP BY p.product_id, p.name
    ORDER BY so_luong_ban_ra DESC;
END //
DELIMITER ; 