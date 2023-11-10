select*
from PortfolioProject2.dbo.NashvilleHousing


--Standardize Date Format

Select SaleDateConverted, Convert(Date,SaleDate)
From PortfolioProject2.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)

Alter Table NashvilleHousing
Add SaledateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)


--Populate Property Address Data

Select PropertyAddress
From PortfolioProject2.dbo.NashvilleHousing
where PropertyAddress is null

Select *
From PortfolioProject2.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select *
From PortfolioProject2.dbo.NashvilleHousing a
Join PortfolioProject2.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortfolioProject2.dbo.NashvilleHousing a
Join PortfolioProject2.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject2.dbo.NashvilleHousing a
Join PortfolioProject2.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
Set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject2.dbo.NashvilleHousing a
Join PortfolioProject2.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject2.dbo.NashvilleHousing
--where PropertyAddress is null
--Order by ParcelID


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address,
CHARINDEX(',', PropertyAddress)

from PortfolioProject2.dbo.NashvilleHousing


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
CHARINDEX(',', PropertyAddress)

from PortfolioProject2.dbo.NashvilleHousing


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

from PortfolioProject2.dbo.NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress) -1 )

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress) -1 )

select OwnerAddress
from PortfolioProject2.dbo.NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress, ',', ',') , 1)
,PARSENAME(REPLACE(OwnerAddress, ',', ',') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', ',') , 3)
from PortfolioProject2.dbo.NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', ',') , 1)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', ',') , 2)



--Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject2.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject2.dbo.NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  End

--REMOVE DUPLICATES

SELECT *,
	ROW_NUMBER() OVER ( 
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference 
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject2.dbo.NashvilleHousing
Order by ParcelID



WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER ( 
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference 
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject2.dbo.NashvilleHousing
--Order by ParcelID
)
SELECT *
FROM RowNumCTE


--DELETE UNUSED COLUMN

Select*
From PortfolioProject2.dbo.NashvilleHousing


ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
DROP COLUMN SaleDate