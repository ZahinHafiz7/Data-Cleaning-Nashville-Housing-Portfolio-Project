# Data-Cleaning-Nashville-Housing-Portfolio-Project
This is my simple portfolio project of data cleaning of Nashville Housing using SQL 
This SQL project focuses on cleaning and standardizing housing data from the Nashville dataset. Here's a summary of the steps taken:

1. Standardizing date formats by converting SaleDate to the proper format.
2. Populating missing property addresses by merging duplicate information and filling in null addresses.
3. Breaking down addresses into separate columns (Address, City, State) for easier analysis.
4. Parsing owner addresses into separate columns (Address, City, State).
5. Updating 'Sold as Vacant' values to display 'Yes' or 'No' instead of 'Y' and 'N'.
6. Removing duplicate entries based on specific criteria like ParcelID, PropertyAddress, SalePrice, SaleDate, and LegalReference.
7. Deleting unused columns like OwnerAddress, TaxDistrict, PropertyAddress, and SaleDate for a cleaner dataset.

Overall, this project aims to enhance the Nashville housing dataset by standardizing dates, filling in missing addresses, parsing addresses and owner information, updating field values, and removing duplicate and unnecessary columns.
