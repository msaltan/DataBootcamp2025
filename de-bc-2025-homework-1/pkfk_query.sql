ALTER TABLE Person.Address ADD CONSTRAINT "PK_Address_AddressID" PRIMARY KEY (AddressID);
CLUSTER Person.Address USING "PK_Address_AddressID";

ALTER TABLE Person.AddressType ADD
    CONSTRAINT "PK_AddressType_AddressTypeID" PRIMARY KEY
    (AddressTypeID);
CLUSTER Person.AddressType USING "PK_AddressType_AddressTypeID";

ALTER TABLE Production.BillOfMaterials ADD
    CONSTRAINT "PK_BillOfMaterials_BillOfMaterialsID" PRIMARY KEY
    (BillOfMaterialsID);

ALTER TABLE Person.BusinessEntity ADD
    CONSTRAINT "PK_BusinessEntity_BusinessEntityID" PRIMARY KEY
    (BusinessEntityID);
CLUSTER Person.BusinessEntity USING "PK_BusinessEntity_BusinessEntityID";

ALTER TABLE Person.BusinessEntityAddress ADD
    CONSTRAINT "PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressType" PRIMARY KEY
    (BusinessEntityID, AddressID, AddressTypeID);
CLUSTER Person.BusinessEntityAddress USING "PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressType";

ALTER TABLE Person.BusinessEntityContact ADD
    CONSTRAINT "PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeI" PRIMARY KEY
    (BusinessEntityID, PersonID, ContactTypeID);
CLUSTER Person.BusinessEntityContact USING "PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeI";

ALTER TABLE Person.ContactType ADD
    CONSTRAINT "PK_ContactType_ContactTypeID" PRIMARY KEY
    (ContactTypeID);
CLUSTER Person.ContactType USING "PK_ContactType_ContactTypeID";

ALTER TABLE Sales.CountryRegionCurrency ADD
    CONSTRAINT "PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode" PRIMARY KEY
    (CountryRegionCode, CurrencyCode);
CLUSTER Sales.CountryRegionCurrency USING "PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode";

ALTER TABLE Person.CountryRegion ADD
    CONSTRAINT "PK_CountryRegion_CountryRegionCode" PRIMARY KEY
    (CountryRegionCode);
CLUSTER Person.CountryRegion USING "PK_CountryRegion_CountryRegionCode";

ALTER TABLE Sales.CreditCard ADD
    CONSTRAINT "PK_CreditCard_CreditCardID" PRIMARY KEY
    (CreditCardID);
CLUSTER Sales.CreditCard USING "PK_CreditCard_CreditCardID";

ALTER TABLE Sales.Currency ADD
    CONSTRAINT "PK_Currency_CurrencyCode" PRIMARY KEY
    (CurrencyCode);
CLUSTER Sales.Currency USING "PK_Currency_CurrencyCode";

ALTER TABLE Sales.CurrencyRate ADD
    CONSTRAINT "PK_CurrencyRate_CurrencyRateID" PRIMARY KEY
    (CurrencyRateID);
CLUSTER Sales.CurrencyRate USING "PK_CurrencyRate_CurrencyRateID";

ALTER TABLE Sales.Customer ADD
    CONSTRAINT "PK_Customer_CustomerID" PRIMARY KEY
    (CustomerID);
CLUSTER Sales.Customer USING "PK_Customer_CustomerID";

ALTER TABLE Production.Culture ADD
    CONSTRAINT "PK_Culture_CultureID" PRIMARY KEY
    (CultureID);
CLUSTER Production.Culture USING "PK_Culture_CultureID";

ALTER TABLE Production.Document ADD
    CONSTRAINT "PK_Document_DocumentNode" PRIMARY KEY
    (DocumentNode);
CLUSTER Production.Document USING "PK_Document_DocumentNode";

ALTER TABLE Person.EmailAddress ADD
    CONSTRAINT "PK_EmailAddress_BusinessEntityID_EmailAddressID" PRIMARY KEY
    (BusinessEntityID, EmailAddressID);
CLUSTER Person.EmailAddress USING "PK_EmailAddress_BusinessEntityID_EmailAddressID";

ALTER TABLE HumanResources.Department ADD
    CONSTRAINT "PK_Department_DepartmentID" PRIMARY KEY
    (DepartmentID);
CLUSTER HumanResources.Department USING "PK_Department_DepartmentID";

ALTER TABLE HumanResources.Employee ADD
    CONSTRAINT "PK_Employee_BusinessEntityID" PRIMARY KEY
    (BusinessEntityID);
CLUSTER HumanResources.Employee USING "PK_Employee_BusinessEntityID";

ALTER TABLE HumanResources.EmployeeDepartmentHistory ADD
    CONSTRAINT "PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_Departm" PRIMARY KEY
    (BusinessEntityID, StartDate, DepartmentID, ShiftID);
CLUSTER HumanResources.EmployeeDepartmentHistory USING "PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_Departm";

