-- Multi-Table Sorgu Pratiği

-- Tüm ürünler(product) için veritabanındaki ProductName ve CategoryName'i listeleyin. (77 kayıt göstermeli)
select p.ProductName,c.CategoryName from Product as p
join Category as c on c.Id = p.CategoryId

-- 9 Ağustos 2012 öncesi verilmiş tüm siparişleri(order) için sipariş id'si (Id) ve gönderici şirket adını(CompanyName)'i listeleyin. (429 kayıt göstermeli)
select o.OrderDate,o.Id as 'SiparisId',c.CompanyName from [Order] as o
join Customer as c on c.Id = o.CustomerId
where o.OrderDate<'2012-08-09'
-- Id'si 10251 olan siparişte verilen tüm ürünlerin(product) sayısını ve adını listeleyin. ProdcutName'e göre sıralayın. (3 kayıt göstermeli)
select p.ProductName,Count(od.ProductId) as 'Urun_Sayisi' from [OrderDetail] od
left join Product p on p.Id = od.ProductId
where OrderId = 10251
group by od.ProductId
-- Her sipariş için OrderId, Müşteri'nin adını(Company Name) ve çalışanın soyadını(employee's LastName). Her sütun başlığı doğru bir şekilde isimlendirilmeli. (16.789 kayıt göstermeli)
select o.Id as 'OrderId',c.CompanyName,e.LastName from [Order] as o
join Employee e on o.EmployeeId = e.Id
join Customer c on c.Id = o.CustomerId
-------------------------------------------
------------Esnek Görevler-----------------
----Her gönderici tarafından gönderilen gönderi sayısını bulun.--------
SELECT c.CustomerName,Count(*) as 'SiparisSayisi' FROM [Orders] o
join Customers c on o.CustomerID = c.CustomerID
group by o.CustomerId
order by Count(*) desc

----------------------------- ------------------
SELECT e.FirstName,e.LastName, count(*) FROM [Orders] o
join Employees e on e.EmployeeID = o.EmployeeID
group by o.EmployeeId
order by Count(*) desc
limit 5
-------------------- Gelir olarak ölçülen en iyi performans gösteren ilk 5 çalışanı bulun -----------
SELECT e.FirstName,e.LastName,Sum(od.Quantity * p.Price) as 'SiparisTutari' FROM [OrderDetails] od
join Orders o on od.OrderID = o.OrderID
join Products p on od.ProductID = p.ProductID
join Employees e on e.EmployeeID = o.EmployeeID
group by o.EmployeeId
order by Sum(od.Quantity * p.Price) desc
limit 5
----------------------------------------------- En az gelir getiren kategoriyi bulun. --------------
SELECT c.CategoryName,Sum(od.Quantity * p.Price) as 'SiparisTutari' FROM [OrderDetails] od
join Orders o on od.OrderID = o.OrderID
join Products p on od.ProductID = p.ProductID
join Categories c on c.CategoryID = p.CategoryID
group by p.CategoryID
order by Sum(od.Quantity * p.Price) asc
limit 1

---------------- En çok siparişi olan müşteri ülkesini bulun.---------------------- 
SELECT c.CustomerName,C.Country, count(*) as 'SiparisSayisi' FROM [Orders] o
join Customers c on c.CustomerID = o.CustomerID
group by o.CustomerID order by Count(*) desc