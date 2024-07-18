
*1;
%macro generate_sqr_table(start, end);
    data sqr_table;
        do n = &start to &end;
            Sqr_n = n*n;
            output;
        end;
    run;
    title "Table of Squared Values for Integers from &start to &end";
    proc print data=sqr_table noobs;
    run;
%mend;

%generate_sqr_table(10, 15);

*2;
libname l "~/my_shared_file_links/u5338439";

%MACRO provtyp(string1, string2);
    title "Provider Type of the Provider";
    proc tabulate data=l.cms_providers_la;
    	where provider_type contains &string1 or provider_type contains &string2; 
        class provider_type;
        var beneficiary_average_age beneficiary_average_risk_score;
        table (beneficiary_average_age beneficiary_average_risk_score)*(n='N' mean='Mean' std='Standard Deviation'), 
              provider_type;
    run;
%MEND;

%provtyp("Anesthesiology", "Orthopedic Surgery");

*3;
%macro my_macro(obs, var);
    ods rtf file = "~/nonshare/sampleoutput.rtf" style=Journal;

    title "Listing of Physicians";
    proc print data=l.cms_providers_la (obs=&obs);
    id npi;
    var nppes_provider_last_org_name nppes_provider_first_name;
    run;

    title "Total Services by Provider Gender";
    proc means data=l.cms_providers_la;
    class nppes_provider_gender;
    var &var;
    run;
    ods rtf close;

    proc contents data=l.cms_providers_la;
    run;
%mend;

%my_macro(obs=10, var=beneficiary_average_risk_score);

*4;
%macro my_macro(obs, var, name);
    ods rtf file = "~/nonshare/&name._sampleoutput.rtf" style=Journal;

    title "Listing of Physicians";
    proc print data=L.cms_providers_la (obs=&obs);
    id npi;
    var nppes_provider_last_org_name nppes_provider_first_name;
    run;

    title "Total Services by Provider Gender";
    proc means data=L.cms_providers_la;
    class nppes_provider_gender;
    var &var;
    run;
    ods rtf close;

    proc contents data=L.cms_providers_la;
    run;
%mend;

%my_macro(8, beneficiary_average_age, Beneficiary Mean Age);

*5;
proc contents data=L.cms_providers_la;
    run;

proc report data=L.cms_providers_la;
 column provider_type total_drug_unique_benes total_drug_submitted_chrg_amt;
 define provider_type/display group "Provider Type";
 define total_drug_unique_benes/analysis sum "Total Number of Beneficiaries with Drug Services" format=10.0;
 define total_drug_submitted_chrg_amt/ analysis sum "Total Drug Submitted Charge Amount" format=dollar12.2;
run;

*6;
proc report data=L.cms_providers_la;
 column provider_type npi total_drug_unique_benes total_drug_submitted_chrg_amt;
 define provider_type/display group "Provider Type";
 define npi / display "NPI";
 define total_drug_unique_benes/analysis sum "Total Number of Beneficiaries with Drug Services" format=10.0;
 define total_drug_submitted_chrg_amt/ analysis sum "Total Drug Submitted Charge Amount" format=dollar12.2;
 break after provider_type / summarize;
run;