ALTER TABLE HumanResources.EmployeePayHistory ADD
    CONSTRAINT "PK_EmployeePayHistory_BusinessEntityID_RateChangeDate" PRIMARY KEY
    (BusinessEntityID, RateChangeDate);
CLUSTER HumanResources.EmployeePayHistory USING "PK_EmployeePayHistory_BusinessEntityID_RateChangeDate";

ALTER TABLE HumanResources.JobCandidate ADD
    CONSTRAINT "PK_JobCandidate_JobCandidateID" PRIMARY KEY
    (JobCandidateID);
CLUSTER HumanResources.JobCandidate USING "PK_JobCandidate_JobCandidateID";

ALTER TABLE Production.Illustration ADD
    CONSTRAINT "PK_Illustration_IllustrationID" PRIMARY KEY
    (IllustrationID);
CLUSTER Production.Illustration USING "PK_Illustration_IllustrationID";

ALTER TABLE Production.Location ADD
    CONSTRAINT "PK_Location_LocationID" PRIMARY KEY
    (LocationID);
CLUSTER Production.Location USING "PK_Location_LocationID";

ALTER TABLE Person.Password ADD
    CONSTRAINT "PK_Password_BusinessEntityID" PRIMARY KEY
    (BusinessEntityID);
CLUSTER Person.Password USING "PK_Password_BusinessEntityID";

ALTER TABLE Person.Person ADD
    CONSTRAINT "PK_Person_BusinessEntityID" PRIMARY KEY
    (BusinessEntityID);
CLUSTER Person.Person USING "PK_Person_BusinessEntityID";

ALTER TABLE Person.PersonPhone ADD
    CONSTRAINT "PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID" PRIMARY KEY
    (BusinessEntityID, PhoneNumber, PhoneNumberTypeID);
CLUSTER Person.PersonPhone USING "PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID";

ALTER TABLE Person.PhoneNumberType ADD
    CONSTRAINT "PK_PhoneNumberType_PhoneNumberTypeID" PRIMARY KEY
    (PhoneNumberTypeID);
CLUSTER Person.PhoneNumberType USING "PK_PhoneNumberType_PhoneNumberTypeID";

ALTER TABLE Production.Product ADD
    CONSTRAINT "PK_Product_ProductID" PRIMARY KEY
    (ProductID);
CLUSTER Production.Product USING "PK_Product_ProductID";

ALTER TABLE Production.ProductCategory ADD
    CONSTRAINT "PK_ProductCategory_ProductCategoryID" PRIMARY KEY
    (ProductCategoryID);
CLUSTER Production.ProductCategory USING "PK_ProductCategory_ProductCategoryID";

ALTER TABLE Production.ProductCostHistory ADD
    CONSTRAINT "PK_ProductCostHistory_ProductID_StartDate" PRIMARY KEY
    (ProductID, StartDate);
CLUSTER Production.ProductCostHistory USING "PK_ProductCostHistory_ProductID_StartDate";

ALTER TABLE Production.ProductDescription ADD
    CONSTRAINT "PK_ProductDescription_ProductDescriptionID" PRIMARY KEY
    (ProductDescriptionID);
CLUSTER Production.ProductDescription USING "PK_ProductDescription_ProductDescriptionID";

ALTER TABLE Production.ProductDocument ADD
    CONSTRAINT "PK_ProductDocument_ProductID_DocumentNode" PRIMARY KEY
    (ProductID, DocumentNode);
CLUSTER Production.ProductDocument USING "PK_ProductDocument_ProductID_DocumentNode";

ALTER TABLE Production.ProductInventory ADD
    CONSTRAINT "PK_ProductInventory_ProductID_LocationID" PRIMARY KEY
    (ProductID, LocationID);
CLUSTER Production.ProductInventory USING "PK_ProductInventory_ProductID_LocationID";

ALTER TABLE Production.ProductListPriceHistory ADD
    CONSTRAINT "PK_ProductListPriceHistory_ProductID_StartDate" PRIMARY KEY
    (ProductID, StartDate);
CLUSTER Production.ProductListPriceHistory USING "PK_ProductListPriceHistory_ProductID_StartDate";

ALTER TABLE Production.ProductModel ADD
    CONSTRAINT "PK_ProductModel_ProductModelID" PRIMARY KEY
    (ProductModelID);
CLUSTER Production.ProductModel USING "PK_ProductModel_ProductModelID";

ALTER TABLE Production.ProductModelIllustration ADD
    CONSTRAINT "PK_ProductModelIllustration_ProductModelID_IllustrationID" PRIMARY KEY
    (ProductModelID, IllustrationID);
CLUSTER Production.ProductModelIllustration USING "PK_ProductModelIllustration_ProductModelID_IllustrationID";

ALTER TABLE Production.ProductModelProductDescriptionCulture ADD
    CONSTRAINT "PK_ProductModelProductDescriptionCulture_ProductModelID_Product" PRIMARY KEY
    (ProductModelID, ProductDescriptionID, CultureID);
