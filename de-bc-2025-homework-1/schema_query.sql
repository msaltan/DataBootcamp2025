CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; 
CREATE EXTENSION IF NOT EXISTS tablefunc;

CREATE DOMAIN "OrderNumber" varchar(25) NULL;
CREATE DOMAIN "AccountNumber" varchar(15) NULL; 
CREATE DOMAIN "Flag" boolean NOT NULL;
CREATE DOMAIN "NameStyle" boolean NOT NULL;
CREATE DOMAIN "Name" varchar(50) NULL;
CREATE DOMAIN "Phone" varchar(25) NULL;

CREATE SCHEMA Person;
CREATE SCHEMA HumanResources;
CREATE SCHEMA Production;
CREATE SCHEMA Purchasing;
CREATE SCHEMA Sales;

  CREATE TABLE Person.BusinessEntity(
    BusinessEntityID SERIAL, --  NOT FOR REPLICATION
    rowguid uuid NOT NULL CONSTRAINT "DF_BusinessEntity_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_BusinessEntity_ModifiedDate" DEFAULT (NOW())
  );

  CREATE TABLE Person.Person(
    BusinessEntityID INT NOT NULL,
    PersonType char(2) NOT NULL,
    NameStyle "NameStyle" NOT NULL CONSTRAINT "DF_Person_NameStyle" DEFAULT (false),
    Title varchar(8) NULL,
    FirstName "Name" NOT NULL,
    MiddleName "Name" NULL,
    LastName "Name" NOT NULL,
    Suffix varchar(10) NULL,
    EmailPromotion INT NOT NULL CONSTRAINT "DF_Person_EmailPromotion" DEFAULT (0),
    AdditionalContactInfo XML NULL, -- XML("AdditionalContactInfoSchemaCollection"),
    Demographics XML NULL, -- XML("IndividualSurveySchemaCollection"),
    rowguid uuid NOT NULL CONSTRAINT "DF_Person_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Person_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_Person_EmailPromotion" CHECK (EmailPromotion BETWEEN 0 AND 2),
    CONSTRAINT "CK_Person_PersonType" CHECK (PersonType IS NULL OR UPPER(PersonType) IN ('SC', 'VC', 'IN', 'EM', 'SP', 'GC'))
  );

  CREATE TABLE Person.StateProvince(
    StateProvinceID SERIAL,
    StateProvinceCode char(3) NOT NULL,
    CountryRegionCode varchar(3) NOT NULL,
    IsOnlyStateProvinceFlag "Flag" NOT NULL CONSTRAINT "DF_StateProvince_IsOnlyStateProvinceFlag" DEFAULT (true),
    Name "Name" NOT NULL,
    TerritoryID INT NOT NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_StateProvince_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_StateProvince_ModifiedDate" DEFAULT (NOW())
  );

  CREATE TABLE Person.Address(
    AddressID SERIAL, --  NOT FOR REPLICATION
    AddressLine1 varchar(60) NOT NULL,
    AddressLine2 varchar(60) NULL,
    City varchar(30) NOT NULL,
    StateProvinceID INT NOT NULL,
    PostalCode varchar(15) NOT NULL,
    SpatialLocation bytea NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_Address_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Address_ModifiedDate" DEFAULT (NOW())
  );

  CREATE TABLE Person.AddressType(
    AddressTypeID SERIAL,
    Name "Name" NOT NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_AddressType_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_AddressType_ModifiedDate" DEFAULT (NOW())
  );

  CREATE TABLE Person.BusinessEntityAddress(
    BusinessEntityID INT NOT NULL,
    AddressID INT NOT NULL,
    AddressTypeID INT NOT NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_BusinessEntityAddress_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_BusinessEntityAddress_ModifiedDate" DEFAULT (NOW())
  );

  CREATE TABLE Person.ContactType(
    ContactTypeID SERIAL,
    Name "Name" NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ContactType_ModifiedDate" DEFAULT (NOW())
  );

  CREATE TABLE Person.BusinessEntityContact(
    BusinessEntityID INT NOT NULL,
    PersonID INT NOT NULL,
    ContactTypeID INT NOT NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_BusinessEntityContact_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_BusinessEntityContact_ModifiedDate" DEFAULT (NOW())
  );

  CREATE TABLE Person.EmailAddress(
    BusinessEntityID INT NOT NULL,
    EmailAddressID SERIAL,
    EmailAddress varchar(50) NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_EmailAddress_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_EmailAddress_ModifiedDate" DEFAULT (NOW())
  );

  CREATE TABLE Person.Password(
    BusinessEntityID INT NOT NULL,
    PasswordHash VARCHAR(128) NOT NULL,
    PasswordSalt VARCHAR(10) NOT NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_Password_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Password_ModifiedDate" DEFAULT (NOW())
  );

  CREATE TABLE Person.PhoneNumberType(
    PhoneNumberTypeID SERIAL,
    Name "Name" NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_PhoneNumberType_ModifiedDate" DEFAULT (NOW())
  );

  CREATE TABLE Person.PersonPhone(
    BusinessEntityID INT NOT NULL,
    PhoneNumber "Phone" NOT NULL,
    PhoneNumberTypeID INT NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_PersonPhone_ModifiedDate" DEFAULT (NOW())
  );

  CREATE TABLE Person.CountryRegion(
    CountryRegionCode varchar(3) NOT NULL,
    Name "Name" NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_CountryRegion_ModifiedDate" DEFAULT (NOW())
  );

COMMENT ON SCHEMA Person.Person IS 'Contains objects related to names and addresses of customers, vendors, and employees';


  CREATE TABLE HumanResources.Department(
    DepartmentID SERIAL NOT NULL, -- smallint
    Name "Name" NOT NULL,
    GroupName "Name" NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Department_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE HumanResources.Employee(
    BusinessEntityID INT NOT NULL,
    NationalIDNumber varchar(15) NOT NULL,
    LoginID varchar(256) NOT NULL,    
    Org varchar NULL,-- hierarchyid, will become OrganizationNode
    OrganizationLevel INT NULL, -- AS OrganizationNode.GetLevel(),
    JobTitle varchar(50) NOT NULL,
    BirthDate DATE NOT NULL,
    MaritalStatus char(1) NOT NULL,
    Gender char(1) NOT NULL,
    HireDate DATE NOT NULL,
    SalariedFlag "Flag" NOT NULL CONSTRAINT "DF_Employee_SalariedFlag" DEFAULT (true),
    VacationHours smallint NOT NULL CONSTRAINT "DF_Employee_VacationHours" DEFAULT (0),
    SickLeaveHours smallint NOT NULL CONSTRAINT "DF_Employee_SickLeaveHours" DEFAULT (0),
    CurrentFlag "Flag" NOT NULL CONSTRAINT "DF_Employee_CurrentFlag" DEFAULT (true),
    rowguid uuid NOT NULL CONSTRAINT "DF_Employee_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Employee_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_Employee_BirthDate" CHECK (BirthDate BETWEEN '1930-01-01' AND NOW() - INTERVAL '18 years'),
    CONSTRAINT "CK_Employee_MaritalStatus" CHECK (UPPER(MaritalStatus) IN ('M', 'S')), -- Married or Single
    CONSTRAINT "CK_Employee_HireDate" CHECK (HireDate BETWEEN '1996-07-01' AND NOW() + INTERVAL '1 day'),
    CONSTRAINT "CK_Employee_Gender" CHECK (UPPER(Gender) IN ('M', 'F')), -- Male or Female
    CONSTRAINT "CK_Employee_VacationHours" CHECK (VacationHours BETWEEN -40 AND 240),
    CONSTRAINT "CK_Employee_SickLeaveHours" CHECK (SickLeaveHours BETWEEN 0 AND 120)
  );
  CREATE TABLE HumanResources.EmployeeDepartmentHistory(
    BusinessEntityID INT NOT NULL,
    DepartmentID smallint NOT NULL,
    ShiftID smallint NOT NULL, -- tinyint
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_EmployeeDepartmentHistory_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_EmployeeDepartmentHistory_EndDate" CHECK ((EndDate >= StartDate) OR (EndDate IS NULL))
  );
  CREATE TABLE HumanResources.EmployeePayHistory(
    BusinessEntityID INT NOT NULL,
    RateChangeDate TIMESTAMP NOT NULL,
    Rate numeric NOT NULL, -- money
    PayFrequency smallint NOT NULL,  -- tinyint
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_EmployeePayHistory_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_EmployeePayHistory_PayFrequency" CHECK (PayFrequency IN (1, 2)), -- 1 = monthly salary, 2 = biweekly salary
    CONSTRAINT "CK_EmployeePayHistory_Rate" CHECK (Rate BETWEEN 6.50 AND 200.00)
  );
  CREATE TABLE HumanResources.JobCandidate(
    JobCandidateID SERIAL NOT NULL, -- int
    BusinessEntityID INT NULL,
    Resume XML NULL, -- XML(HRResumeSchemaCollection)
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_JobCandidate_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE HumanResources.Shift(
    ShiftID SERIAL NOT NULL, -- tinyint
    Name "Name" NOT NULL,
    StartTime time NOT NULL,
    EndTime time NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Shift_ModifiedDate" DEFAULT (NOW())
  );

COMMENT ON SCHEMA HumanResources.HumanResources IS 'Contains objects related to employees and departments.';

 


  CREATE TABLE Production.BillOfMaterials(
    BillOfMaterialsID SERIAL NOT NULL, -- int
    ProductAssemblyID INT NULL,
    ComponentID INT NOT NULL,
    StartDate TIMESTAMP NOT NULL CONSTRAINT "DF_BillOfMaterials_StartDate" DEFAULT (NOW()),
    EndDate TIMESTAMP NULL,
    UnitMeasureCode char(3) NOT NULL,
    BOMLevel smallint NOT NULL,
    PerAssemblyQty decimal(8, 2) NOT NULL CONSTRAINT "DF_BillOfMaterials_PerAssemblyQty" DEFAULT (1.00),
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_BillOfMaterials_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_BillOfMaterials_EndDate" CHECK ((EndDate > StartDate) OR (EndDate IS NULL)),
    CONSTRAINT "CK_BillOfMaterials_ProductAssemblyID" CHECK (ProductAssemblyID <> ComponentID),
    CONSTRAINT "CK_BillOfMaterials_BOMLevel" CHECK (((ProductAssemblyID IS NULL)
        AND (BOMLevel = 0) AND (PerAssemblyQty = 1.00))
        OR ((ProductAssemblyID IS NOT NULL) AND (BOMLevel >= 1))),
    CONSTRAINT "CK_BillOfMaterials_PerAssemblyQty" CHECK (PerAssemblyQty >= 1.00)
  );
  CREATE TABLE Production.Culture(
    CultureID char(6) NOT NULL,
    Name "Name" NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Culture_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Production.Document(
    Doc varchar NULL,-- hierarchyid, will become DocumentNode
    DocumentLevel INTEGER, -- AS DocumentNode.GetLevel(),
    Title varchar(50) NOT NULL,
    Owner INT NOT NULL,
    FolderFlag "Flag" NOT NULL CONSTRAINT "DF_Document_FolderFlag" DEFAULT (false),
    FileName varchar(400) NOT NULL,
    FileExtension varchar(8) NULL,
    Revision char(5) NOT NULL,
    ChangeNumber INT NOT NULL CONSTRAINT "DF_Document_ChangeNumber" DEFAULT (0),
    Status smallint NOT NULL, -- tinyint
    DocumentSummary text NULL,
    Document bytea  NULL, -- varbinary
    rowguid uuid NOT NULL UNIQUE CONSTRAINT "DF_Document_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Document_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_Document_Status" CHECK (Status BETWEEN 1 AND 3)
  );
  CREATE TABLE Production.ProductCategory(
    ProductCategoryID SERIAL NOT NULL, -- int
    Name "Name" NOT NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_ProductCategory_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductCategory_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Production.ProductSubcategory(
    ProductSubcategoryID SERIAL NOT NULL, -- int
    ProductCategoryID INT NOT NULL,
    Name "Name" NOT NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_ProductSubcategory_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductSubcategory_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Production.ProductModel(
    ProductModelID SERIAL NOT NULL, -- int
    Name "Name" NOT NULL,
    CatalogDescription XML NULL, -- XML(Production.ProductDescriptionSchemaCollection)
    Instructions XML NULL, -- XML(Production.ManuInstructionsSchemaCollection)
    rowguid uuid NOT NULL CONSTRAINT "DF_ProductModel_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductModel_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Production.Product(
    ProductID SERIAL NOT NULL, -- int
    Name "Name" NOT NULL,
    ProductNumber varchar(25) NOT NULL,
    MakeFlag "Flag" NOT NULL CONSTRAINT "DF_Product_MakeFlag" DEFAULT (true),
    FinishedGoodsFlag "Flag" NOT NULL CONSTRAINT "DF_Product_FinishedGoodsFlag" DEFAULT (true),
    Color varchar(15) NULL,
    SafetyStockLevel smallint NOT NULL,
    ReorderPoint smallint NOT NULL,
    StandardCost numeric NOT NULL, -- money
    ListPrice numeric NOT NULL, -- money
    Size varchar(5) NULL,
    SizeUnitMeasureCode char(3) NULL,
    WeightUnitMeasureCode char(3) NULL,
    Weight decimal(8, 2) NULL,
    DaysToManufacture INT NOT NULL,
    ProductLine char(2) NULL,
    Class char(2) NULL,
    Style char(2) NULL,
    ProductSubcategoryID INT NULL,
    ProductModelID INT NULL,
    SellStartDate TIMESTAMP NOT NULL,
    SellEndDate TIMESTAMP NULL,
    DiscontinuedDate TIMESTAMP NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_Product_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Product_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_Product_SafetyStockLevel" CHECK (SafetyStockLevel > 0),
    CONSTRAINT "CK_Product_ReorderPoint" CHECK (ReorderPoint > 0),
    CONSTRAINT "CK_Product_StandardCost" CHECK (StandardCost >= 0.00),
    CONSTRAINT "CK_Product_ListPrice" CHECK (ListPrice >= 0.00),
    CONSTRAINT "CK_Product_Weight" CHECK (Weight > 0.00),
    CONSTRAINT "CK_Product_DaysToManufacture" CHECK (DaysToManufacture >= 0),
    CONSTRAINT "CK_Product_ProductLine" CHECK (UPPER(ProductLine) IN ('S', 'T', 'M', 'R') OR ProductLine IS NULL),
    CONSTRAINT "CK_Product_Class" CHECK (UPPER(Class) IN ('L', 'M', 'H') OR Class IS NULL),
    CONSTRAINT "CK_Product_Style" CHECK (UPPER(Style) IN ('W', 'M', 'U') OR Style IS NULL),
    CONSTRAINT "CK_Product_SellEndDate" CHECK ((SellEndDate >= SellStartDate) OR (SellEndDate IS NULL))
  );
  CREATE TABLE Production.ProductCostHistory(
    ProductID INT NOT NULL,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP NULL,
    StandardCost numeric NOT NULL,  -- money
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductCostHistory_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_ProductCostHistory_EndDate" CHECK ((EndDate >= StartDate) OR (EndDate IS NULL)),
    CONSTRAINT "CK_ProductCostHistory_StandardCost" CHECK (StandardCost >= 0.00)
  );
  CREATE TABLE Production.ProductDescription(
    ProductDescriptionID SERIAL NOT NULL, -- int
    Description varchar(400) NOT NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_ProductDescription_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductDescription_ModifiedDate" DEFAULT (NOW())
  )
  CREATE TABLE Production.ProductDocument(
    ProductID INT NOT NULL,
    Doc varchar NOT NULL, -- hierarchyid, will become DocumentNode
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductDocument_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Production.Location(
    LocationID SERIAL NOT NULL, -- smallint
    Name "Name" NOT NULL,
    CostRate numeric NOT NULL CONSTRAINT "DF_Location_CostRate" DEFAULT (0.00), -- smallmoney -- money
    Availability decimal(8, 2) NOT NULL CONSTRAINT "DF_Location_Availability" DEFAULT (0.00),
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Location_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_Location_CostRate" CHECK (CostRate >= 0.00),
    CONSTRAINT "CK_Location_Availability" CHECK (Availability >= 0.00)
  );
  CREATE TABLE Production.ProductInventory(
    ProductID INT NOT NULL,
    LocationID smallint NOT NULL,
    Shelf varchar(10) NOT NULL,
    Bin smallint NOT NULL, -- tinyint
    Quantity smallint NOT NULL CONSTRAINT "DF_ProductInventory_Quantity" DEFAULT (0),
    rowguid uuid NOT NULL CONSTRAINT "DF_ProductInventory_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductInventory_ModifiedDate" DEFAULT (NOW()),
--    CONSTRAINT "CK_ProductInventory_Shelf" CHECK ((Shelf LIKE 'AZa-z]') OR (Shelf = 'N/A')),
    CONSTRAINT "CK_ProductInventory_Bin" CHECK (Bin BETWEEN 0 AND 100)
  );
  CREATE TABLE Production.ProductListPriceHistory(
    ProductID INT NOT NULL,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP NULL,
    ListPrice numeric NOT NULL,  -- money
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductListPriceHistory_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_ProductListPriceHistory_EndDate" CHECK ((EndDate >= StartDate) OR (EndDate IS NULL)),
    CONSTRAINT "CK_ProductListPriceHistory_ListPrice" CHECK (ListPrice > 0.00)
  );
  CREATE TABLE Production.Illustration(
    IllustrationID SERIAL NOT NULL, -- int
    Diagram XML NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Illustration_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Production.ProductModelIllustration(
    ProductModelID INT NOT NULL,
    IllustrationID INT NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductModelIllustration_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Production.ProductModelProductDescriptionCulture(
    ProductModelID INT NOT NULL,
    ProductDescriptionID INT NOT NULL,
    CultureID char(6) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductModelProductDescriptionCulture_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Production.ProductPhoto(
    ProductPhotoID SERIAL NOT NULL, -- int
    ThumbNailPhoto bytea NULL,-- varbinary
    ThumbnailPhotoFileName varchar(50) NULL,
    LargePhoto bytea NULL,-- varbinary
    LargePhotoFileName varchar(50) NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductPhoto_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Production.ProductProductPhoto(
    ProductID INT NOT NULL,
    ProductPhotoID INT NOT NULL,
    "primary" "Flag" NOT NULL CONSTRAINT "DF_ProductProductPhoto_Primary" DEFAULT (false),
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductProductPhoto_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Production.ProductReview(
    ProductReviewID SERIAL NOT NULL, -- int
    ProductID INT NOT NULL,
    ReviewerName "Name" NOT NULL,
    ReviewDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductReview_ReviewDate" DEFAULT (NOW()),
    EmailAddress varchar(50) NOT NULL,
    Rating INT NOT NULL,
    Comments varchar(3850),
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductReview_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_ProductReview_Rating" CHECK (Rating BETWEEN 1 AND 5)
  );
  CREATE TABLE Production.ScrapReason(
    ScrapReasonID SERIAL NOT NULL, -- smallint
    Name "Name" NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ScrapReason_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Production.TransactionHistory(
    TransactionID SERIAL NOT NULL, -- INT IDENTITY (100000, 1)
    ProductID INT NOT NULL,
    ReferenceOrderID INT NOT NULL,
    ReferenceOrderLineID INT NOT NULL CONSTRAINT "DF_TransactionHistory_ReferenceOrderLineID" DEFAULT (0),
    TransactionDate TIMESTAMP NOT NULL CONSTRAINT "DF_TransactionHistory_TransactionDate" DEFAULT (NOW()),
    TransactionType char(1) NOT NULL,
    Quantity INT NOT NULL,
    ActualCost numeric NOT NULL,  -- money
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_TransactionHistory_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_TransactionHistory_TransactionType" CHECK (UPPER(TransactionType) IN ('W', 'S', 'P'))
  );
  CREATE TABLE Production.TransactionHistoryArchive(
    TransactionID INT NOT NULL,
    ProductID INT NOT NULL,
    ReferenceOrderID INT NOT NULL,
    ReferenceOrderLineID INT NOT NULL CONSTRAINT "DF_TransactionHistoryArchive_ReferenceOrderLineID" DEFAULT (0),
    TransactionDate TIMESTAMP NOT NULL CONSTRAINT "DF_TransactionHistoryArchive_TransactionDate" DEFAULT (NOW()),
    TransactionType char(1) NOT NULL,
    Quantity INT NOT NULL,
    ActualCost numeric NOT NULL,  -- money
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_TransactionHistoryArchive_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_TransactionHistoryArchive_TransactionType" CHECK (UPPER(TransactionType) IN ('W', 'S', 'P'))
  );
  CREATE TABLE Production.UnitMeasure(
    UnitMeasureCode char(3) NOT NULL,
    Name "Name" NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_UnitMeasure_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Production.WorkOrder(
    WorkOrderID SERIAL NOT NULL, -- int
    ProductID INT NOT NULL,
    OrderQty INT NOT NULL,
    StockedQty INT, -- AS ISNULL(OrderQty - ScrappedQty, 0),
    ScrappedQty smallint NOT NULL,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP NULL,
    DueDate TIMESTAMP NOT NULL,
    ScrapReasonID smallint NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_WorkOrder_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_WorkOrder_OrderQty" CHECK (OrderQty > 0),
    CONSTRAINT "CK_WorkOrder_ScrappedQty" CHECK (ScrappedQty >= 0),
    CONSTRAINT "CK_WorkOrder_EndDate" CHECK ((EndDate >= StartDate) OR (EndDate IS NULL))
  );
  CREATE TABLE Production.WorkOrderRouting(
    WorkOrderID INT NOT NULL,
    ProductID INT NOT NULL,
    OperationSequence smallint NOT NULL,
    LocationID smallint NOT NULL,
    ScheduledStartDate TIMESTAMP NOT NULL,
    ScheduledEndDate TIMESTAMP NOT NULL,
    ActualStartDate TIMESTAMP NULL,
    ActualEndDate TIMESTAMP NULL,
    ActualResourceHrs decimal(9, 4) NULL,
    PlannedCost numeric NOT NULL, -- money
    ActualCost numeric NULL,  -- money
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_WorkOrderRouting_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_WorkOrderRouting_ScheduledEndDate" CHECK (ScheduledEndDate >= ScheduledStartDate),
    CONSTRAINT "CK_WorkOrderRouting_ActualEndDate" CHECK ((ActualEndDate >= ActualStartDate)
        OR (ActualEndDate IS NULL) OR (ActualStartDate IS NULL)),
    CONSTRAINT "CK_WorkOrderRouting_ActualResourceHrs" CHECK (ActualResourceHrs >= 0.0000),
    CONSTRAINT "CK_WorkOrderRouting_PlannedCost" CHECK (PlannedCost > 0.00),
    CONSTRAINT "CK_WorkOrderRouting_ActualCost" CHECK (ActualCost > 0.00)
  );

COMMENT ON SCHEMA Production IS 'Contains objects related to products, inventory, and manufacturing.';

 

-- Calculated columns that needed to be there just for the CSV import
ALTER TABLE Production.WorkOrder DROP COLUMN StockedQty;
ALTER TABLE Production.Document DROP COLUMN DocumentLevel; 
-- Document HierarchyID column
ALTER TABLE Production.Document ADD DocumentNode VARCHAR DEFAULT '/';
-- Convert from all the hex to a stream of hierarchyid bits
WITH RECURSIVE hier AS (
  SELECT rowguid, doc, get_byte(decode(substring(doc, 1, 2), 'hex'), 0)::bit(8)::varchar AS bits, 2 AS i
    FROM Production.Document
  UNION ALL
  SELECT e.rowguid, e.doc, hier.bits || get_byte(decode(substring(e.doc, i + 1, 2), 'hex'), 0)::bit(8)::varchar, i + 2 AS i
    FROM Production.Document AS e INNER JOIN
      hier ON e.rowguid = hier.rowguid AND i < LENGTH(e.doc)
)
UPDATE Production.Document AS emp
  SET doc = COALESCE(trim(trailing '0' FROM hier.bits::TEXT), '')
  FROM hier
  WHERE emp.rowguid = hier.rowguid
    AND (hier.doc IS NULL OR i = LENGTH(hier.doc));

-- Convert bits to the real hieararchy paths
CREATE OR REPLACE FUNCTION f_ConvertDocNodes()
  RETURNS void AS
$func$
DECLARE
  got_none BOOLEAN;
BEGIN
  LOOP
  got_none := true;
  -- 01 = 0-3
  UPDATE Production.Document
   SET DocumentNode = DocumentNode || SUBSTRING(doc, 3,2)::bit(2)::INTEGER::VARCHAR || CASE SUBSTRING(doc, 5, 1) WHEN '0' THEN '.' ELSE '/' END,
     doc = SUBSTRING(doc, 6, 9999)
    WHERE doc LIKE '01%';
  IF FOUND THEN
    got_none := false;
  END IF;

  -- 100 = 4-7
  UPDATE Production.Document
   SET DocumentNode = DocumentNode || (SUBSTRING(doc, 4,2)::bit(2)::INTEGER + 4)::VARCHAR || CASE SUBSTRING(doc, 6, 1) WHEN '0' THEN '.' ELSE '/' END,
     doc = SUBSTRING(doc, 7, 9999)
    WHERE doc LIKE '100%';
  IF FOUND THEN
    got_none := false;
  END IF;
  
  -- 101 = 8-15
  UPDATE Production.Document
   SET DocumentNode = DocumentNode || (SUBSTRING(doc, 4,3)::bit(3)::INTEGER + 8)::VARCHAR || CASE SUBSTRING(doc, 7, 1) WHEN '0' THEN '.' ELSE '/' END,
     doc = SUBSTRING(doc, 8, 9999)
    WHERE doc LIKE '101%';
  IF FOUND THEN
    got_none := false;
  END IF;

  -- 110 = 16-79
  UPDATE Production.Document
   SET DocumentNode = DocumentNode || ((SUBSTRING(doc, 4,2)||SUBSTRING(doc, 7,1)||SUBSTRING(doc, 9,3))::bit(6)::INTEGER + 16)::VARCHAR || CASE SUBSTRING(doc, 12, 1) WHEN '0' THEN '.' ELSE '/' END,
     doc = SUBSTRING(doc, 13, 9999)
    WHERE doc LIKE '110%';
  IF FOUND THEN
    got_none := false;
  END IF;

  -- 1110 = 80-1103
  UPDATE Production.Document
   SET DocumentNode = DocumentNode || ((SUBSTRING(doc, 5,3)||SUBSTRING(doc, 9,3)||SUBSTRING(doc, 13,1)||SUBSTRING(doc, 15,3))::bit(10)::INTEGER + 80)::VARCHAR || CASE SUBSTRING(doc, 18, 1) WHEN '0' THEN '.' ELSE '/' END,
     doc = SUBSTRING(doc, 19, 9999)
    WHERE doc LIKE '1110%';
  IF FOUND THEN
    got_none := false;
  END IF;
  EXIT WHEN got_none;
  END LOOP;
END
$func$ LANGUAGE plpgsql;

SELECT f_ConvertDocNodes();
-- Drop the original binary hierarchyid column
ALTER TABLE Production.Document DROP COLUMN Doc;
DROP FUNCTION f_ConvertDocNodes();

-- ProductDocument HierarchyID column
  ALTER TABLE Production.ProductDocument ADD DocumentNode VARCHAR DEFAULT '/';
ALTER TABLE Production.ProductDocument ADD rowguid uuid NOT NULL CONSTRAINT "DF_ProductDocument_rowguid" DEFAULT (uuid_generate_v1());
-- Convert from all the hex to a stream of hierarchyid bits
WITH RECURSIVE hier AS (
  SELECT rowguid, doc, get_byte(decode(substring(doc, 1, 2), 'hex'), 0)::bit(8)::varchar AS bits, 2 AS i
    FROM Production.ProductDocument
  UNION ALL
  SELECT e.rowguid, e.doc, hier.bits || get_byte(decode(substring(e.doc, i + 1, 2), 'hex'), 0)::bit(8)::varchar, i + 2 AS i
    FROM Production.ProductDocument AS e INNER JOIN
      hier ON e.rowguid = hier.rowguid AND i < LENGTH(e.doc)
)
UPDATE Production.ProductDocument AS emp
  SET doc = COALESCE(trim(trailing '0' FROM hier.bits::TEXT), '')
  FROM hier
  WHERE emp.rowguid = hier.rowguid
    AND (hier.doc IS NULL OR i = LENGTH(hier.doc));

-- Convert bits to the real hieararchy paths
CREATE OR REPLACE FUNCTION f_ConvertDocNodes()
  RETURNS void AS
$func$
DECLARE
  got_none BOOLEAN;
BEGIN
  LOOP
  got_none := true;
  -- 01 = 0-3
  UPDATE Production.ProductDocument
   SET DocumentNode = DocumentNode || SUBSTRING(doc, 3,2)::bit(2)::INTEGER::VARCHAR || CASE SUBSTRING(doc, 5, 1) WHEN '0' THEN '.' ELSE '/' END,
     doc = SUBSTRING(doc, 6, 9999)
    WHERE doc LIKE '01%';
  IF FOUND THEN
    got_none := false;
  END IF;

  -- 100 = 4-7
  UPDATE Production.ProductDocument
   SET DocumentNode = DocumentNode || (SUBSTRING(doc, 4,2)::bit(2)::INTEGER + 4)::VARCHAR || CASE SUBSTRING(doc, 6, 1) WHEN '0' THEN '.' ELSE '/' END,
     doc = SUBSTRING(doc, 7, 9999)
    WHERE doc LIKE '100%';
  IF FOUND THEN
    got_none := false;
  END IF;
  
  -- 101 = 8-15
  UPDATE Production.ProductDocument
   SET DocumentNode = DocumentNode || (SUBSTRING(doc, 4,3)::bit(3)::INTEGER + 8)::VARCHAR || CASE SUBSTRING(doc, 7, 1) WHEN '0' THEN '.' ELSE '/' END,
     doc = SUBSTRING(doc, 8, 9999)
    WHERE doc LIKE '101%';
  IF FOUND THEN
    got_none := false;
  END IF;

  -- 110 = 16-79
  UPDATE Production.ProductDocument
   SET DocumentNode = DocumentNode || ((SUBSTRING(doc, 4,2)||SUBSTRING(doc, 7,1)||SUBSTRING(doc, 9,3))::bit(6)::INTEGER + 16)::VARCHAR || CASE SUBSTRING(doc, 12, 1) WHEN '0' THEN '.' ELSE '/' END,
     doc = SUBSTRING(doc, 13, 9999)
    WHERE doc LIKE '110%';
  IF FOUND THEN
    got_none := false;
  END IF;

  -- 1110 = 80-1103
  UPDATE Production.ProductDocument
   SET DocumentNode = DocumentNode || ((SUBSTRING(doc, 5,3)||SUBSTRING(doc, 9,3)||SUBSTRING(doc, 13,1)||SUBSTRING(doc, 15,3))::bit(10)::INTEGER + 80)::VARCHAR || CASE SUBSTRING(doc, 18, 1) WHEN '0' THEN '.' ELSE '/' END,
     doc = SUBSTRING(doc, 19, 9999)
    WHERE doc LIKE '1110%';
  IF FOUND THEN
    got_none := false;
  END IF;
  EXIT WHEN got_none;
  END LOOP;
END
$func$ LANGUAGE plpgsql;

SELECT f_ConvertDocNodes();
-- Drop the original binary hierarchyid column
ALTER TABLE Production.ProductDocument DROP COLUMN Doc;
DROP FUNCTION f_ConvertDocNodes();
ALTER TABLE Production.ProductDocument DROP COLUMN rowguid;

 

  CREATE TABLE Purchasing.ProductVendor(
    ProductID INT NOT NULL,
    BusinessEntityID INT NOT NULL,
    AverageLeadTime INT NOT NULL,
    StandardPrice numeric NOT NULL, -- money
    LastReceiptCost numeric NULL, -- money
    LastReceiptDate TIMESTAMP NULL,
    MinOrderQty INT NOT NULL,
    MaxOrderQty INT NOT NULL,
    OnOrderQty INT NULL,
    UnitMeasureCode char(3) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ProductVendor_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_ProductVendor_AverageLeadTime" CHECK (AverageLeadTime >= 1),
    CONSTRAINT "CK_ProductVendor_StandardPrice" CHECK (StandardPrice > 0.00),
    CONSTRAINT "CK_ProductVendor_LastReceiptCost" CHECK (LastReceiptCost > 0.00),
    CONSTRAINT "CK_ProductVendor_MinOrderQty" CHECK (MinOrderQty >= 1),
    CONSTRAINT "CK_ProductVendor_MaxOrderQty" CHECK (MaxOrderQty >= 1),
    CONSTRAINT "CK_ProductVendor_OnOrderQty" CHECK (OnOrderQty >= 0)
  );
  CREATE TABLE Purchasing.PurchaseOrderDetail(
    PurchaseOrderID INT NOT NULL,
    PurchaseOrderDetailID SERIAL NOT NULL, -- int
    DueDate TIMESTAMP NOT NULL,
    OrderQty smallint NOT NULL,
    ProductID INT NOT NULL,
    UnitPrice numeric NOT NULL, -- money
    LineTotal numeric, -- AS ISNULL(OrderQty * UnitPrice, 0.00),
    ReceivedQty decimal(8, 2) NOT NULL,
    RejectedQty decimal(8, 2) NOT NULL,
    StockedQty numeric, -- AS ISNULL(ReceivedQty - RejectedQty, 0.00),
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_PurchaseOrderDetail_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_PurchaseOrderDetail_OrderQty" CHECK (OrderQty > 0),
    CONSTRAINT "CK_PurchaseOrderDetail_UnitPrice" CHECK (UnitPrice >= 0.00),
    CONSTRAINT "CK_PurchaseOrderDetail_ReceivedQty" CHECK (ReceivedQty >= 0.00),
    CONSTRAINT "CK_PurchaseOrderDetail_RejectedQty" CHECK (RejectedQty >= 0.00)
  );
  CREATE TABLE Purchasing.PurchaseOrderHeader(
    PurchaseOrderID SERIAL NOT NULL,  -- int
    RevisionNumber smallint NOT NULL CONSTRAINT "DF_PurchaseOrderHeader_RevisionNumber" DEFAULT (0),  -- tinyint
    Status smallint NOT NULL CONSTRAINT "DF_PurchaseOrderHeader_Status" DEFAULT (1),  -- tinyint
    EmployeeID INT NOT NULL,
    VendorID INT NOT NULL,
    ShipMethodID INT NOT NULL,
    OrderDate TIMESTAMP NOT NULL CONSTRAINT "DF_PurchaseOrderHeader_OrderDate" DEFAULT (NOW()),
    ShipDate TIMESTAMP NULL,
    SubTotal numeric NOT NULL CONSTRAINT "DF_PurchaseOrderHeader_SubTotal" DEFAULT (0.00),  -- money
    TaxAmt numeric NOT NULL CONSTRAINT "DF_PurchaseOrderHeader_TaxAmt" DEFAULT (0.00),  -- money
    Freight numeric NOT NULL CONSTRAINT "DF_PurchaseOrderHeader_Freight" DEFAULT (0.00),  -- money
    TotalDue numeric, -- AS ISNULL(SubTotal + TaxAmt + Freight, 0) PERSISTED NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_PurchaseOrderHeader_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_PurchaseOrderHeader_Status" CHECK (Status BETWEEN 1 AND 4), -- 1 = Pending; 2 = Approved; 3 = Rejected; 4 = Complete
    CONSTRAINT "CK_PurchaseOrderHeader_ShipDate" CHECK ((ShipDate >= OrderDate) OR (ShipDate IS NULL)),
    CONSTRAINT "CK_PurchaseOrderHeader_SubTotal" CHECK (SubTotal >= 0.00),
    CONSTRAINT "CK_PurchaseOrderHeader_TaxAmt" CHECK (TaxAmt >= 0.00),
    CONSTRAINT "CK_PurchaseOrderHeader_Freight" CHECK (Freight >= 0.00)
  );
  CREATE TABLE Purchasing.ShipMethod(
    ShipMethodID SERIAL NOT NULL, -- int
    Name "Name" NOT NULL,
    ShipBase numeric NOT NULL CONSTRAINT "DF_ShipMethod_ShipBase" DEFAULT (0.00), -- money
    ShipRate numeric NOT NULL CONSTRAINT "DF_ShipMethod_ShipRate" DEFAULT (0.00), -- money
    rowguid uuid NOT NULL CONSTRAINT "DF_ShipMethod_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ShipMethod_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_ShipMethod_ShipBase" CHECK (ShipBase > 0.00),
    CONSTRAINT "CK_ShipMethod_ShipRate" CHECK (ShipRate > 0.00)
  );
  CREATE TABLE Purchasing.Vendor(
    BusinessEntityID INT NOT NULL,
    AccountNumber "AccountNumber" NOT NULL,
    Name "Name" NOT NULL,
    CreditRating smallint NOT NULL, -- tinyint
    PreferredVendorStatus "Flag" NOT NULL CONSTRAINT "DF_Vendor_PreferredVendorStatus" DEFAULT (true),
    ActiveFlag "Flag" NOT NULL CONSTRAINT "DF_Vendor_ActiveFlag" DEFAULT (true),
    PurchasingWebServiceURL varchar(1024) NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Vendor_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_Vendor_CreditRating" CHECK (CreditRating BETWEEN 1 AND 5)
  );

COMMENT ON SCHEMA Purchasing.Purchasing IS 'Contains objects related to vendors and purchase orders.';
 
-- Calculated columns that needed to be there just for the CSV import
ALTER TABLE Purchasing.PurchaseOrderDetail DROP COLUMN LineTotal;
ALTER TABLE Purchasing.PurchaseOrderDetail DROP COLUMN StockedQty;
ALTER TABLE Purchasing.PurchaseOrderHeader DROP COLUMN TotalDue;




  CREATE TABLE Sales.CountryRegionCurrency(
    CountryRegionCode varchar(3) NOT NULL,
    CurrencyCode char(3) NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_CountryRegionCurrency_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Sales.CreditCard(
    CreditCardID SERIAL NOT NULL, -- int
    CardType varchar(50) NOT NULL,
    CardNumber varchar(25) NOT NULL,
    ExpMonth smallint NOT NULL, -- tinyint
    ExpYear smallint NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_CreditCard_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Sales.Currency(
    CurrencyCode char(3) NOT NULL,
    Name "Name" NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Currency_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Sales.CurrencyRate(
    CurrencyRateID SERIAL NOT NULL, -- int
    CurrencyRateDate TIMESTAMP NOT NULL,   
    FromCurrencyCode char(3) NOT NULL,
    ToCurrencyCode char(3) NOT NULL,
    AverageRate numeric NOT NULL, -- money
    EndOfDayRate numeric NOT NULL,  -- money
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_CurrencyRate_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Sales.Customer(
    CustomerID SERIAL NOT NULL, --  NOT FOR REPLICATION -- int
    -- A customer may either be a person, a store, or a person who works for a store
    PersonID INT NULL, -- If this customer represents a person, this is non-null
    StoreID INT NULL,  -- If the customer is a store, or is associated with a store then this is non-null.
    TerritoryID INT NULL,
    AccountNumber VARCHAR, -- AS ISNULL('AW' + dbo.ufnLeadingZeros(CustomerID), ''),
    rowguid uuid NOT NULL CONSTRAINT "DF_Customer_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Customer_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Sales.PersonCreditCard(
    BusinessEntityID INT NOT NULL,
    CreditCardID INT NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_PersonCreditCard_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Sales.SalesOrderDetail(
    SalesOrderID INT NOT NULL,
    SalesOrderDetailID SERIAL NOT NULL, -- int
    CarrierTrackingNumber varchar(25) NULL,
    OrderQty smallint NOT NULL,
    ProductID INT NOT NULL,
    SpecialOfferID INT NOT NULL,
    UnitPrice numeric NOT NULL, -- money
    UnitPriceDiscount numeric NOT NULL CONSTRAINT "DF_SalesOrderDetail_UnitPriceDiscount" DEFAULT (0.0), -- money
    LineTotal numeric, -- AS ISNULL(UnitPrice * (1.0 - UnitPriceDiscount) * OrderQty, 0.0),
    rowguid uuid NOT NULL CONSTRAINT "DF_SalesOrderDetail_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_SalesOrderDetail_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_SalesOrderDetail_OrderQty" CHECK (OrderQty > 0),
    CONSTRAINT "CK_SalesOrderDetail_UnitPrice" CHECK (UnitPrice >= 0.00),
    CONSTRAINT "CK_SalesOrderDetail_UnitPriceDiscount" CHECK (UnitPriceDiscount >= 0.00)
  );
  CREATE TABLE Sales.SalesOrderHeader(
    SalesOrderID SERIAL NOT NULL, --  NOT FOR REPLICATION -- int
    RevisionNumber smallint NOT NULL CONSTRAINT "DF_SalesOrderHeader_RevisionNumber" DEFAULT (0), -- tinyint
    OrderDate TIMESTAMP NOT NULL CONSTRAINT "DF_SalesOrderHeader_OrderDate" DEFAULT (NOW()),
    DueDate TIMESTAMP NOT NULL,
    ShipDate TIMESTAMP NULL,
    Status smallint NOT NULL CONSTRAINT "DF_SalesOrderHeader_Status" DEFAULT (1), -- tinyint
    OnlineOrderFlag "Flag" NOT NULL CONSTRAINT "DF_SalesOrderHeader_OnlineOrderFlag" DEFAULT (true),
    SalesOrderNumber VARCHAR(23), -- AS ISNULL(N'SO' + CONVERT(nvarchar(23), SalesOrderID), N'*** ERROR ***'),
    PurchaseOrderNumber "OrderNumber" NULL,
    AccountNumber "AccountNumber" NULL,
    CustomerID INT NOT NULL,
    SalesPersonID INT NULL,
    TerritoryID INT NULL,
    BillToAddressID INT NOT NULL,
    ShipToAddressID INT NOT NULL,
    ShipMethodID INT NOT NULL,
    CreditCardID INT NULL,
    CreditCardApprovalCode varchar(15) NULL,   
    CurrencyRateID INT NULL,
    SubTotal numeric NOT NULL CONSTRAINT "DF_SalesOrderHeader_SubTotal" DEFAULT (0.00), -- money
    TaxAmt numeric NOT NULL CONSTRAINT "DF_SalesOrderHeader_TaxAmt" DEFAULT (0.00), -- money
    Freight numeric NOT NULL CONSTRAINT "DF_SalesOrderHeader_Freight" DEFAULT (0.00), -- money
    TotalDue numeric, -- AS ISNULL(SubTotal + TaxAmt + Freight, 0),
    Comment varchar(128) NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_SalesOrderHeader_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_SalesOrderHeader_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_SalesOrderHeader_Status" CHECK (Status BETWEEN 0 AND 8),
    CONSTRAINT "CK_SalesOrderHeader_DueDate" CHECK (DueDate >= OrderDate),
    CONSTRAINT "CK_SalesOrderHeader_ShipDate" CHECK ((ShipDate >= OrderDate) OR (ShipDate IS NULL)),
    CONSTRAINT "CK_SalesOrderHeader_SubTotal" CHECK (SubTotal >= 0.00),
    CONSTRAINT "CK_SalesOrderHeader_TaxAmt" CHECK (TaxAmt >= 0.00),
    CONSTRAINT "CK_SalesOrderHeader_Freight" CHECK (Freight >= 0.00)
  );
  CREATE TABLE Sales.SalesOrderHeaderSalesReason(
    SalesOrderID INT NOT NULL,
    SalesReasonID INT NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_SalesOrderHeaderSalesReason_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Sales.SalesPerson(
    BusinessEntityID INT NOT NULL,
    TerritoryID INT NULL,
    SalesQuota numeric NULL, -- money
    Bonus numeric NOT NULL CONSTRAINT "DF_SalesPerson_Bonus" DEFAULT (0.00), -- money
    CommissionPct numeric NOT NULL CONSTRAINT "DF_SalesPerson_CommissionPct" DEFAULT (0.00), -- smallmoney -- money
    SalesYTD numeric NOT NULL CONSTRAINT "DF_SalesPerson_SalesYTD" DEFAULT (0.00), -- money
    SalesLastYear numeric NOT NULL CONSTRAINT "DF_SalesPerson_SalesLastYear" DEFAULT (0.00), -- money
    rowguid uuid NOT NULL CONSTRAINT "DF_SalesPerson_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_SalesPerson_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_SalesPerson_SalesQuota" CHECK (SalesQuota > 0.00),
    CONSTRAINT "CK_SalesPerson_Bonus" CHECK (Bonus >= 0.00),
    CONSTRAINT "CK_SalesPerson_CommissionPct" CHECK (CommissionPct >= 0.00),
    CONSTRAINT "CK_SalesPerson_SalesYTD" CHECK (SalesYTD >= 0.00),
    CONSTRAINT "CK_SalesPerson_SalesLastYear" CHECK (SalesLastYear >= 0.00)
  );
  CREATE TABLE Sales.SalesPersonQuotaHistory(
    BusinessEntityID INT NOT NULL,
    QuotaDate TIMESTAMP NOT NULL,
    SalesQuota numeric NOT NULL, -- money
    rowguid uuid NOT NULL CONSTRAINT "DF_SalesPersonQuotaHistory_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_SalesPersonQuotaHistory_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_SalesPersonQuotaHistory_SalesQuota" CHECK (SalesQuota > 0.00)
  );
  CREATE TABLE Sales.SalesReason(
    SalesReasonID SERIAL NOT NULL, -- int
    Name "Name" NOT NULL,
    ReasonType "Name" NOT NULL,
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_SalesReason_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Sales.SalesTaxRate(
    SalesTaxRateID SERIAL NOT NULL, -- int
    StateProvinceID INT NOT NULL,
    TaxType smallint NOT NULL, -- tinyint
    TaxRate numeric NOT NULL CONSTRAINT "DF_SalesTaxRate_TaxRate" DEFAULT (0.00), -- smallmoney -- money
    Name "Name" NOT NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_SalesTaxRate_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_SalesTaxRate_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_SalesTaxRate_TaxType" CHECK (TaxType BETWEEN 1 AND 3)
  );
  CREATE TABLE Sales.SalesTerritory(
    TerritoryID SERIAL NOT NULL, -- int
    Name "Name" NOT NULL,
    CountryRegionCode varchar(3) NOT NULL,
    "group" varchar(50) NOT NULL, -- Group
    SalesYTD numeric NOT NULL CONSTRAINT "DF_SalesTerritory_SalesYTD" DEFAULT (0.00), -- money
    SalesLastYear numeric NOT NULL CONSTRAINT "DF_SalesTerritory_SalesLastYear" DEFAULT (0.00), -- money
    CostYTD numeric NOT NULL CONSTRAINT "DF_SalesTerritory_CostYTD" DEFAULT (0.00), -- money
    CostLastYear numeric NOT NULL CONSTRAINT "DF_SalesTerritory_CostLastYear" DEFAULT (0.00), -- money
    rowguid uuid NOT NULL CONSTRAINT "DF_SalesTerritory_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_SalesTerritory_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_SalesTerritory_SalesYTD" CHECK (SalesYTD >= 0.00),
    CONSTRAINT "CK_SalesTerritory_SalesLastYear" CHECK (SalesLastYear >= 0.00),
    CONSTRAINT "CK_SalesTerritory_CostYTD" CHECK (CostYTD >= 0.00),
    CONSTRAINT "CK_SalesTerritory_CostLastYear" CHECK (CostLastYear >= 0.00)
  );
  CREATE TABLE Sales.SalesTerritoryHistory(
    BusinessEntityID INT NOT NULL,  -- A sales person
    TerritoryID INT NOT NULL,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_SalesTerritoryHistory_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_SalesTerritoryHistory_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_SalesTerritoryHistory_EndDate" CHECK ((EndDate >= StartDate) OR (EndDate IS NULL))
  );
  CREATE TABLE Sales.ShoppingCartItem(
    ShoppingCartItemID SERIAL NOT NULL, -- int
    ShoppingCartID varchar(50) NOT NULL,
    Quantity INT NOT NULL CONSTRAINT "DF_ShoppingCartItem_Quantity" DEFAULT (1),
    ProductID INT NOT NULL,
    DateCreated TIMESTAMP NOT NULL CONSTRAINT "DF_ShoppingCartItem_DateCreated" DEFAULT (NOW()),
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_ShoppingCartItem_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_ShoppingCartItem_Quantity" CHECK (Quantity >= 1)
  );
  CREATE TABLE Sales.SpecialOffer(
    SpecialOfferID SERIAL NOT NULL, -- int
    Description varchar(255) NOT NULL,
    DiscountPct numeric NOT NULL CONSTRAINT "DF_SpecialOffer_DiscountPct" DEFAULT (0.00), -- smallmoney -- money
    Type varchar(50) NOT NULL,
    Category varchar(50) NOT NULL,
    StartDate TIMESTAMP NOT NULL,
    EndDate TIMESTAMP NOT NULL,
    MinQty INT NOT NULL CONSTRAINT "DF_SpecialOffer_MinQty" DEFAULT (0),
    MaxQty INT NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_SpecialOffer_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_SpecialOffer_ModifiedDate" DEFAULT (NOW()),
    CONSTRAINT "CK_SpecialOffer_EndDate" CHECK (EndDate >= StartDate),
    CONSTRAINT "CK_SpecialOffer_DiscountPct" CHECK (DiscountPct >= 0.00),
    CONSTRAINT "CK_SpecialOffer_MinQty" CHECK (MinQty >= 0),
    CONSTRAINT "CK_SpecialOffer_MaxQty"  CHECK (MaxQty >= 0)
  );
  CREATE TABLE Sales.SpecialOfferProduct(
    SpecialOfferID INT NOT NULL,
    ProductID INT NOT NULL,
    rowguid uuid NOT NULL CONSTRAINT "DF_SpecialOfferProduct_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_SpecialOfferProduct_ModifiedDate" DEFAULT (NOW())
  );
  CREATE TABLE Sales.Store(
    BusinessEntityID INT NOT NULL,
    Name "Name" NOT NULL,
    SalesPersonID INT NULL,
    Demographics XML NULL, -- XML(Sales.StoreSurveySchemaCollection)
    rowguid uuid NOT NULL CONSTRAINT "DF_Store_rowguid" DEFAULT (uuid_generate_v1()), -- ROWGUIDCOL
    ModifiedDate TIMESTAMP NOT NULL CONSTRAINT "DF_Store_ModifiedDate" DEFAULT (NOW())
  );

COMMENT ON SCHEMA Sales.Sales IS 'Contains objects related to customers, sales orders, and sales territories.';