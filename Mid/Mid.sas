libname mydata "~/nonshare";
data w2007;
  set mydata.w2007;
run;

data w2011;
  set mydata.w2011;
run;

data famid;
  set mydata.famidsubset;
  if subsetnumber=50;
run;

data w2007_subset;
    merge w2007(in=a) famid(in=b);
    by famid;
    if a and b;
run;

data w2011_subset;
    merge w2011(in=a) famid(in=b);
    by famid;
    if a and b;
run;

data w2007_w2011;
	merge w2007_subset(in=a) w2011_subset(in=b);
	by famid;
	completed_2011 = "No";
	if a then do;
		completed_2011 = "No";
		if b then completed_2011 = "Yes";
		output;
	end;
run;

*table 1;
*gender;
proc format;
value gender 0 = "Female"
	   1 = "Male"
	   . = "Missing Values";
run;

proc freq data=w2007_w2011;
	format W1C542C gender.;
    tables W1C542C*completed_2011 / missing;
run;

*education;
proc format;
value highest_edu low-2 = "High School or Less"
				  3 = "Technical or Vocational"
				  4-5 = "Some College"
				  6 = "Bachelor’s Degree"
				  7-high = "Graduate Degree"
				  . = "Missing Values";
run;	
			  
proc freq data=w2007_w2011;
	format C1ED17 highest_edu.;
    tables C1ED17*completed_2011 / missing;
run;

*employ;
proc format;
value employ 1 = "No"
	   		 2 = "Yes"
	   		 . = "Missing Values";
run;

proc freq data=w2007_w2011;
	format D617 employ.;
    tables D617*completed_2011 / missing;
run;

*marry;
proc format;
value marry 1 = "No"
	   		 2 = "Yes"
	   		 . = "Missing Values";
run;

proc freq data=w2007_w2011;
	format F1017 marry.;
    tables F1017*completed_2011 / missing;
run;

*children;
proc format;
value children 1 = "No"
	   		   2 = "Yes"
	   		   . = "Missing Values";
run;

proc freq data=w2007_w2011;
	format F517 children.;
    tables F517*completed_2011 / missing;
run;


data job;
set w2007_w2011;
if D617=2;
run;

*job_sercurity;
proc format;
value job_sercurity 1 = "Not at all secure"
	   		   	    2 = "Somewhat secure"
	   		   	    3 = "Secure"
	   		   	    4 = "Very secure"
	   		        . = "Missing Values";
run;

proc freq data=job;
	format D1617 job_sercurity.;
    tables D1617*completed_2011 / missing;
run;

*job_satisfaction;
proc format;
value job_satisfaction 1-2 = "Extremely or very dissatisfied"
					   3 = "Somewhat dissatisfied"
					   4 = "Somewhat satisfied"
					   5-6 = "Extremely or very satisfied"
					   . = "Missing Values";
run;

proc freq data=job;
	format D1817 job_satisfaction.;
    tables D1817*completed_2011 / missing;
run;

*//////////////////////////////////////////////////;

*table 2;
*age;
data w2007_w2011_age;    
    set w2007_w2011;
    age_at_2007 = .;
    if not missing(BIRTMO17) and not missing(BIRTYR17) then do;
        birth_date = mdy(BIRTMO17, 1, BIRTYR17);
        age_at_2007 = intck('month', birth_date, '01OCT2007'd) / 12;
        output;
    end;
    format age_at_2007 6.2;
run;

proc means data=w2007_w2011_age n nmiss mean std;
    class completed_2011;
    var age_at_2007;
run;

*income;
data w2007_w2011_income;
    set w2007_w2011;
    if not missing(E5HI17);
run;

proc means data=w2007_w2011_income nmiss n mean std;
    var E5HI17;
    class completed_2011;
run;