CLUSTER Production.ProductModelProductDescriptionCulture USING "PK_ProductModelProductDescriptionCulture_ProductModelID_Product";

ALTER TABLE Production.ProductPhoto ADD
    CONSTRAINT "PK_ProductPhoto_ProductPhotoID" PRIMARY KEY
    (ProductPhotoID);
CLUSTER Production.ProductPhoto USING "PK_ProductPhoto_ProductPhotoID";

ALTER TABLE Production.ProductProductPhoto ADD
    CONSTRAINT "PK_ProductProductPhoto_ProductID_ProductPhotoID" PRIMARY KEY
    (ProductID, ProductPhotoID);

ALTER TABLE Production.ProductReview ADD
    CONSTRAINT "PK_ProductReview_ProductReviewID" PRIMARY KEY
    (ProductReviewID);
CLUSTER Production.ProductReview USING "PK_ProductReview_ProductReviewID";

ALTER TABLE Production.ProductSubcategory ADD
    CONSTRAINT "PK_ProductSubcategory_ProductSubcategoryID" PRIMARY KEY
    (ProductSubcategoryID);
CLUSTER Production.ProductSubcategory USING "PK_ProductSubcategory_ProductSubcategoryID";

ALTER TABLE Purchasing.ProductVendor ADD
    CONSTRAINT "PK_ProductVendor_ProductID_BusinessEntityID" PRIMARY KEY
    (ProductID, BusinessEntityID);
CLUSTER Purchasing.ProductVendor USING "PK_ProductVendor_ProductID_BusinessEntityID";

ALTER TABLE Purchasing.PurchaseOrderDetail ADD
    CONSTRAINT "PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID" PRIMARY KEY
    (PurchaseOrderID, PurchaseOrderDetailID);
CLUSTER Purchasing.PurchaseOrderDetail USING "PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID";

ALTER TABLE Purchasing.PurchaseOrderHeader ADD
    CONSTRAINT "PK_PurchaseOrderHeader_PurchaseOrderID" PRIMARY KEY
    (PurchaseOrderID);
CLUSTER Purchasing.PurchaseOrderHeader USING "PK_PurchaseOrderHeader_PurchaseOrderID";

ALTER TABLE Sales.PersonCreditCard ADD
    CONSTRAINT "PK_PersonCreditCard_BusinessEntityID_CreditCardID" PRIMARY KEY
    (BusinessEntityID, CreditCardID);
CLUSTER Sales.PersonCreditCard USING "PK_PersonCreditCard_BusinessEntityID_CreditCardID";

ALTER TABLE Sales.SalesOrderDetail ADD
    CONSTRAINT "PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID" PRIMARY KEY
    (SalesOrderID, SalesOrderDetailID);
CLUSTER Sales.SalesOrderDetail USING "PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID";

ALTER TABLE Sales.SalesOrderHeader ADD
    CONSTRAINT "PK_SalesOrderHeader_SalesOrderID" PRIMARY KEY
    (SalesOrderID);
CLUSTER Sales.SalesOrderHeader USING "PK_SalesOrderHeader_SalesOrderID";

ALTER TABLE Sales.SalesOrderHeaderSalesReason ADD
    CONSTRAINT "PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID" PRIMARY KEY
    (SalesOrderID, SalesReasonID);
CLUSTER Sales.SalesOrderHeaderSalesReason USING "PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID";

ALTER TABLE Sales.SalesPerson ADD
    CONSTRAINT "PK_SalesPerson_BusinessEntityID" PRIMARY KEY
    (BusinessEntityID);
CLUSTER Sales.SalesPerson USING "PK_SalesPerson_BusinessEntityID";

ALTER TABLE Sales.SalesPersonQuotaHistory ADD
    CONSTRAINT "PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate" PRIMARY KEY
    (BusinessEntityID, QuotaDate); -- ProductCategoryID);
CLUSTER Sales.SalesPersonQuotaHistory USING "PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate";

ALTER TABLE Sales.SalesReason ADD
    CONSTRAINT "PK_SalesReason_SalesReasonID" PRIMARY KEY
    (SalesReasonID);
CLUSTER Sales.SalesReason USING "PK_SalesReason_SalesReasonID";

ALTER TABLE Sales.SalesTaxRate ADD
    CONSTRAINT "PK_SalesTaxRate_SalesTaxRateID" PRIMARY KEY
    (SalesTaxRateID);
CLUSTER Sales.SalesTaxRate USING "PK_SalesTaxRate_SalesTaxRateID";

ALTER TABLE Sales.SalesTerritory ADD
    CONSTRAINT "PK_SalesTerritory_TerritoryID" PRIMARY KEY
    (TerritoryID);
CLUSTER Sales.SalesTerritory USING "PK_SalesTerritory_TerritoryID";

