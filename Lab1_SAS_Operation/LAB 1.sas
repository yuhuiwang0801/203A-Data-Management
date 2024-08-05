data rankings;
  length name $ 50
         location $ 50;
  infile "~/my_shared_file_links/u5338439/US_University_Rankings.csv" dsd firstobs=2;
  informat tuition_and_fees comma10. 
  		   undergrad_enrollment comma10.
  		   in_state comma10.;
  input name $ 
        location $ 
        rank 
        tuition_and_fees 
        in_state 
        undergrad_enrollment ;
run;

*Exercise1;
proc means data=rankings N mean std median min max;
 var undergrad_enrollment 
 	 in_state;
run;

*Exercise2;
proc format;
 value feefmt low-<5000 = "< $5,000"
              5000-<9999 = "$5,000 to $9,999"
              10000-<14999 = "$10,000 to $14,999"
              15000-<24999 = "$15,000 to $24,999"
              25000-<34999 = "$25,000 to $34,999"
              35000-high = "$35,000 or more";
run;

proc freq data=rankings;
 format undergrad_enrollment feefmt.;
 tables undergrad_enrollment ;
run;

*Exercise3;
proc format;
value rankg low-<51="Rank 1-50"
			51-<100="Rank 51-100"
			101-high="Rank > 100";
run;

proc freq data=rankings;
format rank rankg. undergrad_enrollment feefmt.;
by rank;
table undergrad_enrollment;
run;

*Exercise4;
proc means data = rankings N mean std median min max;
format undergrad_enrollment feefmt.;
var rank;
class undergrad_enrollment ;
run;

*Exercise5;
data rankings;
  length name $ 50
         location $ 50;
  infile "~/my_shared_file_links/u5338439/US_University_Rankings.csv" dsd firstobs=2;
  informat tuition_and_fees comma10. 
  		   undergrad_enrollment comma10.
  		   in_state comma10.;
  input name $ 
        location $ 
        rank 
        tuition_and_fees 
        in_state 
        undergrad_enrollment ;
  format tuition_and_fees feefmt. 
  		 in_state feefmt.;
  title "Alphabetic List of Variables and Attributes";
  label name="University Name"
  		location="University Location"
  		rank="University Rank"
  		tuition_and_fees="Annual Tuition and Fees"
  		in_state="Annual In-state Tuition and Fees"
  		undergrad_enrollment="Undergraduate Enrollment"
run;

proc contents data = rankings;
run;

*Exercise6;
libname myfmts "~/nonshare/Formats/";
proc format library=myfmts;
value $genderfmt "M"="male"
				 "F"="female";
value yesnofmt 1="No"
			   2="Yes";
run;

data lung_cancer;

infile "~/my_shared_file_links/u5338439/survey_lung_cancer.csv" dsd firstobs=2;
input gender $
	  age
	  smoking
	  yellow_fingers
	  anxiety
	  peer_pressure
	  chronic_disease
	  fatigue
	  allergy
	  wheezing
	  alcohol
	  coughing
	  shortness_of_breath
	  swallowing_difficulty
	  chest_pain
	  lung_cancer $;

format gender $genderfmt.
	   coughing yesnofmt.;
run;

proc freq data=lung_cancer;
tables gender*anxiety*lung_cancer/list;
tables (gender anxiety)*lung_cancer/list;
run;

*Exercise7;
proc freq data=lung_cancer;
tables (smoking anxiety peer_pressure alcohol)*lung_cancer;
run;
