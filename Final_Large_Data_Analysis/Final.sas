libname lb "~/nonshare/Final";

proc contents data=lb.hcmst;
run;

data casesubset;
 infile "~/nonshare/Final/CaseSubset.csv" dsd firstobs = 2;
 input caseid_new
 	   subsetnumber;
run;
 
proc sort data = casesubset;
 by caseid_new;
run;
 
proc sort data=lb.hcmst;
 by caseid_new;
run;
 
data my_hcmst;
 merge casesubset (where=(subsetnumber=50) in=ind1)
       lb.hcmst (in= ind2);
 by caseid_new;
 if ind1 & ind2;
run;
 
proc format;
  value fmt 0 = "No"
    		1 = "Yes"
    		-1 = "Missing"
    		. = "Missing";
run;
 
proc format;
  value gender 1 = "Male"
  			   2 = "Female";
run;

data hcmst;
set my_hcmst;
age_difference_indicator = ifn((missing(Q9) | missing(PPAGE)), ., ifc(abs(PPAGE - Q9) <= 5, 1, 0));
format Q31_1 - Q31_9 fmt.;
format Q33_1 - Q33_7 fmt.;
format age_difference_indicator fmt.;
run;

*//////////////////////////////////////////////////////;


*1;
%macro mychi(varname, varlabel, varform, dat);
*work;

ods output CrossTabFreqs=CTF (where=(Q31_1=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));
		   
proc freq data=&dat;
table Q31_1 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF;
merge CTF CS;
by table;
varlabel="Work";
keep varlabel &varname frequency rowpercent prob;
run;


*school;
ods output CrossTabFreqs=CTF (where=(Q31_2=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q31_2 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF2;
merge CTF CS;
by table;
varlabel="School";
keep varlabel &varname frequency rowpercent prob;
run;

*church;
ods output CrossTabFreqs=CTF (where=(Q31_3=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q31_3 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF3;
merge CTF CS;
by table;
varlabel="Church";
keep varlabel &varname frequency rowpercent prob;
run;

*internet;
ods output CrossTabFreqs=CTF (where=(Q31_4=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q31_4 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF4;
merge CTF CS;
by table;
varlabel="Dating Service";
keep varlabel &varname frequency rowpercent prob;
run;

*trip;
ods output CrossTabFreqs=CTF (where=(Q31_5=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q31_5 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF5;
merge CTF CS;
by table;
varlabel="Vacation";
keep varlabel &varname frequency rowpercent prob;
run;

*club;
ods output CrossTabFreqs=CTF (where=(Q31_6=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q31_6 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF6;
merge CTF CS;
by table;
varlabel="Bar";
keep varlabel &varname frequency rowpercent prob;
run;

*social organization;
ods output CrossTabFreqs=CTF (where=(Q31_7=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q31_7 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF7;
merge CTF CS;
by table;
varlabel="Social Organization";
keep varlabel &varname frequency rowpercent prob;
run;

*party;
ods output CrossTabFreqs=CTF (where=(Q31_8=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q31_8 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF8;
merge CTF CS;
by table;
varlabel="Private Party";
keep varlabel &varname frequency rowpercent prob;
run;

*other;
ods output CrossTabFreqs=CTF (where=(Q31_9=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q31_9 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF9;
merge CTF CS;
by table;
varlabel="Other";
keep varlabel &varname frequency rowpercent prob;
run;

*introduce;
*family;
ods output CrossTabFreqs=CTF (where=(Q33_1=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q33_1 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF11;
merge CTF CS;
by table;
varlabel="Family";
keep varlabel &varname frequency rowpercent prob;
run;

*friend;
ods output CrossTabFreqs=CTF (where=(Q33_2=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q33_2 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF12;
merge CTF CS;
by table;
varlabel="Mutual Friends";
keep varlabel &varname frequency rowpercent prob;
run;

*worker;
ods output CrossTabFreqs=CTF (where=(Q33_3=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q33_3 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF13;
merge CTF CS;
by table;
varlabel="Co-Workers";
keep varlabel &varname frequency rowpercent prob;
run;

*classmate;
ods output CrossTabFreqs=CTF (where=(Q33_4=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q33_4 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF14;
merge CTF CS;
by table;
varlabel="Classmates";
keep varlabel &varname frequency rowpercent prob;
run;

*neighbors;
ods output CrossTabFreqs=CTF (where=(Q33_5=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q33_5 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF15;
merge CTF CS;
by table;
varlabel="Neighbors";
keep varlabel &varname frequency rowpercent prob;
run;

*self;
ods output CrossTabFreqs=CTF (where=(Q33_6=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q33_6 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF16;
merge CTF CS;
by table;
varlabel="Self or Partner";
keep varlabel &varname frequency rowpercent prob;
run;

*other introduce;
ods output CrossTabFreqs=CTF (where=(Q33_7=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table Q33_7 * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF17;
merge CTF CS;
by table;
varlabel="Other Intro";
keep varlabel &varname frequency rowpercent prob;
run;

*age difference;
ods output CrossTabFreqs=CTF (where=(age_difference_indicator=1 & RowPercent ne .))
		   ChiSq=CS (where=(statistic="Chi-Square"));

proc freq data=&dat;
table age_difference_indicator * &varname / nopercent nocol chisq;
run;

proc sort data=CTF;
by table;
run;

proc sort data=CS;
by table;
run;

data CSCTF21;
merge CTF CS;
by table;
varlabel="Age";
keep varlabel &varname frequency rowpercent prob;
run;

*////////////////////////////////;

*tabulate;
data combined;
length varlabel $30.;
set CSCTF CSCTF2 CSCTF3 CSCTF4 CSCTF5 CSCTF6 CSCTF7 CSCTF8 CSCTF9
	CSCTF11 CSCTF12 CSCTF13 CSCTF14 CSCTF15 CSCTF16 CSCTF17 CSCTF21;
if varlabel in ('Bar','Church','Dating Service','Other','Private Party',
'School','Social Organization','Vacation','Work')
then Category="1. Where Met Partner:  ";
else if varlabel in ('Classmates','Co-Workers','Family','Other Intro',
'Mutual Friends','Neighbors','Self or Partner')
then Category="2. Who Introduced Partner:  ";
else if varlabel='Age'
then Category="3. Similar Age:  ";
run;

*format;
proc tabulate data = combined;
format &varname &varform;
class Category &varname varlabel;
var frequency rowpercent prob;
table Category* varlabel="", &varname= &varlabel *(frequency="N"*f=6. rowpercent="%"*f=6.2)*sum=""
ALL*prob*mean*f=10.4;

run;
%mend;


%mychi(MARRIED, "gender", fmt., hcmst);

*/////////////////////////////////////////////////////////////////;




*2;
data hcmst;
set hcmst;
Excellent_Indicator = ifn(RELATIONSHIP_QUALITY = 5, 1, 
						  ifn(not missing(RELATIONSHIP_QUALITY), 0, .));
format Excellent_Indicator fmt.;
run;

%mychi(Excellent_Indicator, "Excellent Indicator", fmt., hcmst);


*3;


