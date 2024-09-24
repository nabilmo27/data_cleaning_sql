/*

Cleaning Data in SQL Queries

*/

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDate, CONVERT(date,SaleDate) as converted_date
from [Nashville Housing ]



alter table [Nashville Housing ]
add  converteddate date

update [Nashville Housing ]
set converteddate = CONVERT(date,SaleDate)


select * from [Nashville Housing ]
-------------------populate property address data ------------------------
select a1.ParcelID ,a1.PropertyAddress,a2.PropertyAddress,ISNULL(a1.PropertyAddress,a2.PropertyAddress) from
[Nashville Housing ]  a1
 join [Nashville Housing ]  a2
on a1.ParcelID=a2.ParcelID
where a1.PropertyAddress is null and a2.PropertyAddress is not null
order by a1.ParcelID

update a1
set a1.PropertyAddress = ISNULL(a1.PropertyAddress,a2.PropertyAddress) from
[Nashville Housing ]  a1
 join [Nashville Housing ]  a2
on a1.ParcelID=a2.ParcelID
where a1.PropertyAddress is null and a2.PropertyAddress is not null
-----------------------Breaking out Address into Individual Columns (Address, City, State)--------------------------------------------------------------------------------
select PropertyAddress ,SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)  as adress,
RIGHT(PropertyAddress,LEN(PropertyAddress)-CHARindex(',',PropertyAddress))
--,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,20)
from [Nashville Housing ]

alter table  [Nashville Housing ]
add address  nvarchar(50)

update [Nashville Housing ]
set address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

alter table  [Nashville Housing ]
add city  nvarchar(50)

update [Nashville Housing ]
set city = RIGHT(PropertyAddress,LEN(PropertyAddress)-CHARindex(',',PropertyAddress))

select * from [Nashville Housing ]

----------------------------------------------
select PARSENAME(replace(OwnerAddress,',','.'),3) owneraddress
,PARSENAME(replace(OwnerAddress,',','.'),2) ownercity
,PARSENAME(replace(OwnerAddress,',','.'),1) ownerstate
from [Nashville Housing ]

alter table  [Nashville Housing ]
add ownersplitaddress nvarchar(50)

update [Nashville Housing ]
set ownersplitaddress =PARSENAME(replace(OwnerAddress,',','.'),3)

alter table  [Nashville Housing ]
add ownersplitcity nvarchar(50)

update [Nashville Housing ]
set ownersplitcity =PARSENAME(replace(OwnerAddress,',','.'),2)


alter table  [Nashville Housing ]
add ownersplitstate nvarchar(50)

update [Nashville Housing ]
set ownersplitstate =PARSENAME(replace(OwnerAddress,',','.'),1)

select * from  [Nashville Housing ]

------------------------------ Change Y and N to Yes and No in "Sold as Vacant" field------------------------------------------------------
select 
REPLACE(SoldAsVacant,1,'yes')
,REPLACE(SoldAsVacant,0,'no')
from [Nashville Housing ];


update [Nashville Housing ]
set SoldAsVacant=REPLACE(SoldAsVacant,1,'yes')


update [Nashville Housing ]
set SoldAsVacant=REPLACE(SoldAsVacant,0,'no')

select  SoldAsVacant
from [Nashville Housing ]
-----------------------------------------delete duplcates-----------------------------------------------
with CTE as (
select *
, ROW_NUMBER() over(partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference
order by UniqueID )as rownum
from  [Nashville Housing ]
)
DELETE FROM CTE
WHERE rownum > 1;
-----------------------------------------delete unusedcoulmns-----------------------------------------------------
select* from [Nashville Housing ]

alter table [Nashville Housing ]
drop column	OwnerAddress,TaxDistrict,salesdate

alter table [Nashville Housing ]
drop column	PropertyAddress