ALTER TABLE Sales.SalesTerritoryHistory ADD
    CONSTRAINT "PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID" PRIMARY KEY
    (BusinessEntityID,  --Sales person,
     StartDate, TerritoryID);
CLUSTER Sales.SalesTerritoryHistory USING "PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID";

ALTER TABLE Production.ScrapReason ADD
    CONSTRAINT "PK_ScrapReason_ScrapReasonID" PRIMARY KEY
    (ScrapReasonID);
CLUSTER Production.ScrapReason USING "PK_ScrapReason_ScrapReasonID";

ALTER TABLE HumanResources.Shift ADD
    CONSTRAINT "PK_Shift_ShiftID" PRIMARY KEY
    (ShiftID);
CLUSTER HumanResources.Shift USING "PK_Shift_ShiftID";

ALTER TABLE Purchasing.ShipMethod ADD
    CONSTRAINT "PK_ShipMethod_ShipMethodID" PRIMARY KEY
    (ShipMethodID);
CLUSTER Purchasing.ShipMethod USING "PK_ShipMethod_ShipMethodID";

ALTER TABLE Sales.ShoppingCartItem ADD
    CONSTRAINT "PK_ShoppingCartItem_ShoppingCartItemID" PRIMARY KEY
    (ShoppingCartItemID);
CLUSTER Sales.ShoppingCartItem USING "PK_ShoppingCartItem_ShoppingCartItemID";

ALTER TABLE Sales.SpecialOffer ADD
    CONSTRAINT "PK_SpecialOffer_SpecialOfferID" PRIMARY KEY
    (SpecialOfferID);
CLUSTER Sales.SpecialOffer USING "PK_SpecialOffer_SpecialOfferID";

ALTER TABLE Sales.SpecialOfferProduct ADD
    CONSTRAINT "PK_SpecialOfferProduct_SpecialOfferID_ProductID" PRIMARY KEY
    (SpecialOfferID, ProductID);
CLUSTER Sales.SpecialOfferProduct USING "PK_SpecialOfferProduct_SpecialOfferID_ProductID";

ALTER TABLE Person.StateProvince ADD
    CONSTRAINT "PK_StateProvince_StateProvinceID" PRIMARY KEY
    (StateProvinceID);
CLUSTER Person.StateProvince USING "PK_StateProvince_StateProvinceID";

ALTER TABLE Sales.Store ADD
    CONSTRAINT "PK_Store_BusinessEntityID" PRIMARY KEY
    (BusinessEntityID);
CLUSTER Sales.Store USING "PK_Store_BusinessEntityID";

ALTER TABLE Production.TransactionHistory ADD
    CONSTRAINT "PK_TransactionHistory_TransactionID" PRIMARY KEY
    (TransactionID);
CLUSTER Production.TransactionHistory USING "PK_TransactionHistory_TransactionID";

ALTER TABLE Production.TransactionHistoryArchive ADD
    CONSTRAINT "PK_TransactionHistoryArchive_TransactionID" PRIMARY KEY
    (TransactionID);
CLUSTER Production.TransactionHistoryArchive USING "PK_TransactionHistoryArchive_TransactionID";

ALTER TABLE Production.UnitMeasure ADD
    CONSTRAINT "PK_UnitMeasure_UnitMeasureCode" PRIMARY KEY
    (UnitMeasureCode);
CLUSTER Production.UnitMeasure USING "PK_UnitMeasure_UnitMeasureCode";

ALTER TABLE Purchasing.Vendor ADD
    CONSTRAINT "PK_Vendor_BusinessEntityID" PRIMARY KEY
    (BusinessEntityID);
CLUSTER Purchasing.Vendor USING "PK_Vendor_BusinessEntityID";

ALTER TABLE Production.WorkOrder ADD
    CONSTRAINT "PK_WorkOrder_WorkOrderID" PRIMARY KEY
    (WorkOrderID);
CLUSTER Production.WorkOrder USING "PK_WorkOrder_WorkOrderID";

ALTER TABLE Production.WorkOrderRouting ADD
    CONSTRAINT "PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence" PRIMARY KEY
    (WorkOrderID, ProductID, OperationSequence);
CLUSTER Production.WorkOrderRouting USING "PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence";



-------------------------------------
-- FOREIGN KEYS
-------------------------------------

ALTER TABLE Person.Address ADD
    CONSTRAINT "FK_Address_StateProvince_StateProvinceID" FOREIGN KEY
    (StateProvinceID) REFERENCES Person.StateProvince(StateProvinceID);

ALTER TABLE Production.BillOfMaterials ADD
    CONSTRAINT "FK_BillOfMaterials_Product_ProductAssemblyID" FOREIGN KEY
    (ProductAssemblyID) REFERENCES Production.Product(ProductID);
ALTER TABLE Production.BillOfMaterials ADD
    CONSTRAINT "FK_BillOfMaterials_Product_ComponentID" FOREIGN KEY
    (ComponentID) REFERENCES Production.Product(ProductID);