*mental health;
data w2007_w2011_mh;
    set w2007_w2011;
    Mental_Health_Total_Score = .;
    if not missing(H13A17) and not missing(H13B17) and not missing(H13C17) and not missing(H13D17) and not missing(H13E17) and not missing(H13F17) and not missing(H13G17) and not missing(H13H17) and not missing(H13I17) and not missing(H13J17) and not missing(H13K17) and not missing(H13L17) and not missing(H13M17) and not missing(H13N17) and not missing(H13O17) then do;
        H13A17_r = 6 - H13A17;
        H13D17_r = 6 - H13D17;
        H13F17_r = 6 - H13F17;
        H13I17_r = 6 - H13I17;
        H13N17_r = 6 - H13N17;
        H13O17_r = 6 - H13O17;

        Mental_Health_Total_Score = H13A17_r + H13B17 + H13C17 + H13D17_r + H13E17 + H13F17_r + H13G17 + H13H17 + H13I17_r + H13J17 + H13K17 + H13L17 + H13M17 + H13N17_r + H13O17_r;
        output;
    end;
    if not missing(Mental_Health_Total_Score);
run;

proc means data=w2007_w2011_mh n nmiss mean std;
    var Mental_Health_Total_Score;
    class completed_2011;
run;

*//////////////////////////////////////////////////;

*table 3;
data combine;
	merge w2007_subset(in=a) w2011_subset(in=b);
	by famid;
	if a and b;
run;

*stress;
data combine_stress;
	set combine;
	if not missing(E117);
	if not missing(E2STRE19);
run;

proc means data = combine_stress n nmiss mean std;
	var E117 E2STRE19;
	label E117 = "2007 Stress Level" 
		  E2STRE19 = "2011 Stress Level";
run;

*difficult for bills;
data combine_bill;
	set combine;
	if not missing(E217);
	if not missing(E3BILL19);
run;

proc means data = combine_bill n nmiss mean std;
	var E217 E3BILL19;
	label E217 = "2007 bill difficult Level" 
		  E3BILL19 = "2011 bill difficult Level";
run;

*///////////////////////////////////////////////////;
*table4;
proc format;
value yes 1="Yes"
		  0="No";
run;

proc freq data=combine;
	format D3CNRA17 D4CNRA19 D3CNRB17 D4CNRB19 D3CNRC17 D4CNRD19 D3CNRE17 D4CNRE19 D3CNRF17 D4CNRF19 D3CNRD17 D4CNRI19 D3CNRI17 D4CNRJ19 D3CNRJ17 D4CNRK19 yes.;
	*ability;
	tables D3CNRA17 / missing;
	label D3CNRA17 = "2007";
	tables D4CNRA19 / missing;
	label D4CNRA19 = "2011";
	*money;
	tables D3CNRB17 / missing;
	label D3CNRB17 = "2007";
	tables D4CNRB19 / missing;
	label D4CNRB19 = "2011";
	*overqualified;
	tables D3CNRC17 / missing;
	label D3CNRC17 = "2007";
	tables D4CNRD19 / missing;
	label D4CNRD19 = "2011";
	*opening;
	tables D3CNRE17 / missing;
	label D3CNRE17 = "2007";
	tables D4CNRE19 / missing;
	label D4CNRE19 = "2011";
	*relocation;
	tables D3CNRF17 / missing;
	label D3CNRF17 = "2007";
	tables D4CNRF19 / missing;
	label D4CNRF19 = "2011";
	*illness;
	tables D3CNRD17 / missing;
	label D3CNRD17 = "2007";
	tables D4CNRI19 / missing;
	label D4CNRI19 = "2011";
	*relative care;
	tables D3CNRI17 / missing;
	label D3CNRI17 = "2007";
	tables D4CNRJ19 / missing;
	label D4CNRJ19 = "2011";
	*transportation;
	tables D3CNRJ17 / missing;
	label D3CNRJ17 = "2007";
	tables D4CNRK19 / missing;
	label D4CNRK19 = "2011";
run;	





