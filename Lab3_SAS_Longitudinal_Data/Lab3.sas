libname lb "~/my_shared_file_links/u5338439";
run;
proc contents data=lb.hlth_2009;
run;

proc sort data=lb.hlth_2009;
 by IND_ID HH_ID;
run;


*1;
proc transpose data=lb.hlth_2009 out=hlth_very_long (rename=(COL1=INDICATOR)) name=WAVE;
by IND_ID HH_ID;
var HEADACHE_2004
    HEADACHE_2006
    HEADACHE_2009
    SORETHROAT_2004
    SORETHROAT_2006
    SORETHROAT_2009
    STOMACHACHE_2004
    STOMACHACHE_2006
    STOMACHACHE_2009;
run;

data hlth_very_long;
retain IND_ID HH_ID WAVE SYMPTOM INDICATOR;
set hlth_very_long;
SYMPTOM=compress(WAVE, '_', 'd');
WAVE = compress(WAVE, '_', 'a');
run;

proc contents data=hlth_very_long;
run;

*2;
proc transpose data=lb.hlth_2009 out=hlth_head (rename=(col1=HEADACHE)) name=WAVE;
by IND_ID HH_ID HH_TYPE;
var HEADACHE_2004
    HEADACHE_2006
    HEADACHE_2009;
run;

data hlth_head;
set hlth_head;
WAVE = compress(WAVE, '_', 'a');

proc transpose data=lb.hlth_2009 out=hlth_sore (rename=(col1=SORETHROAT)) name=WAVE;
by IND_ID HH_ID HH_TYPE;
var SORETHROAT_2004
    SORETHROAT_2006
    SORETHROAT_2009;
run;

data hlth_sore;
set hlth_sore;
WAVE = compress(WAVE, '_', 'a');

proc transpose data=lb.hlth_2009 out=hlth_stomach (rename=(col1=STOMACHACHE)) name=WAVE;
by IND_ID HH_ID HH_TYPE;
var STOMACHACHE_2004
    STOMACHACHE_2006
    STOMACHACHE_2009;
run;

data hlth_stomach;
set hlth_stomach;
WAVE = compress(WAVE, '_', 'a');

data hlth_long;
merge hlth_head hlth_sore hlth_stomach;
by IND_ID HH_ID WAVE HH_TYPE;
run;

proc contents data=hlth_long;
run;

*3;
proc format;
value dwelling 1="Urban"
			   2="Rural"; 
run;

proc tabulate data=hlth_long;
format hh_type dwelling.;
class wave hh_type;
var HEADACHE SORETHROAT STOMACHACHE;
table (HEADACHE SORETHROAT STOMACHACHE)*(hh_type All),
	  (WAVE)*(MEAN="percent"*F=percent8.2);
run;


*4;
data hlth_array_long_headache;
 set lb.hlth_2009;
 array headache_array{3} 
       HEADACHE_2004
       HEADACHE_2006
       HEADACHE_2009;
 array wv{3}$ wv1-wv3 ('2004','2006','2009');
 do i = 1 to 3;
  WAVE = wv{i};
  HEADACHE = headache_array{i};
  output;
 end;
 keep IND_ID HH_ID WAVE HEADACHE HH_TYPE;
run;

data hlth_array_long_sorethroat;
 set lb.hlth_2009;
 array sorethroat_array{3} 
       SORETHROAT_2004
       SORETHROAT_2006
       SORETHROAT_2009;
 array wv{3}$ wv1-wv3 ('2004','2006','2009');
 do i = 1 to 3;
  WAVE = wv{i};
  SORETHROAT = sorethroat_array{i};
  output;
 end;
 keep IND_ID HH_ID WAVE SORETHROAT HH_TYPE;
run;

data hlth_array_long_stomachache;
 set lb.hlth_2009;
 array stomachache_array{3} 
       STOMACHACHE_2004
       STOMACHACHE_2006
       STOMACHACHE_2009;
 array wv{3}$ wv1-wv3 ('2004','2006','2009');
 do i = 1 to 3;
  WAVE = wv{i};
  STOMACHACHE = stomachache_array{i};
  output;
 end;
 keep IND_ID HH_ID WAVE STOMACHACHE HH_TYPE;
run;

data hlth_array_long;
merge hlth_array_long_headache hlth_array_long_sorethroat hlth_array_long_stomachache;
by IND_ID HH_ID WAVE HH_TYPE;
run;

proc contents data=hlth_array_long;
run;

*5;
proc transpose data=hlth_array_long out=hlth_wide_headache (drop=_NAME_) prefix= HEADACHE_;
by IND_ID HH_ID HH_TYPE;
id WAVE;
var HEADACHE;
run;

proc transpose data=hlth_array_long out=hlth_wide_sorethroat (drop=_NAME_) prefix= SORETHROAT_;
by IND_ID HH_ID HH_TYPE;
id WAVE;
var SORETHROAT;
run;

proc transpose data=hlth_array_long out=hlth_wide_stomachache (drop=_NAME_) prefix= STOMACHACHE_;
by IND_ID HH_ID HH_TYPE;
id WAVE;
var STOMACHACHE;
run;

data hlth_wide;
merge hlth_wide_headache 
	  hlth_wide_sorethroat 
	  hlth_wide_stomachache;
by IND_ID HH_ID HH_TYPE;
run;

proc print data=hlth_wide (obs=8);
run;

*6;
data question;
 set hlth_wide;
 MISS_COUNT_0609 = CMISS(HEADACHE_2006, HEADACHE_2009);
run;

data question;
 set question;
 if (HEADACHE_2004 ne .) and (MISS_COUNT_0609 ne 2)
 	then WV04_AND_06OR09 = 1;
 else WV04_AND_06OR09 = 0;
 
 if (HEADACHE_2004 ne .) and (HEADACHE_2006 ne .) 
 	then WV0406 =1;
 else WV0406 =0;
 
 if (HEADACHE_2004 ne .) and (HEADACHE_2006 ne .) and (HEADACHE_2009 ne .)
 	then WV040609=1;
 else WV040609=0;
 
 if (HEADACHE_2006 ne .) and (HEADACHE_2009 ne .) and (HEADACHE_2004 = .)
 	then WV0609_NOT04=1;
 else WV0609_NOT04=0;
run;

proc freq data=question;
tables WV04_AND_06OR09 WV0406 WV040609 WV0609_NOT04/nocum list; 
run;

*7;
proc freq data=hlth_long (where=(headache ne .));
tables wave/nocum;
run;