ALTER TABLE Production.BillOfMaterials ADD
    CONSTRAINT "FK_BillOfMaterials_UnitMeasure_UnitMeasureCode" FOREIGN KEY
    (UnitMeasureCode) REFERENCES Production.UnitMeasure(UnitMeasureCode);

ALTER TABLE Person.BusinessEntityAddress ADD
    CONSTRAINT "FK_BusinessEntityAddress_Address_AddressID" FOREIGN KEY
    (AddressID) REFERENCES Person.Address(AddressID);
ALTER TABLE Person.BusinessEntityAddress ADD
    CONSTRAINT "FK_BusinessEntityAddress_AddressType_AddressTypeID" FOREIGN KEY
    (AddressTypeID) REFERENCES Person.AddressType(AddressTypeID);
ALTER TABLE Person.BusinessEntityAddress ADD
    CONSTRAINT "FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES Person.BusinessEntity(BusinessEntityID);

ALTER TABLE Person.BusinessEntityContact ADD
    CONSTRAINT "FK_BusinessEntityContact_Person_PersonID" FOREIGN KEY
    (PersonID) REFERENCES Person.Person(BusinessEntityID);
ALTER TABLE Person.BusinessEntityContact ADD
    CONSTRAINT "FK_BusinessEntityContact_ContactType_ContactTypeID" FOREIGN KEY
    (ContactTypeID) REFERENCES Person.ContactType(ContactTypeID);
ALTER TABLE Person.BusinessEntityContact ADD
    CONSTRAINT "FK_BusinessEntityContact_BusinessEntity_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES Person.BusinessEntity(BusinessEntityID);

ALTER TABLE Sales.CountryRegionCurrency ADD
    CONSTRAINT "FK_CountryRegionCurrency_CountryRegion_CountryRegionCode" FOREIGN KEY
    (CountryRegionCode) REFERENCES Person.CountryRegion(CountryRegionCode);
ALTER TABLE Sales.CountryRegionCurrency ADD
    CONSTRAINT "FK_CountryRegionCurrency_Currency_CurrencyCode" FOREIGN KEY
    (CurrencyCode) REFERENCES Sales.Currency(CurrencyCode);

ALTER TABLE Sales.CurrencyRate ADD
    CONSTRAINT "FK_CurrencyRate_Currency_FromCurrencyCode" FOREIGN KEY
    (FromCurrencyCode) REFERENCES Sales.Currency(CurrencyCode);
ALTER TABLE Sales.CurrencyRate ADD
    CONSTRAINT "FK_CurrencyRate_Currency_ToCurrencyCode" FOREIGN KEY
    (ToCurrencyCode) REFERENCES Sales.Currency(CurrencyCode);

ALTER TABLE Sales.Customer ADD
    CONSTRAINT "FK_Customer_Person_PersonID" FOREIGN KEY
    (PersonID) REFERENCES Person.Person(BusinessEntityID);
ALTER TABLE Sales.Customer ADD
    CONSTRAINT "FK_Customer_Store_StoreID" FOREIGN KEY
    (StoreID) REFERENCES Sales.Store(BusinessEntityID);
ALTER TABLE Sales.Customer ADD
    CONSTRAINT "FK_Customer_SalesTerritory_TerritoryID" FOREIGN KEY
    (TerritoryID) REFERENCES Sales.SalesTerritory(TerritoryID);

ALTER TABLE Production.Document ADD
    CONSTRAINT "FK_Document_Employee_Owner" FOREIGN KEY
    (Owner) REFERENCES HumanResources.Employee(BusinessEntityID);

ALTER TABLE Person.EmailAddress ADD
    CONSTRAINT "FK_EmailAddress_Person_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES Person.Person(BusinessEntityID);

ALTER TABLE HumanResources.Employee ADD
    CONSTRAINT "FK_Employee_Person_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES Person.Person(BusinessEntityID);

ALTER TABLE HumanResources.EmployeeDepartmentHistory ADD
    CONSTRAINT "FK_EmployeeDepartmentHistory_Department_DepartmentID" FOREIGN KEY
    (DepartmentID) REFERENCES HumanResources.Department(DepartmentID);
ALTER TABLE HumanResources.EmployeeDepartmentHistory ADD
    CONSTRAINT "FK_EmployeeDepartmentHistory_Employee_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES HumanResources.Employee(BusinessEntityID);
ALTER TABLE HumanResources.EmployeeDepartmentHistory ADD
    CONSTRAINT "FK_EmployeeDepartmentHistory_Shift_ShiftID" FOREIGN KEY
    (ShiftID) REFERENCES HumanResources.Shift(ShiftID);

ALTER TABLE HumanResources.EmployeePayHistory ADD
    CONSTRAINT "FK_EmployeePayHistory_Employee_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES HumanResources.Employee(BusinessEntityID);

