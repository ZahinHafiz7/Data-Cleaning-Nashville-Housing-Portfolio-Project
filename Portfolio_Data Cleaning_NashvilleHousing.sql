SELECT *
FROM PortfolioProject..NashvilleHousing

--Standardize date format
--set date in proper format 1, use CONVERT, 2. ALTER, UPDATE, and RUN 
SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--Populate Property Address Data
SELECT *
FROM PortfolioProject..NashvilleHousing
ORDER BY ParcelID
--merge duplicate info / populate same parcel ID with address or no address
--ISNULL use to detect NULL info and replace with b.property
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID --same parcelID
	AND a.[UniqueID ]<> b.[UniqueID ] -- different unique ID
WHERE a.PropertyAddress is null -- set A address become null
-- after do this, then we can update all data

--Breaking out address into individual column(Adress, City, State) (hard version)
SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing
ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM PortfolioProject..NashvilleHousing
--put in main table
ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);
UPDATE NashvilleHousing
SET PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))
SELECT *
FROM PortfolioProject..NashvilleHousing

-- owneraddress (easy version)
SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3) Address
, PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2) City
, PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1) State
FROM PortfolioProject..NashvilleHousing
--put in main table
ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)
ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)
ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)
SELECT *
FROM PortfolioProject..NashvilleHousing

--Change Y and N to Yes and No in 'Sold as Vacant' field
-- see how many N and Y
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY  SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'y' THEN 'Yes'
	   WHEN SoldAsVacant = 'n' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'y' THEN 'Yes'
	   WHEN SoldAsVacant = 'n' THEN 'No'
	   ELSE SoldAsVacant
	   END

--Remove Duplicate
-- find duplicate (if there any row_num=2, means the data is duplicate)
SELECT *,
	ROW_NUMBER()OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					)row_num
FROM PortfolioProject..NashvilleHousing
ORDER BY ParcelID
-- want to filter to get all row_num2 
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER()OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					)row_num
FROM PortfolioProject..NashvilleHousing
)
SELECT*
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress
-- after fill all duplicate, delete it
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER()OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					)row_num
FROM PortfolioProject..NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
-- then select all back, all duplicate is gone
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER()OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					)row_num
FROM PortfolioProject..NashvilleHousing
)
SELECT*
FROM RowNumCTE
WHERE row_num > 1

--Delete unused column
SELECT*
FROM PortfolioProject..NashvilleHousing
-- run this first, then run back SELECT*
ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress
ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate