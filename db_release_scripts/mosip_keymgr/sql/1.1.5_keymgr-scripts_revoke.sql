-- -------------------------------------------------------------------------------------------------
-- Database Name	: mosip_keymgr
-- Release Version 	: 1.1.5.5
-- Purpose    		: Revoking Database Alter deployement done for release in Key manager DB.       
-- Create By   		: Chandra Keshav Mishra
-- Created Date		: APRIL-2022
-- 
-- Modified Date        Modified By         Comments / Remarks
-- -------------------------------------------------------------------------------------------------

\c mosip_kernel sysadmin

ALTER TABLE keymgr.key_alias DROP COLUMN IF EXISTS cert_thumbprint;

-----------------------------------------------------------------------------------------------------