ALTER TABLE HumanResources.JobCandidate ADD
    CONSTRAINT "FK_JobCandidate_Employee_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES HumanResources.Employee(BusinessEntityID);

ALTER TABLE Person.Password ADD
    CONSTRAINT "FK_Password_Person_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES Person.Person(BusinessEntityID);

ALTER TABLE Person.Person ADD
    CONSTRAINT "FK_Person_BusinessEntity_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES Person.BusinessEntity(BusinessEntityID);

ALTER TABLE Sales.PersonCreditCard ADD
    CONSTRAINT "FK_PersonCreditCard_Person_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES Person.Person(BusinessEntityID);
ALTER TABLE Sales.PersonCreditCard ADD
    CONSTRAINT "FK_PersonCreditCard_CreditCard_CreditCardID" FOREIGN KEY
    (CreditCardID) REFERENCES Sales.CreditCard(CreditCardID);

ALTER TABLE Person.PersonPhone ADD
    CONSTRAINT "FK_PersonPhone_Person_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES Person.Person(BusinessEntityID);
ALTER TABLE Person.PersonPhone ADD
    CONSTRAINT "FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID" FOREIGN KEY
    (PhoneNumberTypeID) REFERENCES Person.PhoneNumberType(PhoneNumberTypeID);

ALTER TABLE Production.Product ADD
    CONSTRAINT "FK_Product_UnitMeasure_SizeUnitMeasureCode" FOREIGN KEY
    (SizeUnitMeasureCode) REFERENCES Production.UnitMeasure(UnitMeasureCode);
ALTER TABLE Production.Product ADD
    CONSTRAINT "FK_Product_UnitMeasure_WeightUnitMeasureCode" FOREIGN KEY
    (WeightUnitMeasureCode) REFERENCES Production.UnitMeasure(UnitMeasureCode);
ALTER TABLE Production.Product ADD
    CONSTRAINT "FK_Product_ProductModel_ProductModelID" FOREIGN KEY
    (ProductModelID) REFERENCES Production.ProductModel(ProductModelID);
ALTER TABLE Production.Product ADD
    CONSTRAINT "FK_Product_ProductSubcategory_ProductSubcategoryID" FOREIGN KEY
    (ProductSubcategoryID) REFERENCES Production.ProductSubcategory(ProductSubcategoryID);

ALTER TABLE Production.ProductCostHistory ADD
    CONSTRAINT "FK_ProductCostHistory_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);

ALTER TABLE Production.ProductDocument ADD
    CONSTRAINT "FK_ProductDocument_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);
ALTER TABLE Production.ProductDocument ADD
    CONSTRAINT "FK_ProductDocument_Document_DocumentNode" FOREIGN KEY
    (DocumentNode) REFERENCES Production.Document(DocumentNode);

ALTER TABLE Production.ProductInventory ADD
    CONSTRAINT "FK_ProductInventory_Location_LocationID" FOREIGN KEY
    (LocationID) REFERENCES Production.Location(LocationID);
ALTER TABLE Production.ProductInventory ADD
    CONSTRAINT "FK_ProductInventory_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);

ALTER TABLE Production.ProductListPriceHistory ADD
    CONSTRAINT "FK_ProductListPriceHistory_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);

ALTER TABLE Production.ProductModelIllustration ADD
    CONSTRAINT "FK_ProductModelIllustration_ProductModel_ProductModelID" FOREIGN KEY
    (ProductModelID) REFERENCES Production.ProductModel(ProductModelID);
ALTER TABLE Production.ProductModelIllustration ADD
    CONSTRAINT "FK_ProductModelIllustration_Illustration_IllustrationID" FOREIGN KEY
    (IllustrationID) REFERENCES Production.Illustration(IllustrationID);

ALTER TABLE Production.ProductModelProductDescriptionCulture ADD
    CONSTRAINT "FK_ProductModelProductDescriptionCulture_ProductDescription_Pro" FOREIGN KEY
    (ProductDescriptionID) REFERENCES Production.ProductDescription(ProductDescriptionID);
ALTER TABLE Production.ProductModelProductDescriptionCulture ADD
    CONSTRAINT "FK_ProductModelProductDescriptionCulture_Culture_CultureID" FOREIGN KEY
    (CultureID) REFERENCES Production.Culture(CultureID);
ALTER TABLE Production.ProductModelProductDescriptionCulture ADD
    CONSTRAINT "FK_ProductModelProductDescriptionCulture_ProductModel_ProductMo" FOREIGN KEY
    (ProductModelID) REFERENCES Production.ProductModel(ProductModelID);

ALTER TABLE Production.ProductProductPhoto ADD
    CONSTRAINT "FK_ProductProductPhoto_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);
ALTER TABLE Production.ProductProductPhoto ADD
    CONSTRAINT "FK_ProductProductPhoto_ProductPhoto_ProductPhotoID" FOREIGN KEY
    (ProductPhotoID) REFERENCES Production.ProductPhoto(ProductPhotoID);

