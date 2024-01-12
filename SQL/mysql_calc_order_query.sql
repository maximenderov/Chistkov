SET  @DeliveryDate = CAST('2023-11-30' AS date);
SET @InventoryId = CAST(40 as unsigned);

with RECURSIVE GetDateRange as (
	select DATE(NOW()) + INTERVAL 1 day as allDates
	union all
	select alldates + INTERVAL 1 day from GetDateRange
	where alldates < @DeliveryDate
), 
ProductConsumptionRange as (
	select ProductId, Sum(Quantity) as Quantity  from productconsumption, GetDateRange
	where 
		alldates between FromDate and todate
	group by ProductId
)

 select 
 Pr.ProductId, Pr.ProductName, Sup.SupplierName, 
 Pr.CaseQuantity, Pr.Units, Pr.Price,
 PrReq.Quantity, InvPr.Quantity, PrCon.Quantity, 
 case
	when PrReq.Quantity - (InvPr.Quantity - PrCon.Quantity) > PrReq.Quantity 
		then PrReq.Quantity  
	when PrReq.Quantity - (InvPr.Quantity - PrCon.Quantity) <= 0 
		then 0
	else PrReq.Quantity - (InvPr.Quantity - PrCon.Quantity)
 end as Quantity
 from Products Pr 
 join ProductRequired PrReq on Pr.ProductId = PrReq.ProductID 
 join ProductConsumptionRange PrCon on Pr.ProductId=PrCon.ProductID
 join InventoryProducts InvPr on Pr.ProductId = InvPr.ProductId 
 join ProductSupplier PrSup on PrSup.ProductId = Pr.ProductId 
 join supplier Sup on Sup.SupplierId = PrSup.SupplierId 
 Where
	@InventoryId = InvPr.InventoryId and 
	@DeliveryDate between PrReq.FromDate and PrReq.ToDate 