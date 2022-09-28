/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, JOIN".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД WideWorldImporters можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/

select StockItemID, StockItemName from Warehouse.StockItems where StockItemName like '%urgent%' or StockItemName like 'Animal%'

/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/

select s.SupplierID, s.SupplierName  from Purchasing.Suppliers s
left join Purchasing.PurchaseOrders po
on s.SupplierID = po.SupplierID
where PurchaseOrderID is null


/*
3. Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ
* название месяца, в котором был сделан заказ
* номер квартала, в котором был сделан заказ
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.

Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/


select o.OrderID,  CONVERT(nvarchar(80) ,OrderDate, 105) as OrderDate,
case 
when MONTH(OrderDate) = 1 then 'January'
when MONTH(OrderDate) = 2 then 'February' 
when MONTH(OrderDate) = 3 then 'March' 
when MONTH(OrderDate) = 4 then 'April' 
when MONTH(OrderDate) = 5 then 'May' 
when MONTH(OrderDate) = 6 then 'June' 
when MONTH(OrderDate) = 7 then 'July' 
when MONTH(OrderDate) = 8 then 'August' 
when MONTH(OrderDate) = 9 then 'September' 
when MONTH(OrderDate) = 10 then 'October' 
when MONTH(OrderDate) = 11 then 'November' 
when MONTH(OrderDate) = 12 then 'December ' 
end Month,
CASE 
	when MONTH(OrderDate) <= 3 then '1 '
	when MONTH(OrderDate) > 3 and MONTH(OrderDate) <= 6 then '2 '
	when MONTH(OrderDate) > 6 and MONTH(OrderDate) <= 9 then '3 '
	when MONTH(OrderDate) > 9 and MONTH(OrderDate) <= 12 then '4 '
	end as quartа ,
case 
when MONTH(OrderDate) <= 4  then 1
when MONTH(OrderDate) <= 8  then 2
when MONTH(OrderDate) <= 12 then 3
end as chetvert,
c.CustomerName  from Sales.OrderLines ol
join Sales.Orders o
on ol.OrderID = o.OrderID
join Sales.Customers c
on c.CustomerID = o.CustomerID
where UnitPrice >= 100 or Quantity > 20 and ol.PickingCompletedWhen is not null
order by quartа, chetvert, OrderDate

/*
4. Заказы поставщикам (Purchasing.Suppliers),
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)
и которые исполнены (IsOrderFinalized).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки (ExpectedDeliveryDate)
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/



select po.ExpectedDeliveryDate, dm.DeliveryMethodName, po.IsOrderFinalized, s.SupplierName, p.FullName from Purchasing.Suppliers s
join Purchasing.PurchaseOrders po
on s.SupplierID = po.SupplierID
join Application.DeliveryMethods dm
on po.DeliveryMethodID = dm.DeliveryMethodID 
join Application.People p 
on p.PersonID = po.ContactPersonID
where  (MONTH(po.ExpectedDeliveryDate)  = 1 and YEAR(po.ExpectedDeliveryDate) = 2013) and (DeliveryMethodName = 'Air Freight' or  DeliveryMethodName = 'Refrigerated Air Freight')
and  po.IsOrderFinalized = 1

/*
5. Десять последних продаж (по дате продажи) с именем клиента и именем сотрудника,
который оформил заказ (SalespersonPerson).
Сделать без подзапросов.
*/

напишите здесь свое решение

/*
6. Все ид и имена клиентов и их контактные телефоны,
которые покупали товар "Chocolate frogs 250g".
Имя товара смотреть в таблице Warehouse.StockItems.
*/




select c.CustomerID, c.CustomerName, c.PhoneNumber from sales.OrderLines ol
join sales.Orders o on ol.OrderID = o.orderid
join Sales.Customers c on c.CustomerID = o.CustomerID
where StockItemID = 224