ALTER TABLE Production.ProductReview ADD
    CONSTRAINT "FK_ProductReview_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);

ALTER TABLE Production.ProductSubcategory ADD
    CONSTRAINT "FK_ProductSubcategory_ProductCategory_ProductCategoryID" FOREIGN KEY
    (ProductCategoryID) REFERENCES Production.ProductCategory(ProductCategoryID);

ALTER TABLE Purchasing.ProductVendor ADD
    CONSTRAINT "FK_ProductVendor_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);
ALTER TABLE Purchasing.ProductVendor ADD
    CONSTRAINT "FK_ProductVendor_UnitMeasure_UnitMeasureCode" FOREIGN KEY
    (UnitMeasureCode) REFERENCES Production.UnitMeasure(UnitMeasureCode);
ALTER TABLE Purchasing.ProductVendor ADD
    CONSTRAINT "FK_ProductVendor_Vendor_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES Purchasing.Vendor(BusinessEntityID);

ALTER TABLE Purchasing.PurchaseOrderDetail ADD
    CONSTRAINT "FK_PurchaseOrderDetail_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);
ALTER TABLE Purchasing.PurchaseOrderDetail ADD
    CONSTRAINT "FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID" FOREIGN KEY
    (PurchaseOrderID) REFERENCES Purchasing.PurchaseOrderHeader(PurchaseOrderID);

ALTER TABLE Purchasing.PurchaseOrderHeader ADD
    CONSTRAINT "FK_PurchaseOrderHeader_Employee_EmployeeID" FOREIGN KEY
    (EmployeeID) REFERENCES HumanResources.Employee(BusinessEntityID);
ALTER TABLE Purchasing.PurchaseOrderHeader ADD
    CONSTRAINT "FK_PurchaseOrderHeader_Vendor_VendorID" FOREIGN KEY
    (VendorID) REFERENCES Purchasing.Vendor(BusinessEntityID);
ALTER TABLE Purchasing.PurchaseOrderHeader ADD
    CONSTRAINT "FK_PurchaseOrderHeader_ShipMethod_ShipMethodID" FOREIGN KEY
    (ShipMethodID) REFERENCES Purchasing.ShipMethod(ShipMethodID);

ALTER TABLE Sales.SalesOrderDetail ADD
    CONSTRAINT "FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID" FOREIGN KEY
    (SalesOrderID) REFERENCES Sales.SalesOrderHeader(SalesOrderID) ON DELETE CASCADE;
ALTER TABLE Sales.SalesOrderDetail ADD
    CONSTRAINT "FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID" FOREIGN KEY
    (SpecialOfferID, ProductID) REFERENCES Sales.SpecialOfferProduct(SpecialOfferID, ProductID);

ALTER TABLE Sales.SalesOrderHeader ADD
    CONSTRAINT "FK_SalesOrderHeader_Address_BillToAddressID" FOREIGN KEY
    (BillToAddressID) REFERENCES Person.Address(AddressID);
ALTER TABLE Sales.SalesOrderHeader ADD
    CONSTRAINT "FK_SalesOrderHeader_Address_ShipToAddressID" FOREIGN KEY
    (ShipToAddressID) REFERENCES Person.Address(AddressID);
ALTER TABLE Sales.SalesOrderHeader ADD
    CONSTRAINT "FK_SalesOrderHeader_CreditCard_CreditCardID" FOREIGN KEY
    (CreditCardID) REFERENCES Sales.CreditCard(CreditCardID);
ALTER TABLE Sales.SalesOrderHeader ADD
    CONSTRAINT "FK_SalesOrderHeader_CurrencyRate_CurrencyRateID" FOREIGN KEY
    (CurrencyRateID) REFERENCES Sales.CurrencyRate(CurrencyRateID);
ALTER TABLE Sales.SalesOrderHeader ADD
    CONSTRAINT "FK_SalesOrderHeader_Customer_CustomerID" FOREIGN KEY
    (CustomerID) REFERENCES Sales.Customer(CustomerID);
ALTER TABLE Sales.SalesOrderHeader ADD
    CONSTRAINT "FK_SalesOrderHeader_SalesPerson_SalesPersonID" FOREIGN KEY
    (SalesPersonID) REFERENCES Sales.SalesPerson(BusinessEntityID);
ALTER TABLE Sales.SalesOrderHeader ADD
    CONSTRAINT "FK_SalesOrderHeader_ShipMethod_ShipMethodID" FOREIGN KEY
    (ShipMethodID) REFERENCES Purchasing.ShipMethod(ShipMethodID);
ALTER TABLE Sales.SalesOrderHeader ADD
    CONSTRAINT "FK_SalesOrderHeader_SalesTerritory_TerritoryID" FOREIGN KEY
    (TerritoryID) REFERENCES Sales.SalesTerritory(TerritoryID);

