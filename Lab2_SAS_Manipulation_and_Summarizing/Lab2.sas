libname npi "~/my_shared_file_links/u5338439";
proc contents data=npi.cms_providers_la;
run;

*1;
data cms_payment;
 set npi.cms_providers_la;
 keep npi total_drug_unique_benes total_drug_medicare_payment_amt;
run;

data cms_allowed;
 set npi.cms_providers_la;
 keep npi total_drug_unique_benes total_drug_medicare_allowed_amt;
run;

data cms_submitted;
 set npi.cms_providers_la;
 keep npi total_drug_unique_benes total_drug_submitted_chrg_amt;
run;

data cms_append;
 set cms_submitted (in=in_sub rename=(total_drug_submitted_chrg_amt = amount))
     cms_allowed (in=in_allow rename=(total_drug_medicare_allowed_amt = amount))
     cms_payment (in=in_pay rename=(total_drug_medicare_payment_amt = amount));
 if in_sub then amount_type = "Drug Medicare Submitted Amount";
 else if in_allow then amount_type = "Drug Medicare Allowed Amount"; 
 else if in_pay then amount_type = "Drug Medicare Payment Amount";
run;

proc sgplot data=cms_append;
   title1 "Association of Total Charges/Payments and Number of Medicare Beneficiaries With Drug Services"; 
   title2 "Best-Fit Line";
   label amount_type = "Amount Type";
   reg y=amount x=total_drug_unique_benes / group=amount_type nomarkers; 
   xaxis label="Number of Drug Medicare Beneficiaries";
   yaxis label="Total Amount";
   format amount dollar15.;
run;

*2;
data adj_percent;
set npi.cms_providers_la;
beneficiary_cc_depr_percent=beneficiary_cc_depr_percent/100;
beneficiary_cc_diab_percent=beneficiary_cc_diab_percent/100;
beneficiary_cc_hypert_percent=beneficiary_cc_hypert_percent/100;
beneficiary_cc_strk_percent=beneficiary_cc_strk_percent/100;
beneficiary_cc_ost_percent=beneficiary_cc_ost_percent/100;
run;

proc transpose
 data=adj_percent
 out=cms_long (rename=(Col1=percent _label_=disease_type))
 name=att;
 by npi beneficiary_average_age;
 var beneficiary_cc_depr_percent
 	 beneficiary_cc_diab_percent 
 	 beneficiary_cc_hypert_percent
 	 beneficiary_cc_strk_percent
 	 beneficiary_cc_ost_percent;
run;

proc sgplot data=cms_long;
   title1 "Association of Age and Disease"; 
   title2 "Best-Fit Line";
   label disease_type = "Disease Type";
   reg y=percent x=beneficiary_average_age / group=disease_type nomarkers; 
   xaxis label="Average Age";
   yaxis label="Disease Percent";
   format percent percent10.3;
run;

*3;
data family_practice;
set npi.cms_providers_la;
if provider_type = "Family Practice";
run;

data family_practice_total (keep=total_number);
  set family_practice end=last;
  total_number+total_services;
  if last then output;
run;

data pct;
set family_practice (keep=npi total_services);
if _n_=1 then set family_practice_total;
pct_total=total_services / total_number;
format pct_total percent10.3;
run;

proc means data=pct;
var pct_total;
run;

*4;
*family;
data family;
set npi.cms_providers_la;
if provider_type = "Family Practice";
run;

data family_benes (keep=total_benes);
  set family end=last;
  total_benes+total_unique_benes;
  if last then output;
run;

data pct_family;
set family (keep=npi total_unique_benes provider_type);
if _n_=1 then set family_benes;
pct_family=total_unique_benes / total_benes;
format pct_family percent10.3;
run;

*psy;
data psy;
set npi.cms_providers_la;
if provider_type = "Psychiatry";
run;

data psy_benes (keep=total_benes);
  set psy end=last;
  total_benes+total_unique_benes;
  if last then output;
run;

data pct_psy;
set psy (keep=npi total_unique_benes provider_type);
if _n_=1 then set psy_benes;
pct_psy=total_unique_benes / total_benes;
format pct_psy percent10.3;
run;

*emer;
data emer;
set npi.cms_providers_la;
if provider_type = "Emergency Medicine";
run;

data emer_benes (keep=total_benes);
  set emer end=last;
  total_benes+total_unique_benes;
  if last then output;
run;

data pct_emer;
set emer (keep=npi total_unique_benes provider_type);
if _n_=1 then set emer_benes;
pct_emer=total_unique_benes / total_benes;
format pct_emer percent10.3;
run;

data pct_append;
 set pct_family (rename=(pct_family = num_benes_relative_tot))
     pct_psy (rename=(pct_psy = num_benes_relative_tot))
     pct_emer (rename=(pct_emer = num_benes_relative_tot));
run;

proc means data=pct_append median;
class provider_type;
run;

*5;
data cms_deactivated;
 length NPI $10;
 informat NPPES_Deactivation_Date mmddyy10.;
 infile "~/my_shared_file_links/u5338439/NPPES_Deactivated_NPI_Report_20171010.csv" dsd;
 input  NPI $
        NPPES_Deactivation_Date;
 format NPPES_Deactivation_Date mmddyy10.;
run;

title "Contents of the Deactivation NPI Report Data Set";
proc contents data=cms_deactivated;
run;

proc sort data=cms_deactivated;
by npi;
run;

data cms;
set npi.cms_providers_la;
run; 

proc sort data=cms;
by npi;
run;

data combine;
merge cms (in=master)
	  cms_deactivated (in=deactivated);
by npi;
if master and deactivated;
run;


*6;
data cms;
set npi.cms_providers_la;
run;

proc sort data=cms_deactivated;
by npi;
run;

proc sort data=cms;
by npi;
run;

data combine_update;
  update cms (in=master) 
  		 cms_deactivated (in=deactivated);
  by npi;
  if master;
run;
