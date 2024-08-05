/************************************/
/** BIOSTATISTICS 203A             **/
/** FALL 2023                      **/
/** LAB 2 PROGRAM                  **/
/************************************/

libname npi "C:\\Users\\haralis\\Documents\\BIOSTAT 203A\\Data";

proc contents data=npi.cms_providers_la;
run;

proc sgplot data=npi.cms_providers_la;
  reg x=total_unique_benes y=total_submitted_chrg_amt / nomarkers;
  reg x=total_unique_benes y=total_medicare_allowed_amt / nomarkers;
  reg x=total_unique_benes y=total_medicare_payment_amt / nomarkers;
run;

proc sgplot data=npi.cms_providers_la;
   title1 "Association of Total Charges/Payments and Number of Beneficiaries"; 
   title2 "Best-Fit Line";
reg x=total_unique_benes y=total_submitted_chrg_amt / legendlabel="Medicare Submitted Charges"                     nomarkers;
reg x=total_unique_benes y=total_medicare_allowed_amt / legendlabel="Medicare Allowed Charges" nomarkers;
reg x=total_unique_benes y=total_medicare_payment_amt / legendlabel="Medicare Payments" nomarkers;
   format total_submitted_chrg_amt
          total_medicare_allowed_amt
          total_medicare_payment_amt dollar15.;
   xaxis label="Number of Medicare Beneficiaries";
   yaxis label="Total Amount";
run;

data cms_submitted;
 set npi.cms_providers_la;
 keep npi total_unique_benes total_submitted_chrg_amt;
run;

data cms_allowed;
 set npi.cms_providers_la;
 keep npi total_unique_benes total_medicare_allowed_amt;
run;

data cms_payment;
 set npi.cms_providers_la;
 keep npi total_unique_benes total_medicare_payment_amt;
run;

data cms_append;
 set cms_submitted (in=in_sub rename=(total_submitted_chrg_amt = amount))
     cms_allowed (in=in_allow rename=(total_medicare_allowed_amt = amount))
     cms_payment (in=in_pay rename=(total_medicare_payment_amt = amount));
 if in_sub then amount_type = "Medicare Submiitted Charges";
 else if in_allow then amount_type = "Medicare Allowed Charges"; 
 else if in_pay then amount_type = "Medicare Payments";
run;

proc sort data=cms_append;
 by npi;
run;

proc print data=cms_append (obs=20) noobs;
run;

proc sgplot data=cms_append;
   title1 "Association of Total Charges/Payments and Number of Beneficiaries"; 
   title2 "Best-Fit Line";
   label amount_type = "Amount Type";
   reg y=amount x=total_unique_benes / group=amount_type nomarkers; 
   xaxis label="Number of Medicare Beneficiaries";
   yaxis label="Total Amount";
   format amount dollar15.;
run;

proc transpose 
 data=npi.cms_providers_la
 out=cms_long (rename=(Col1=amount _LABEL_ = amount_type))
 name=at;
 by npi total_unique_benes;
 var total_submitted_chrg_amt total_medicare_allowed_amt total_medicare_payment_amt;
run;

proc sgplot data=cms_long;
   title1 "Association of Total Charges/Payments and Number of Beneficiaries"; 
   title2 "Best-Fit Line";
   label amount_type = "Amount Type";
   reg y=amount x=total_unique_benes / group=amount_type nomarkers; 
   xaxis label="Number of Medicare Beneficiaries";
   yaxis label="Total Amount";
   format amount dollar15.;
run;

data psych;
 set npi.cms_providers_la;
 if provider_type = "Psychiatry";
run;

data totPsych (keep=TotChrgs);
 set psych end=last;
 TotChrgs + total_submitted_chrg_amt;
 if last then output;
run;

data pctPsych; 
set psych(keep=npi nppes_provider_last_org_name nppes_provider_first_name  total_submitted_chrg_amt); 
 if _n_ = 1 then set totPsych; 
 pct_submitted_charges = total_submitted_chrg_amt/TotChrgs; 
 format pct_submitted_charges percent10.3; 
run;

proc sort data=pctPsych;
 by descending pct_submitted_charges;
run;

title "3 Psychiatrists with the Highest Percent Submitted Charges Amount";
proc print data=pctPsych (obs=3);
 var npi nppes_provider_last_org_name nppes_provider_first_name pct_submitted_charges;
run;

data cms_deactivated;
 length NPI $10;
 informat NPPES_Deactivation_Date mmddyy10.;
 infile "C:\\Users\\haralis\\Documents\\BIOSTAT 203A\\Data\\NPPES_Deactivated_NPI_Report_20171010.csv" dsd;
 input  NPI $
        NPPES_Deactivation_Date;
 format NPPES_Deactivation_Date mmddyy10.;
run;

title "Contents of the Deactivation NPI Report Data Set";
proc contents data=cms_deactivated;
run;
