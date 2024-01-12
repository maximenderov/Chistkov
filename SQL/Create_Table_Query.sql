use OrdersTest;

create table ProductCategory(
	CategoryId int not null identity(1,1),
	categoryName nvarchar(255),
	Constraint PK_Category primary key (CategoryId)
);

create table MeasureUnits(
	Units nvarchar(10) not null,
	FullName nvarchar(100),
	Constraint PK_Units primary key (Units)
);

create table supplier(
	SupplierId int not null identity(1,1),
	SupplierName nvarchar(255),
	DirectorName nvarchar(255),
	SupplierLocation nvarchar(255), 
	Constraint PK_Supplier primary key (SupplierId)
);

create table Products(
	ProductId int not null,
	CategoryId int,
	ProductName nvarchar(255),
	CaseQuantity int,
	Units nvarchar(10),
	Price int,
	Comment nvarchar(255),
	Constraint PK_Products primary key (ProductId),
	Constraint FK_Category Foreign key(CategoryId) 
		References ProductCategory(CategoryId),
	Constraint FK_Units Foreign key(Units) 
		References MeasureUnits(Units),
);

create table ProductSupplier(
	ProductId int not null,
	SupplierId int not null,
	Constraint FK_ProductId Foreign key(ProductId) 
		References Products(ProductId),
	Constraint FK_SupplierId Foreign key(SupplierId) 
		References Supplier(SupplierId)
);

create table ProductRequired(
	Id int not null identity(1,1),
	ProductID int not null,
	Quantity int,
	FromDate date,
	ToDate date,
	Constraint PK_ProductRequired primary key (Id),
	Constraint FK_Required_ProductId Foreign key(ProductId) 
		References Products(ProductId),
);

create table ProductConsumption(
	Id int not null identity(1,1),
	ProductID int not null,
	Quantity int,
	FromDate date,
	ToDate date,
	Constraint PK_ProductConsumption primary key (Id),
	Constraint FK_Consumption_ProductId Foreign key(ProductId) 
		References Products(ProductId),
);

create table Orders(
	OrderId int not null identity(1,1),
	CreatedDate date,
	DeliveryDate date,
	OrderStatus nvarchar(100),
	Cost int,
	ToLocation nvarchar(255),
	FromLocation nvarchar(255),
	Constraint PK_Orders primary key (OrderId)
);

create table OrderProducts(
	Id int not null identity(1,1),
	OrderId int not null,
	ProductId int not null,
	Qunatity int,
	Constraint PK_OrderProduct primary key (Id),
	Constraint FK_Order Foreign key(OrderId) 
		References Orders(OrderId),
	Constraint FK_Product Foreign key(ProductId) 
		References Products(ProductId),
);

create table Inventory(
	InventoryId int not null identity(1,1),
	InventoryDate date not null,
	Comment nvarchar(255),
	Constraint PK_InventoryId Primary Key(InventoryId)
);

create table InventoryProducts(
	InventoryId int not null,
	ProductId int not null,
	Quantity int not null,
	Constraint FK_IP_InventoryId Foreign Key(InventoryId)
		References Inventory(InventoryId),
	Constraint FK_IP_ProductId Foreign Key(ProductId)
		References Products(ProductId),
);