ALTER TABLE Sales.SalesOrderHeaderSalesReason ADD
    CONSTRAINT "FK_SalesOrderHeaderSalesReason_SalesReason_SalesReasonID" FOREIGN KEY
    (SalesReasonID) REFERENCES Sales.SalesReason(SalesReasonID);
ALTER TABLE Sales.SalesOrderHeaderSalesReason ADD
    CONSTRAINT "FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID" FOREIGN KEY
    (SalesOrderID) REFERENCES Sales.SalesOrderHeader(SalesOrderID) ON DELETE CASCADE;

ALTER TABLE Sales.SalesPerson ADD
    CONSTRAINT "FK_SalesPerson_Employee_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES HumanResources.Employee(BusinessEntityID);
ALTER TABLE Sales.SalesPerson ADD
    CONSTRAINT "FK_SalesPerson_SalesTerritory_TerritoryID" FOREIGN KEY
    (TerritoryID) REFERENCES Sales.SalesTerritory(TerritoryID);

ALTER TABLE Sales.SalesPersonQuotaHistory ADD
    CONSTRAINT "FK_SalesPersonQuotaHistory_SalesPerson_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES Sales.SalesPerson(BusinessEntityID);

ALTER TABLE Sales.SalesTaxRate ADD
    CONSTRAINT "FK_SalesTaxRate_StateProvince_StateProvinceID" FOREIGN KEY
    (StateProvinceID) REFERENCES Person.StateProvince(StateProvinceID);

ALTER TABLE Sales.SalesTerritory ADD
    CONSTRAINT "FK_SalesTerritory_CountryRegion_CountryRegionCode" FOREIGN KEY
    (CountryRegionCode) REFERENCES Person.CountryRegion(CountryRegionCode);

ALTER TABLE Sales.SalesTerritoryHistory ADD
    CONSTRAINT "FK_SalesTerritoryHistory_SalesPerson_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES Sales.SalesPerson(BusinessEntityID);
ALTER TABLE Sales.SalesTerritoryHistory ADD
    CONSTRAINT "FK_SalesTerritoryHistory_SalesTerritory_TerritoryID" FOREIGN KEY
    (TerritoryID) REFERENCES Sales.SalesTerritory(TerritoryID);

ALTER TABLE Sales.ShoppingCartItem ADD
    CONSTRAINT "FK_ShoppingCartItem_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);

ALTER TABLE Sales.SpecialOfferProduct ADD
    CONSTRAINT "FK_SpecialOfferProduct_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);
ALTER TABLE Sales.SpecialOfferProduct ADD
    CONSTRAINT "FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID" FOREIGN KEY
    (SpecialOfferID) REFERENCES Sales.SpecialOffer(SpecialOfferID);

ALTER TABLE Person.StateProvince ADD
    CONSTRAINT "FK_StateProvince_CountryRegion_CountryRegionCode" FOREIGN KEY
    (CountryRegionCode) REFERENCES Person.CountryRegion(CountryRegionCode);
ALTER TABLE Person.StateProvince ADD
    CONSTRAINT "FK_StateProvince_SalesTerritory_TerritoryID" FOREIGN KEY
    (TerritoryID) REFERENCES Sales.SalesTerritory(TerritoryID);

ALTER TABLE Sales.Store ADD
    CONSTRAINT "FK_Store_BusinessEntity_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES Person.BusinessEntity(BusinessEntityID);
ALTER TABLE Sales.Store ADD
    CONSTRAINT "FK_Store_SalesPerson_SalesPersonID" FOREIGN KEY
    (SalesPersonID) REFERENCES Sales.SalesPerson(BusinessEntityID);

ALTER TABLE Production.TransactionHistory ADD
    CONSTRAINT "FK_TransactionHistory_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);

ALTER TABLE Purchasing.Vendor ADD
    CONSTRAINT "FK_Vendor_BusinessEntity_BusinessEntityID" FOREIGN KEY
    (BusinessEntityID) REFERENCES Person.BusinessEntity(BusinessEntityID);

ALTER TABLE Production.WorkOrder ADD
    CONSTRAINT "FK_WorkOrder_Product_ProductID" FOREIGN KEY
    (ProductID) REFERENCES Production.Product(ProductID);
ALTER TABLE Production.WorkOrder ADD
    CONSTRAINT "FK_WorkOrder_ScrapReason_ScrapReasonID" FOREIGN KEY
    (ScrapReasonID) REFERENCES Production.ScrapReason(ScrapReasonID);

ALTER TABLE Production.WorkOrderRouting ADD
    CONSTRAINT "FK_WorkOrderRouting_Location_LocationID" FOREIGN KEY
    (LocationID) REFERENCES Production.Location(LocationID);
ALTER TABLE Production.WorkOrderRouting ADD
    CONSTRAINT "FK_WorkOrderRouting_WorkOrder_WorkOrderID" FOREIGN KEY
    (WorkOrderID) REFERENCES Production.WorkOrder(WorkOrderID);

