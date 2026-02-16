CREATE VIEW [config].[ICE_AuditTablesToIgnore]
AS select 'ice_attributenote'		as TableName union all
select 'uag_customerinteraction'			 union all 	
select 'account'							 union all
select 'email'								 union all
select 'dwp_job'							 union all
select 'ice_customercommunicationnote'		 union all
select 'systemuser'							 union all
select 'ice_facility'						 union all
select 'uag_productsdiscussed'				 union all
select 'ice_adviceqa'						 union all
select 'uag_customerimportantnote'			 union all
select 'ice_addressdetail'					 union all
select 'ice_cssecurityowner'				 union all
select 'ice_idgenerator'					 union all
select 'ice_riskgradeassessmentquestion'	 union all
select 'uag_customercontactconsent'			 union all
select 'ice_managedaccount'					 union all
select 'icow_slrmonitoringaction'			 union all
select 'ice_csrolesecurity'					 union all
select 'tpc_extracteddocuments'				 union all
select 'flowevent'							 union all
select 'ice_securityrole'					 union all
select 'kws_kiwisavercorrespondence'		 union all
select 'cls_applicantinformation'			 union all
select 'ice_crowndbcharges'					 union all
select 'ice_azurefunctiontrigger'			 union all
select 'ice_csallocation'					 union all
select 'icow_callreason'					 union all
select 'icow_corro'							 union all
select 'ice_valueaddedconversation'			 union all
select 'ice_security'						 union all
select 'icow_deceasedestate'				 union all
select 'tpc_mortgageadviser'				 union all
select 'tpc_documentautomationstages'		 union all
select 'ice_crowndbflows';
GO

