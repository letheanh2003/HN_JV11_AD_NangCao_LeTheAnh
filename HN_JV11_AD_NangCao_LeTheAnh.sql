create database qlbh_letheanh;
 use qlbh_letheanh;

 create table Customer(
 cID int primary key unique not null,
 cName varchar(25),
 cAge tinyint 
 );
 
 create table `Order`(
 oID int primary key unique not null,
 cID int ,
 foreign key (cID) references Customer(cID),
 oDate datetime,
 oTotalPrice int
 );
 
 create table OrderDetail(
 oId int ,
 foreign key (oId) references `Order`(oID),
 pId int,
 foreign key (pId) references Product(pID),
 odQTY int
 );
 
 create table Product(
 pID int primary key unique not null,
 pName varchar(255),
 pPrice int
 );
 
 insert into Customer(cID,cName,cAge)values
 (1,"Minh Quan",10),
 (2,"Ngoc Oanh",20),
 (3,"Hong Ha",50);
 
insert into `Order`(oID,cID,oDate,oTotalPrice) values
(1,1,"2006-3-21",null),
(2,2,"2006-3-23",null),
(3,1,"2006-3-16",null);
 
 insert into Product(pID,pName,pPrice) values
 (1,"May Giat",3),
 (2,"Tu Lanh",5),
 (3,"Dieu Hoa",7),
 (4,"Quat",1),
 (5,"Bep Dien",2);
 
 insert into OrderDetail(oID,pID,odQTY) values
 (1,1,3),
 (1,3,7),
 (1,4,2),
 (2,1,1),
 (3,1,8),
 (2,5,4),
 (2,3,3);
 
 
 -- 2. Hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order, danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn nằm
 select `Order`.oID,`Order`.cID,`Order`.oDate,`Order`.oTotalPrice from `Order` order by `Order`.oDate Desc;
 -- 3. Hiển thị tên và giá của các sản phẩm có giá cao nhất
select pName,pPrice from Product where pPrice = (select max(pPrice)from Product);
-- 4. Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó 
select c.cName, p.pName, od.odQTY
from Customer c
inner join `Order` o on c.cID = o.cID
inner join OrderDetail od on o.oID = od.oID
inner join Product p on od.pID = p.pID
order by c.cName;
-- 5. Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
select c.cName
from Customer c
left join `Order` o on c.cID = o.cID
left join OrderDetail od on o.oID = od.oID
where od.oID is null;
-- 6.Hiển thị chi tiết của từng hóa đơn 
select o.oID, c.cName, o.oDate, od.odQTY,p.pName,p.pPrice
from `Order` o
inner join Customer c on o.cID = c.cID
inner join OrderDetail od on o.oID = od.oID
inner join Product p on od.pID = p.pID
order by o.oID;
-- 7 Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiệntrong hóa đơn. Giá bán của từng loại được tính = odQTY*pPrice
select o.oID, o.oDate, sum(od.odQTY * p.pPrice) as TotalPrice
from `Order` o
inner join OrderDetail od on o.oID = od.oID
inner join Product p on od.pID = p.pID
group by o.oID, o.oDate;
-- 8 Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị
create view Sales as
select sum(od.odQTY * p.pPrice) as TotalRevenue
from `Order` o
inner join OrderDetail od on o.oID = od.oID
inner join Product p on od.pID = p.pID;
-- 9 Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng
ALTER TABLE OrderDetail drop foreign key OrderDetail_ibfk_1;
ALTER TABLE OrderDetail drop foreign key OrderDetail_ibfk_2;
alter table `Order` drop constraint `Order_ibfk_1`;

alter table Customer drop primary key;
alter table Product drop primary key;
alter table `Order` drop primary key;

-- 10 Tạo một trigger tên là cusUpdate trên bảng Customer, sao cho khi sửa mã khách (cID) thì mã khách trong bảng Order cũng được sửa theo: