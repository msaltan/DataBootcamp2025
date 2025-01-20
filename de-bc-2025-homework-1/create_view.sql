CREATE VIEW Person.vAdditionalContactInfo
AS
SELECT
    p.BusinessEntityID
    ,p.FirstName
    ,p.MiddleName
    ,p.LastName
    ,(xpath('(act:telephoneNumber)[1]/act:number/text()',                node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'))[1]
               AS TelephoneNumber
    ,BTRIM(
     (xpath('(act:telephoneNumber)[1]/act:SpecialInstructions/text()',   node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'))[1]::VARCHAR)
               AS TelephoneSpecialInstructions
    ,(xpath('(act:homePostalAddress)[1]/act:Street/text()',              node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'))[1]
               AS Street
    ,(xpath('(act:homePostalAddress)[1]/act:City/text()',                node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'))[1]
               AS City
    ,(xpath('(act:homePostalAddress)[1]/act:StateProvince/text()',       node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'))[1]
               AS StateProvince
    ,(xpath('(act:homePostalAddress)[1]/act:PostalCode/text()',          node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'))[1]
               AS PostalCode
    ,(xpath('(act:homePostalAddress)[1]/act:CountryRegion/text()',       node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'))[1]
               AS CountryRegion
    ,(xpath('(act:homePostalAddress)[1]/act:SpecialInstructions/text()', node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'))[1]
               AS HomeAddressSpecialInstructions
    ,(xpath('(act:eMail)[1]/act:eMailAddress/text()',                    node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'))[1]
               AS EMailAddress
    ,BTRIM(
     (xpath('(act:eMail)[1]/act:SpecialInstructions/text()',             node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'))[1]::VARCHAR)
               AS EMailSpecialInstructions
    ,(xpath('((act:eMail)[1]/act:SpecialInstructions/act:telephoneNumber)[1]/act:number/text()', node, '{{act,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes}}'))[1]
               AS EMailTelephoneNumber
    ,p.rowguid
    ,p.ModifiedDate
FROM Person.Person AS p
  LEFT OUTER JOIN
    (SELECT
      BusinessEntityID
      ,UNNEST(xpath('/ci:AdditionalContactInfo',
        additionalcontactinfo,
        '{{ci,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo}}')) AS node
    FROM Person.Person
    WHERE AdditionalContactInfo IS NOT NULL) AS additional
  ON p.BusinessEntityID = additional.BusinessEntityID;


CREATE VIEW HumanResources.vEmployee
AS
SELECT
    e.BusinessEntityID
    ,p.Title
    ,p.FirstName
    ,p.MiddleName
    ,p.LastName
    ,p.Suffix
    ,e.JobTitle 
    ,pp.PhoneNumber
    ,pnt.Name AS PhoneNumberType
    ,ea.EmailAddress
    ,p.EmailPromotion
    ,a.AddressLine1
    ,a.AddressLine2
    ,a.City
    ,sp.Name AS StateProvinceName
    ,a.PostalCode
    ,cr.Name AS CountryRegionName
    ,p.AdditionalContactInfo
FROM HumanResources.Employee e
  INNER JOIN Person.Person p
    ON p.BusinessEntityID = e.BusinessEntityID
  INNER JOIN Person.BusinessEntityAddress bea
    ON bea.BusinessEntityID = e.BusinessEntityID
  INNER JOIN Person.Address a
    ON a.AddressID = bea.AddressID
  INNER JOIN Person.StateProvince sp
    ON sp.StateProvinceID = a.StateProvinceID
  INNER JOIN Person.CountryRegion cr
    ON cr.CountryRegionCode = sp.CountryRegionCode
  LEFT OUTER JOIN Person.PersonPhone pp
    ON pp.BusinessEntityID = p.BusinessEntityID
  LEFT OUTER JOIN Person.PhoneNumberType pnt
    ON pp.PhoneNumberTypeID = pnt.PhoneNumberTypeID
  LEFT OUTER JOIN Person.EmailAddress ea
    ON p.BusinessEntityID = ea.BusinessEntityID;


CREATE VIEW HumanResources.vEmployeeDepartment
AS
SELECT
    e.BusinessEntityID
    ,p.Title
    ,p.FirstName
    ,p.MiddleName
    ,p.LastName
    ,p.Suffix
    ,e.JobTitle
    ,d.Name AS Department
    ,d.GroupName
    ,edh.StartDate
FROM HumanResources.Employee e
  INNER JOIN Person.Person p
    ON p.BusinessEntityID = e.BusinessEntityID
  INNER JOIN HumanResources.EmployeeDepartmentHistory edh
    ON e.BusinessEntityID = edh.BusinessEntityID
  INNER JOIN HumanResources.Department d
    ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL;


CREATE VIEW HumanResources.vEmployeeDepartmentHistory
AS
SELECT
    e.BusinessEntityID
    ,p.Title
    ,p.FirstName
    ,p.MiddleName
    ,p.LastName
    ,p.Suffix
    ,s.Name AS Shift
    ,d.Name AS Department
    ,d.GroupName
    ,edh.StartDate
    ,edh.EndDate
FROM HumanResources.Employee e
  INNER JOIN Person.Person p
    ON p.BusinessEntityID = e.BusinessEntityID
  INNER JOIN HumanResources.EmployeeDepartmentHistory edh
    ON e.BusinessEntityID = edh.BusinessEntityID
  INNER JOIN HumanResources.Department d
    ON edh.DepartmentID = d.DepartmentID
  INNER JOIN HumanResources.Shift s
    ON s.ShiftID = edh.ShiftID;


CREATE VIEW Sales.vIndividualCustomer
AS
SELECT
    p.BusinessEntityID
    ,p.Title
    ,p.FirstName
    ,p.MiddleName
    ,p.LastName
    ,p.Suffix
    ,pp.PhoneNumber
    ,pnt.Name AS PhoneNumberType
    ,ea.EmailAddress
    ,p.EmailPromotion
    ,at.Name AS AddressType
    ,a.AddressLine1
    ,a.AddressLine2
    ,a.City
    ,sp.Name AS StateProvinceName
    ,a.PostalCode
    ,cr.Name AS CountryRegionName
    ,p.Demographics
FROM Person.Person p
  INNER JOIN Person.BusinessEntityAddress bea
    ON bea.BusinessEntityID = p.BusinessEntityID
  INNER JOIN Person.Address a
    ON a.AddressID = bea.AddressID
  INNER JOIN Person.StateProvince sp
    ON sp.StateProvinceID = a.StateProvinceID
  INNER JOIN Person.CountryRegion cr
    ON cr.CountryRegionCode = sp.CountryRegionCode
  INNER JOIN Person.AddressType at
    ON at.AddressTypeID = bea.AddressTypeID
  INNER JOIN Sales.Customer c
    ON c.PersonID = p.BusinessEntityID
  LEFT OUTER JOIN Person.EmailAddress ea
    ON ea.BusinessEntityID = p.BusinessEntityID
  LEFT OUTER JOIN Person.PersonPhone pp
    ON pp.BusinessEntityID = p.BusinessEntityID
  LEFT OUTER JOIN Person.PhoneNumberType pnt
    ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID
WHERE c.StoreID IS NULL;


CREATE VIEW Sales.vPersonDemographics
AS
SELECT
    BusinessEntityID
    ,CAST((xpath('n:TotalPurchaseYTD/text()', Demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'))[1]::VARCHAR AS money)
            AS TotalPurchaseYTD
    ,CAST((xpath('n:DateFirstPurchase/text()', Demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'))[1]::VARCHAR AS DATE)
            AS DateFirstPurchase
    ,CAST((xpath('n:BirthDate/text()', Demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'))[1]::VARCHAR AS DATE)
            AS BirthDate
    ,(xpath('n:MaritalStatus/text()', Demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'))[1]::VARCHAR(1)
            AS MaritalStatus
    ,(xpath('n:YearlyIncome/text()', Demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'))[1]::VARCHAR(30)
            AS YearlyIncome
    ,(xpath('n:Gender/text()', Demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'))[1]::VARCHAR(1)
            AS Gender
    ,CAST((xpath('n:TotalChildren/text()', Demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'))[1]::VARCHAR AS INTEGER)
            AS TotalChildren
    ,CAST((xpath('n:NumberChildrenAtHome/text()', Demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'))[1]::VARCHAR AS INTEGER)
            AS NumberChildrenAtHome
    ,(xpath('n:Education/text()', Demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'))[1]::VARCHAR(30)
            AS Education
    ,(xpath('n:Occupation/text()', Demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'))[1]::VARCHAR(30)
            AS Occupation
    ,CAST((xpath('n:HomeOwnerFlag/text()', Demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'))[1]::VARCHAR AS BOOLEAN)
            AS HomeOwnerFlag
    ,CAST((xpath('n:NumberCarsOwned/text()', Demographics, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey}}'))[1]::VARCHAR AS INTEGER)
            AS NumberCarsOwned
FROM Person.Person
  WHERE Demographics IS NOT NULL;


CREATE VIEW HumanResources.vJobCandidate
AS
SELECT
    JobCandidateID
    ,BusinessEntityID
    ,(xpath('/n:Resume/n:Name/n:Name.Prefix/text()', Resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))[1]::varchar(30)
                   AS "Name.Prefix"
    ,(xpath('/n:Resume/n:Name/n:Name.First/text()', Resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))[1]::varchar(30)
                   AS "Name.First"
    ,(xpath('/n:Resume/n:Name/n:Name.Middle/text()', Resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))[1]::varchar(30)
                   AS "Name.Middle"
    ,(xpath('/n:Resume/n:Name/n:Name.Last/text()', Resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))[1]::varchar(30)
                   AS "Name.Last"
    ,(xpath('/n:Resume/n:Name/n:Name.Suffix/text()', Resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))[1]::varchar(30)
                   AS "Name.Suffix"
    ,(xpath('/n:Resume/n:Skills/text()', Resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))[1]::varchar
                   AS "Skills"
    ,(xpath('n:Address/n:Addr.Type/text()', Resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))[1]::varchar(30)
                   AS "Addr.Type"
    ,(xpath('n:Address/n:Addr.Location/n:Location/n:Loc.CountryRegion/text()', Resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))[1]::varchar(100)
                   AS "Addr.Loc.CountryRegion"
    ,(xpath('n:Address/n:Addr.Location/n:Location/n:Loc.State/text()', Resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))[1]::varchar(100)
                   AS "Addr.Loc.State"
    ,(xpath('n:Address/n:Addr.Location/n:Location/n:Loc.City/text()', Resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))[1]::varchar(100)
                   AS "Addr.Loc.City"
    ,(xpath('n:Address/n:Addr.PostalCode/text()', Resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))[1]::varchar(20)
                   AS "Addr.PostalCode"
    ,(xpath('/n:Resume/n:EMail/text()', Resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))[1]::varchar
                   AS "EMail"
    ,(xpath('/n:Resume/n:WebSite/text()', Resume, '{{n,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))[1]::varchar
                   AS "WebSite"
    ,ModifiedDate
FROM HumanResources.JobCandidate;


-- In this case we UNNEST in order to have multiple previous employments listed for
-- each job candidate.  But things become very brittle when using UNNEST like this,
-- with multiple columns...
-- ... if any of our Employment fragments were missing something, such as randomly a
-- Emp.FunctionCategory is not there, then there will be 0 rows returned.  Each
-- Employment element must contain all 10 sub-elements for this approach to work.
-- (See the Education example below for a better alternate approach!)
CREATE VIEW HumanResources.vJobCandidateEmployment
AS
SELECT
    JobCandidateID
    ,CAST(UNNEST(xpath('/ns:Resume/ns:Employment/ns:Emp.StartDate/text()', Resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))::VARCHAR(20) AS DATE)
                                                AS "Emp.StartDate"
    ,CAST(UNNEST(xpath('/ns:Resume/ns:Employment/ns:Emp.EndDate/text()', Resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))::VARCHAR(20) AS DATE)
                                                AS "Emp.EndDate"
    ,UNNEST(xpath('/ns:Resume/ns:Employment/ns:Emp.OrgName/text()', Resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))::varchar(100)
                                                AS "Emp.OrgName"
    ,UNNEST(xpath('/ns:Resume/ns:Employment/ns:Emp.JobTitle/text()', Resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))::varchar(100)
                                                AS "Emp.JobTitle"
    ,UNNEST(xpath('/ns:Resume/ns:Employment/ns:Emp.Responsibility/text()', Resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))::varchar
                                                AS "Emp.Responsibility"
    ,UNNEST(xpath('/ns:Resume/ns:Employment/ns:Emp.FunctionCategory/text()', Resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))::varchar
                                                AS "Emp.FunctionCategory"
    ,UNNEST(xpath('/ns:Resume/ns:Employment/ns:Emp.IndustryCategory/text()', Resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))::varchar
                                                AS "Emp.IndustryCategory"
    ,UNNEST(xpath('/ns:Resume/ns:Employment/ns:Emp.Location/ns:Location/ns:Loc.CountryRegion/text()', Resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))::varchar
                                                AS "Emp.Loc.CountryRegion"
    ,UNNEST(xpath('/ns:Resume/ns:Employment/ns:Emp.Location/ns:Location/ns:Loc.State/text()', Resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))::varchar
                                                AS "Emp.Loc.State"
    ,UNNEST(xpath('/ns:Resume/ns:Employment/ns:Emp.Location/ns:Location/ns:Loc.City/text()', Resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}'))::varchar
                                                AS "Emp.Loc.City"
  FROM HumanResources.JobCandidate;


-- In this data set, not every listed education has a minor.  (OK, actually NONE of them do!)
-- So instead of using multiple UNNEST as above, which would result in 0 rows returned,
-- we just UNNEST once in a derived table, then convert each XML fragment into a document again
-- with one <root> element and a shorter namespace for ns:, and finally just use xpath on
-- all the created documents.
CREATE VIEW HumanResources.vJobCandidateEducation
AS
SELECT
  jc.JobCandidateID
  ,(xpath('/root/ns:Education/ns:Edu.Level/text()', jc.doc, '{{ns,http://adventureworks.com}}'))[1]::varchar(50)
                             AS "Edu.Level"
  ,CAST((xpath('/root/ns:Education/ns:Edu.StartDate/text()', jc.doc, '{{ns,http://adventureworks.com}}'))[1]::VARCHAR(20) AS DATE)
                             AS "Edu.StartDate"
  ,CAST((xpath('/root/ns:Education/ns:Edu.EndDate/text()', jc.doc, '{{ns,http://adventureworks.com}}'))[1]::VARCHAR(20) AS DATE)
                             AS "Edu.EndDate"
  ,(xpath('/root/ns:Education/ns:Edu.Degree/text()', jc.doc, '{{ns,http://adventureworks.com}}'))[1]::varchar(50)
                             AS "Edu.Degree"
  ,(xpath('/root/ns:Education/ns:Edu.Major/text()', jc.doc, '{{ns,http://adventureworks.com}}'))[1]::varchar(50)
                             AS "Edu.Major"
  ,(xpath('/root/ns:Education/ns:Edu.Minor/text()', jc.doc, '{{ns,http://adventureworks.com}}'))[1]::varchar(50)
                             AS "Edu.Minor"
  ,(xpath('/root/ns:Education/ns:Edu.GPA/text()', jc.doc, '{{ns,http://adventureworks.com}}'))[1]::varchar(5)
                             AS "Edu.GPA"
  ,(xpath('/root/ns:Education/ns:Edu.GPAScale/text()', jc.doc, '{{ns,http://adventureworks.com}}'))[1]::varchar(5)
                             AS "Edu.GPAScale"
  ,(xpath('/root/ns:Education/ns:Edu.School/text()', jc.doc, '{{ns,http://adventureworks.com}}'))[1]::varchar(100)
                             AS "Edu.School"
  ,(xpath('/root/ns:Education/ns:Edu.Location/ns:Location/ns:Loc.CountryRegion/text()', jc.doc, '{{ns,http://adventureworks.com}}'))[1]::varchar(100)
                             AS "Edu.Loc.CountryRegion"
  ,(xpath('/root/ns:Education/ns:Edu.Location/ns:Location/ns:Loc.State/text()', jc.doc, '{{ns,http://adventureworks.com}}'))[1]::varchar(100)
                             AS "Edu.Loc.State"
  ,(xpath('/root/ns:Education/ns:Edu.Location/ns:Location/ns:Loc.City/text()', jc.doc, '{{ns,http://adventureworks.com}}'))[1]::varchar(100)
                             AS "Edu.Loc.City"
FROM (SELECT JobCandidateID
    -- Because the underlying XML data used in this example has namespaces defined at the document level,
    -- when we take individual fragments using UNNEST then each fragment has no idea of the namespaces.
    -- So here each fragment gets turned back into its own document with a root element that defines a
    -- simpler thing for "ns" since this will only be used only in the xpath queries above.
    ,('<root xmlns:ns="http://adventureworks.com">' ||
      unnesting.Education::varchar ||
      '</root>')::xml AS doc
  FROM (SELECT JobCandidateID
      ,UNNEST(xpath('/ns:Resume/ns:Education', Resume, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume}}')) AS Education
    FROM HumanResources.JobCandidate) AS unnesting) AS jc;


-- Products and product descriptions by language.
-- We're making this a materialized view so that performance can be better.
CREATE MATERIALIZED VIEW Production.vProductAndDescription
AS
SELECT
    p.ProductID
    ,p.Name
    ,pm.Name AS ProductModel
    ,pmx.CultureID
    ,pd.Description
FROM Production.Product p
    INNER JOIN Production.ProductModel pm
    ON p.ProductModelID = pm.ProductModelID
    INNER JOIN Production.ProductModelProductDescriptionCulture pmx
    ON pm.ProductModelID = pmx.ProductModelID
    INNER JOIN Production.ProductDescription pd
    ON pmx.ProductDescriptionID = pd.ProductDescriptionID;

-- Index the vProductAndDescription view
CREATE UNIQUE INDEX IX_vProductAndDescription ON Production.vProductAndDescription(CultureID, ProductID);
CLUSTER Production.vProductAndDescription USING IX_vProductAndDescription;
-- Note that with a materialized view, changes to the underlying tables will
-- not change the contents of the view.  In order to maintain the index, if there
-- are changes to any of the 4 tables then you would need to run:
--   REFRESH MATERIALIZED VIEW Production.vProductAndDescription;


CREATE VIEW Production.vProductModelCatalogDescription
AS
SELECT
  ProductModelID
  ,Name
  ,(xpath('/p1:ProductDescription/p1:Summary/html:p/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{html,http://www.w3.org/1999/xhtml}}'))[1]::varchar
                                 AS "Summary"
  ,(xpath('/p1:ProductDescription/p1:Manufacturer/p1:Name/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}' ))[1]::varchar
                                  AS Manufacturer
  ,(xpath('/p1:ProductDescription/p1:Manufacturer/p1:Copyright/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}' ))[1]::varchar(30)
                                                  AS Copyright
  ,(xpath('/p1:ProductDescription/p1:Manufacturer/p1:ProductURL/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}' ))[1]::varchar(256)
                                                  AS ProductURL
  ,(xpath('/p1:ProductDescription/p1:Features/wm:Warranty/wm:WarrantyPeriod/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wm,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain}}' ))[1]::varchar(256)
                                                          AS WarrantyPeriod
  ,(xpath('/p1:ProductDescription/p1:Features/wm:Warranty/wm:Description/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wm,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain}}' ))[1]::varchar(256)
                                                          AS WarrantyDescription
  ,(xpath('/p1:ProductDescription/p1:Features/wm:Maintenance/wm:NoOfYears/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wm,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain}}' ))[1]::varchar(256)
                                                             AS NoOfYears
  ,(xpath('/p1:ProductDescription/p1:Features/wm:Maintenance/wm:Description/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wm,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain}}' ))[1]::varchar(256)
                                                             AS MaintenanceDescription
  ,(xpath('/p1:ProductDescription/p1:Features/wf:wheel/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wf,http://www.adventure-works.com/schemas/OtherFeatures}}'))[1]::varchar(256)
                                              AS Wheel
  ,(xpath('/p1:ProductDescription/p1:Features/wf:saddle/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wf,http://www.adventure-works.com/schemas/OtherFeatures}}'))[1]::varchar(256)
                                              AS Saddle
  ,(xpath('/p1:ProductDescription/p1:Features/wf:pedal/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wf,http://www.adventure-works.com/schemas/OtherFeatures}}'))[1]::varchar(256)
                                              AS Pedal
  ,(xpath('/p1:ProductDescription/p1:Features/wf:BikeFrame/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wf,http://www.adventure-works.com/schemas/OtherFeatures}}'))[1]::varchar
                                              AS BikeFrame
  ,(xpath('/p1:ProductDescription/p1:Features/wf:crankset/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription},{wf,http://www.adventure-works.com/schemas/OtherFeatures}}'))[1]::varchar(256)
                                              AS Crankset
  ,(xpath('/p1:ProductDescription/p1:Picture/p1:Angle/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}' ))[1]::varchar(256)
                                             AS PictureAngle
  ,(xpath('/p1:ProductDescription/p1:Picture/p1:Size/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}' ))[1]::varchar(256)
                                             AS PictureSize
  ,(xpath('/p1:ProductDescription/p1:Picture/p1:ProductPhotoID/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}' ))[1]::varchar(256)
                                             AS ProductPhotoID
  ,(xpath('/p1:ProductDescription/p1:Specifications/Material/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}' ))[1]::varchar(256)
                                                 AS Material
  ,(xpath('/p1:ProductDescription/p1:Specifications/Color/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}' ))[1]::varchar(256)
                                                 AS Color
  ,(xpath('/p1:ProductDescription/p1:Specifications/ProductLine/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}' ))[1]::varchar(256)
                                                 AS ProductLine
  ,(xpath('/p1:ProductDescription/p1:Specifications/Style/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}' ))[1]::varchar(256)
                                                 AS Style
  ,(xpath('/p1:ProductDescription/p1:Specifications/RiderExperience/text()', CatalogDescription, '{{p1,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription}}' ))[1]::varchar(1024)
                                                 AS RiderExperience
  ,rowguid
  ,ModifiedDate
FROM Production.ProductModel
WHERE CatalogDescription IS NOT NULL;


-- Instructions have many locations, and locations have many steps
CREATE VIEW Production.vProductModelInstructions
AS
SELECT
    pm.ProductModelID
    ,pm.Name
    -- Access the overall Instructions xml brought through from %line 2938 and %line 2943
    ,(xpath('/ns:root/text()', pm.Instructions, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions}}'))[1]::varchar AS Instructions
    -- Bring out information about the location, broken out in %line 2945
    ,CAST((xpath('@LocationID', pm.MfgInstructions))[1]::varchar AS INTEGER) AS "LocationID"
    ,CAST((xpath('@SetupHours', pm.MfgInstructions))[1]::varchar AS DECIMAL(9, 4)) AS "SetupHours"
    ,CAST((xpath('@MachineHours', pm.MfgInstructions))[1]::varchar AS DECIMAL(9, 4)) AS "MachineHours"
    ,CAST((xpath('@LaborHours', pm.MfgInstructions))[1]::varchar AS DECIMAL(9, 4)) AS "LaborHours"
    ,CAST((xpath('@LotSize', pm.MfgInstructions))[1]::varchar AS INTEGER) AS "LotSize"
    -- Show specific detail about each step broken out in %line 2940
    ,(xpath('/step/text()', pm.Step))[1]::varchar(1024) AS "Step"
    ,pm.rowguid
    ,pm.ModifiedDate
FROM (SELECT locations.ProductModelID, locations.Name, locations.rowguid, locations.ModifiedDate
    ,locations.Instructions, locations.MfgInstructions
    -- Further break out the location information from the inner query below into individual steps
    ,UNNEST(xpath('step', locations.MfgInstructions)) AS Step
  FROM (SELECT
      -- Just pass these through so they can be referenced at the outermost query
      ProductModelID, Name, rowguid, ModifiedDate, Instructions
      -- And also break out Instructions into individual locations to pass up to the middle query
      ,UNNEST(xpath('/ns:root/ns:Location', Instructions, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions}}')) AS MfgInstructions
    FROM Production.ProductModel) AS locations) AS pm;


CREATE VIEW Sales.vSalesPerson
AS
SELECT
    s.BusinessEntityID
    ,p.Title
    ,p.FirstName
    ,p.MiddleName
    ,p.LastName
    ,p.Suffix
    ,e.JobTitle
    ,pp.PhoneNumber
    ,pnt.Name AS PhoneNumberType
    ,ea.EmailAddress
    ,p.EmailPromotion
    ,a.AddressLine1
    ,a.AddressLine2
    ,a.City
    ,sp.Name AS StateProvinceName
    ,a.PostalCode
    ,cr.Name AS CountryRegionName
    ,st.Name AS TerritoryName
    ,st.Group AS TerritoryGroup
    ,s.SalesQuota
    ,s.SalesYTD
    ,s.SalesLastYear
FROM Sales.SalesPerson s
  INNER JOIN HumanResources.Employee e
    ON e.BusinessEntityID = s.BusinessEntityID
  INNER JOIN Person.Person p
    ON p.BusinessEntityID = s.BusinessEntityID
  INNER JOIN Person.BusinessEntityAddress bea
    ON bea.BusinessEntityID = s.BusinessEntityID
  INNER JOIN Person.Address a
    ON a.AddressID = bea.AddressID
  INNER JOIN Person.StateProvince sp
    ON sp.StateProvinceID = a.StateProvinceID
  INNER JOIN Person.CountryRegion cr
    ON cr.CountryRegionCode = sp.CountryRegionCode
  LEFT OUTER JOIN Sales.SalesTerritory st
    ON st.TerritoryID = s.TerritoryID
  LEFT OUTER JOIN Person.EmailAddress ea
    ON ea.BusinessEntityID = p.BusinessEntityID
  LEFT OUTER JOIN Person.PersonPhone pp
    ON pp.BusinessEntityID = p.BusinessEntityID
  LEFT OUTER JOIN Person.PhoneNumberType pnt
    ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID;


-- This view provides the aggregated data that gets used in the PIVOTed view below
CREATE VIEW Sales.vSalesPersonSalesByFiscalYearsData
AS
-- Of the 56 possible combinations of one of the 14 SalesPersons selling across one of
-- 4 FiscalYears, here we end up with 48 rows of aggregated data (since some sales people
-- were hired and started working in FY2012 or FY2013).
SELECT granular.SalesPersonID, granular.FullName, granular.JobTitle, granular.SalesTerritory, SUM(granular.SubTotal) AS SalesTotal, granular.FiscalYear
FROM
-- Brings back 3703 rows of data -- there are 3806 total sales done by a SalesPerson,
-- of which 103 do not have any sales territory.  This is fed into the outer GROUP BY
-- which results in 48 aggregated rows of sales data.
  (SELECT
      soh.SalesPersonID
      ,p.FirstName || ' ' || COALESCE(p.MiddleName || ' ', '') || p.LastName AS FullName
      ,e.JobTitle
      ,st.Name AS SalesTerritory
      ,soh.SubTotal
      ,EXTRACT(YEAR FROM soh.OrderDate + '6 months'::interval) AS FiscalYear
  FROM Sales.SalesPerson sp
    INNER JOIN Sales.SalesOrderHeader soh
      ON sp.BusinessEntityID = soh.SalesPersonID
    INNER JOIN Sales.SalesTerritory st
      ON sp.TerritoryID = st.TerritoryID
    INNER JOIN HumanResources.Employee e
      ON soh.SalesPersonID = e.BusinessEntityID
    INNER JOIN Person.Person p
      ON p.BusinessEntityID = sp.BusinessEntityID
  ) AS granular
GROUP BY granular.SalesPersonID, granular.FullName, granular.JobTitle, granular.SalesTerritory, granular.FiscalYear;

-- Note that this PIVOT query originally refered to years 2002-2004, which jived with
-- earlier versions of the AdventureWorks data.  Somewhere along the way all the dates
-- were cranked forward by exactly a decade, but this view wasn't updated, effectively
-- breaking it.  The hard-coded fiscal years below fix this issue.

-- Current sales data ranges from May 31, 2011 through June 30, 2014, so there's one
-- month of fiscal year 2011 data, but mostly FY 2012 through 2014.

-- This query properly shows no data for three of our sales people in 2012,
-- as they were hired during FY 2013.
CREATE VIEW Sales.vSalesPersonSalesByFiscalYears
AS
SELECT * FROM crosstab(
'SELECT
    SalesPersonID
    ,FullName
    ,JobTitle
    ,SalesTerritory
    ,FiscalYear
    ,SalesTotal
FROM Sales.vSalesPersonSalesByFiscalYearsData
ORDER BY 2,4'
-- This set of fiscal years could have dynamically come from a SELECT DISTINCT,
-- but we wanted to omit 2011 and also ...
,$$SELECT unnest('{2012,2013,2014}'::text[])$$)
-- ... still the FiscalYear values have to be hard-coded here.
AS SalesTotal ("SalesPersonID" integer, "FullName" text, "JobTitle" text, "SalesTerritory" text,
 "2012" DECIMAL(12, 4), "2013" DECIMAL(12, 4), "2014" DECIMAL(12, 4));


CREATE MATERIALIZED VIEW Person.vStateProvinceCountryRegion
AS
SELECT
    sp.StateProvinceID
    ,sp.StateProvinceCode
    ,sp.IsOnlyStateProvinceFlag
    ,sp.Name AS StateProvinceName
    ,sp.TerritoryID
    ,cr.CountryRegionCode
    ,cr.Name AS CountryRegionName
FROM Person.StateProvince sp
    INNER JOIN Person.CountryRegion cr
    ON sp.CountryRegionCode = cr.CountryRegionCode;

CREATE UNIQUE INDEX IX_vStateProvinceCountryRegion ON Person.vStateProvinceCountryRegion(StateProvinceID, CountryRegionCode);
CLUSTER Person.vStateProvinceCountryRegion USING IX_vStateProvinceCountryRegion;
-- If there are changes to either of these tables, this should be run to update the view:
--   REFRESH MATERIALIZED VIEW Production.vStateProvinceCountryRegion;


CREATE VIEW Sales.vStoreWithDemographics
AS
SELECT
    BusinessEntityID
    ,Name
    ,CAST(UNNEST(xpath('/ns:StoreSurvey/ns:AnnualSales/text()', Demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'))::varchar AS money)
                                       AS "AnnualSales"
    ,CAST(UNNEST(xpath('/ns:StoreSurvey/ns:AnnualRevenue/text()', Demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'))::varchar AS money)
                                       AS "AnnualRevenue"
    ,UNNEST(xpath('/ns:StoreSurvey/ns:BankName/text()', Demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'))::varchar(50)
                                  AS "BankName"
    ,UNNEST(xpath('/ns:StoreSurvey/ns:BusinessType/text()', Demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'))::varchar(5)
                                  AS "BusinessType"
    ,CAST(UNNEST(xpath('/ns:StoreSurvey/ns:YearOpened/text()', Demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'))::varchar AS integer)
                                       AS "YearOpened"
    ,UNNEST(xpath('/ns:StoreSurvey/ns:Specialty/text()', Demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'))::varchar(50)
                                  AS "Specialty"
    ,CAST(UNNEST(xpath('/ns:StoreSurvey/ns:SquareFeet/text()', Demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'))::varchar AS integer)
                                       AS "SquareFeet"
    ,UNNEST(xpath('/ns:StoreSurvey/ns:Brands/text()', Demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'))::varchar(30)
                                  AS "Brands"
    ,UNNEST(xpath('/ns:StoreSurvey/ns:Internet/text()', Demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'))::varchar(30)
                                  AS "Internet"
    ,CAST(UNNEST(xpath('/ns:StoreSurvey/ns:NumberEmployees/text()', Demographics, '{{ns,http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey}}'))::varchar AS integer)
                                       AS "NumberEmployees"
FROM Sales.Store;


CREATE VIEW Sales.vStoreWithContacts
AS
SELECT
    s.BusinessEntityID
    ,s.Name
    ,ct.Name AS ContactType
    ,p.Title
    ,p.FirstName
    ,p.MiddleName
    ,p.LastName
    ,p.Suffix
    ,pp.PhoneNumber
    ,pnt.Name AS PhoneNumberType
    ,ea.EmailAddress
    ,p.EmailPromotion
FROM Sales.Store s
  INNER JOIN Person.BusinessEntityContact bec
    ON bec.BusinessEntityID = s.BusinessEntityID
  INNER JOIN Person.ContactType ct
    ON ct.ContactTypeID = bec.ContactTypeID
  INNER JOIN Person.Person p
    ON p.BusinessEntityID = bec.PersonID
  LEFT OUTER JOIN Person.EmailAddress ea
    ON ea.BusinessEntityID = p.BusinessEntityID
  LEFT OUTER JOIN Person.PersonPhone pp
    ON pp.BusinessEntityID = p.BusinessEntityID
  LEFT OUTER JOIN Person.PhoneNumberType pnt
    ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID;


CREATE VIEW Sales.vStoreWithAddresses
AS
SELECT
    s.BusinessEntityID
    ,s.Name
    ,at.Name AS AddressType
    ,a.AddressLine1
    ,a.AddressLine2
    ,a.City
    ,sp.Name AS StateProvinceName
    ,a.PostalCode
    ,cr.Name AS CountryRegionName
FROM Sales.Store s
  INNER JOIN Person.BusinessEntityAddress bea
    ON bea.BusinessEntityID = s.BusinessEntityID
  INNER JOIN Person.Address a
    ON a.AddressID = bea.AddressID
  INNER JOIN Person.StateProvince sp
    ON sp.StateProvinceID = a.StateProvinceID
  INNER JOIN Person.CountryRegion cr
    ON cr.CountryRegionCode = sp.CountryRegionCode
  INNER JOIN Person.AddressType at
    ON at.AddressTypeID = bea.AddressTypeID;


CREATE VIEW Purchasing.vVendorWithContacts
AS
SELECT
    v.BusinessEntityID
    ,v.Name
    ,ct.Name AS ContactType
    ,p.Title
    ,p.FirstName
    ,p.MiddleName
    ,p.LastName
    ,p.Suffix
    ,pp.PhoneNumber
    ,pnt.Name AS PhoneNumberType
    ,ea.EmailAddress
    ,p.EmailPromotion
FROM Purchasing.Vendor v
  INNER JOIN Person.BusinessEntityContact bec
    ON bec.BusinessEntityID = v.BusinessEntityID
  INNER JOIN Person.ContactType ct
    ON ct.ContactTypeID = bec.ContactTypeID
  INNER JOIN Person.Person p
    ON p.BusinessEntityID = bec.PersonID
  LEFT OUTER JOIN Person.EmailAddress ea
    ON ea.BusinessEntityID = p.BusinessEntityID
  LEFT OUTER JOIN Person.PersonPhone pp
    ON pp.BusinessEntityID = p.BusinessEntityID
  LEFT OUTER JOIN Person.PhoneNumberType pnt
    ON pnt.PhoneNumberTypeID = pp.PhoneNumberTypeID;


CREATE VIEW Purchasing.vVendorWithAddresses
AS
SELECT
    v.BusinessEntityID
    ,v.Name
    ,at.Name AS AddressType
    ,a.AddressLine1
    ,a.AddressLine2
    ,a.City
    ,sp.Name AS StateProvinceName
    ,a.PostalCode
    ,cr.Name AS CountryRegionName
FROM Purchasing.Vendor v
  INNER JOIN Person.BusinessEntityAddress bea
    ON bea.BusinessEntityID = v.BusinessEntityID
  INNER JOIN Person.Address a
    ON a.AddressID = bea.AddressID
  INNER JOIN Person.StateProvince sp
    ON sp.StateProvinceID = a.StateProvinceID
  INNER JOIN Person.CountryRegion cr
    ON cr.CountryRegionCode = sp.CountryRegionCode
  INNER JOIN Person.AddressType at
    ON at.AddressTypeID = bea.AddressTypeID;


-- Convenience views
/*
CREATE SCHEMA pe
  CREATE VIEW a AS SELECT addressid AS id, * FROM person.address
  CREATE VIEW at AS SELECT addresstypeid AS id, * FROM person.addresstype
  CREATE VIEW be AS SELECT businessentityid AS id, * FROM person.businessentity
  CREATE VIEW bea AS SELECT businessentityid AS id, * FROM person.businessentityaddress
  CREATE VIEW bec AS SELECT businessentityid AS id, * FROM person.businessentitycontact
  CREATE VIEW ct AS SELECT contacttypeid AS id, * FROM person.contacttype
  CREATE VIEW cr AS SELECT * FROM person.countryregion
  CREATE VIEW e AS SELECT emailaddressid AS id, * FROM person.emailaddress
  CREATE VIEW pa AS SELECT businessentityid AS id, * FROM person.password
  CREATE VIEW p AS SELECT businessentityid AS id, * FROM person.person
  CREATE VIEW pp AS SELECT businessentityid AS id, * FROM person.personphone
  CREATE VIEW pnt AS SELECT phonenumbertypeid AS id, * FROM person.phonenumbertype
  CREATE VIEW sp AS SELECT stateprovinceid AS id, * FROM person.stateprovince
;
CREATE SCHEMA hr
  CREATE VIEW d AS SELECT departmentid AS id, * FROM humanresources.department
  CREATE VIEW e AS SELECT businessentityid AS id, * FROM humanresources.employee
  CREATE VIEW edh AS SELECT businessentityid AS id, * FROM humanresources.employeedepartmenthistory
  CREATE VIEW eph AS SELECT businessentityid AS id, * FROM humanresources.employeepayhistory
  CREATE VIEW jc AS SELECT jobcandidateid AS id, * FROM humanresources.jobcandidate
  CREATE VIEW s AS SELECT shiftid AS id, * FROM humanresources.shift
;
CREATE SCHEMA pr
  CREATE VIEW bom AS SELECT billofmaterialsid AS id, * FROM production.billofmaterials
  CREATE VIEW c AS SELECT cultureid AS id, * FROM production.culture
  CREATE VIEW d AS SELECT * FROM production.document
  CREATE VIEW i AS SELECT illustrationid AS id, * FROM production.illustration
  CREATE VIEW l AS SELECT locationid AS id, * FROM production.location
  CREATE VIEW p AS SELECT productid AS id, * FROM production.product
  CREATE VIEW pc AS SELECT productcategoryid AS id, * FROM production.productcategory
  CREATE VIEW pch AS SELECT productid AS id, * FROM production.productcosthistory
  CREATE VIEW pd AS SELECT productdescriptionid AS id, * FROM production.productdescription
  CREATE VIEW pdoc AS SELECT productid AS id, * FROM production.productdocument
  CREATE VIEW pi AS SELECT productid AS id, * FROM production.productinventory
  CREATE VIEW plph AS SELECT productid AS id, * FROM production.productlistpricehistory
  CREATE VIEW pm AS SELECT productmodelid AS id, * FROM production.productmodel
  CREATE VIEW pmi AS SELECT * FROM production.productmodelillustration
  CREATE VIEW pmpdc AS SELECT * FROM production.productmodelproductdescriptionculture
  CREATE VIEW pp AS SELECT productphotoid AS id, * FROM production.productphoto
  CREATE VIEW ppp AS SELECT * FROM production.productproductphoto
  CREATE VIEW pr AS SELECT productreviewid AS id, * FROM production.productreview
  CREATE VIEW psc AS SELECT productsubcategoryid AS id, * FROM production.productsubcategory
  CREATE VIEW sr AS SELECT scrapreasonid AS id, * FROM production.scrapreason
  CREATE VIEW th AS SELECT transactionid AS id, * FROM production.transactionhistory
  CREATE VIEW tha AS SELECT transactionid AS id, * FROM production.transactionhistoryarchive
  CREATE VIEW um AS SELECT unitmeasurecode AS id, * FROM production.unitmeasure
  CREATE VIEW w AS SELECT workorderid AS id, * FROM production.workorder
  CREATE VIEW wr AS SELECT workorderid AS id, * FROM production.workorderrouting
;
CREATE SCHEMA pu
  CREATE VIEW pv AS SELECT productid AS id, * FROM purchasing.productvendor
  CREATE VIEW pod AS SELECT purchaseorderdetailid AS id, * FROM purchasing.purchaseorderdetail
  CREATE VIEW poh AS SELECT purchaseorderid AS id, * FROM purchasing.purchaseorderheader
  CREATE VIEW sm AS SELECT shipmethodid AS id, * FROM purchasing.shipmethod
  CREATE VIEW v AS SELECT businessentityid AS id, * FROM purchasing.vendor
;
CREATE SCHEMA sa
  CREATE VIEW crc AS SELECT * FROM sales.countryregioncurrency
  CREATE VIEW cc AS SELECT creditcardid AS id, * FROM sales.creditcard
  CREATE VIEW cu AS SELECT currencycode AS id, * FROM sales.currency
  CREATE VIEW cr AS SELECT * FROM sales.currencyrate
  CREATE VIEW c AS SELECT customerid AS id, * FROM sales.customer
  CREATE VIEW pcc AS SELECT businessentityid AS id, * FROM sales.personcreditcard
  CREATE VIEW sod AS SELECT salesorderdetailid AS id, * FROM sales.salesorderdetail
  CREATE VIEW soh AS SELECT salesorderid AS id, * FROM sales.salesorderheader
  CREATE VIEW sohsr AS SELECT * FROM sales.salesorderheadersalesreason
  CREATE VIEW sp AS SELECT businessentityid AS id, * FROM sales.salesperson
  CREATE VIEW spqh AS SELECT businessentityid AS id, * FROM sales.salespersonquotahistory
  CREATE VIEW sr AS SELECT salesreasonid AS id, * FROM sales.salesreason
  CREATE VIEW tr AS SELECT salestaxrateid AS id, * FROM sales.salestaxrate
  CREATE VIEW st AS SELECT territoryid AS id, * FROM sales.salesterritory
  CREATE VIEW sth AS SELECT territoryid AS id, * FROM sales.salesterritoryhistory
  CREATE VIEW sci AS SELECT shoppingcartitemid AS id, * FROM sales.shoppingcartitem
  CREATE VIEW so AS SELECT specialofferid AS id, * FROM sales.specialoffer
  CREATE VIEW sop AS SELECT specialofferid AS id, * FROM sales.specialofferproduct
  CREATE VIEW s AS SELECT businessentityid AS id, * FROM sales.store
;*/