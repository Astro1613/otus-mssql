/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Посчитать среднюю цену товара, общую сумму продажи по месяцам.
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

select year( i.InvoiceDate) as [year]
	,format(i.InvoiceDate,'MMMM') as [month]
	,avg(il.unitPrice)as [AVG_price]
	,sum(il.unitPrice *il.Quantity) as 'monthly sales'
from Sales.Invoices i 
	inner join sales.invoicelines il
on il.InvoiceID = i.InvoiceID
GROUP BY year(i.InvoiceDate),format(i.InvoiceDate,'MMMM')


/*
2. Отобразить все месяцы, где общая сумма продаж превысила 4 600 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

select  year( i.InvoiceDate) as [year]
	,format(i.InvoiceDate,'MMMM') as [month]
	,sum(il.unitprice* il.Quantity) as 'Total sales'
from Sales.Invoices i
	join sales.invoicelines il
on il.InvoiceID = i.InvoiceID
group by year( i.InvoiceDate), format(i.InvoiceDate,'MMMM')
having sum(il.unitprice* il.Quantity) > 4600000

/*
3. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

select year( i.InvoiceDate) as [year]
	, format(i.InvoiceDate,'MMMM') as [month]
	,il.Description
	,sum(il.unitPrice * il.Quantity) as 'monthly sales'
	,min(i.invoiceDate) 'date of first sale'
	,sum(il.Quantity) 'quantity sold'
from Sales.Invoices i
	join sales.invoicelines il
on il.InvoiceID = i.InvoiceID
GROUP BY year(i.InvoiceDate),format(i.InvoiceDate,'MMMM'), Description, il.Quantity
having sum(il.Quantity) < 50

select *
from Sales.Invoices i
	join sales.invoicelines il
on il.InvoiceID = i.InvoiceID

-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
Написать запросы 2-3 так, чтобы если в каком-то месяце не было продаж,
то этот месяц также отображался бы в результатах, но там были нули.
*/
