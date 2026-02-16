
aue-wn-adp-tco-adf-dev

EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'dl-DeploymentSpn-test';
GO



create user from external provider [aue-wn-adp-tco-adf-prod]

CREATE USER [aue-wn-adp-tco-adf-prod] FROM EXTERNAL PROVIDER;

EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'aue-wn-adp-tco-adf-prod';
