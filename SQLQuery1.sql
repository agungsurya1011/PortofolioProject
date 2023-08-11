select * 
from Portofolio2..NaswiillHousting

--konvert date
select SaleDate, CONVERT(date,SaleDate) Tanggal_penjualan
from Portofolio2..NaswiillHousting

alter table Portofolio2..NaswiillHousting
add SaledateConverted date;

update Portofolio2..NaswiillHousting
set SaledateConverted = CONVERT(date,SaleDate)

select * 
from Portofolio2..NaswiillHousting

---populasi properti adress

select *
from Portofolio2..NaswiillHousting
--where PropertyAddress is not null
order by ParcelID

select *
from Portofolio2..Sheet1$_xlnm#_FilterDatabase as b
JOIN Portofolio2..NaswiillHousting as a
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portofolio2..Sheet1$_xlnm#_FilterDatabase as b
JOIN Portofolio2..NaswiillHousting as a
on a.ParcelID = b.ParcelID
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portofolio2..Sheet1$_xlnm#_FilterDatabase as b
JOIN Portofolio2..NaswiillHousting as a
on a.ParcelID = b.ParcelID
where a.PropertyAddress is null



---Breaking out address
select *
from Portofolio2..NaswiillHousting
--where PropertyAddress is not null
--order by ParcelID


select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
from Portofolio2..NaswiillHousting

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
from Portofolio2..NaswiillHousting


alter table Portofolio2..NaswiillHousting
add PropertySplitAddress Nvarchar(255);

update Portofolio2..NaswiillHousting
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

alter table Portofolio2..NaswiillHousting
add PropertySplitCity Nvarchar(255);

update Portofolio2..NaswiillHousting
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

select *
from Portofolio2..NaswiillHousting


select OwnerAddress
from Portofolio2..NaswiillHousting

select OwnerAddress,
PARSENAME (replace (OwnerAddress, ',','.'),3),
PARSENAME (replace (OwnerAddress, ',','.'),2),
PARSENAME (replace (OwnerAddress, ',','.'),1)
from Portofolio2..NaswiillHousting

alter table Portofolio2..NaswiillHousting
add OwnerSplitaddress Nvarchar(255);

update Portofolio2..NaswiillHousting
set OwnerSplitaddress = PARSENAME (replace (OwnerAddress, ',','.'),3)

alter table Portofolio2..NaswiillHousting
add OwnerSplitCity Nvarchar(255);

update Portofolio2..NaswiillHousting
set OwnerSplitCity = PARSENAME (replace (OwnerAddress, ',','.'),2)

alter table Portofolio2..NaswiillHousting
add OwnerSplitState Nvarchar(255);

update Portofolio2..NaswiillHousting
set OwnerSplitState = PARSENAME (replace (OwnerAddress, ',','.'),1)


select *
from Portofolio2..NaswiillHousting


--Merubah Y dan N ke yes dan no

select distinct SoldAsVacant, count (SoldAsVacant)
from Portofolio2..NaswiillHousting
group by SoldAsVacant

select SoldAsVacant, 
case when SoldAsVacant= 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from Portofolio2..NaswiillHousting
group by SoldAsVacant


update Portofolio2..NaswiillHousting
set SoldAsVacant = case when SoldAsVacant= 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
	 WHERE SoldAsVacant IN ('Y', 'N')

	 select distinct SoldAsVacant, count (SoldAsVacant)
from Portofolio2..NaswiillHousting
group by SoldAsVacant


--remove duplicate

select *
from Portofolio2..NaswiillHousting

with
RownumCTE as (
select *,
	ROW_NUMBER() over (
	PARTITION by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference 
	order by UniqueID) row_num
from Portofolio2..NaswiillHousting )

select *
from RownumCTE
where row_num > 1


--delete unsude column

select *
from Portofolio2..NaswiillHousting

alter table Portofolio2..NaswiillHousting
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table Portofolio2..NaswiillHousting
drop column SaleDate