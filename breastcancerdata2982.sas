LIBNAME glm '/home/u62518985';
FILENAME bcdata '/home/u62518985/breastcancer.csv';

PROC IMPORT 
   DATAFILE = bcdata
   OUT = glm.breastcancerdata 
   DBMS = CSV 
   REPLACE; 
   GETNAMES = YES; 
RUN;

data glm.breastcancerdata;
   set glm.breastcancerdata;
   if size = "<=20" then tumor_size = 1;
   else if size = "20-50" then tumor_size = 2;
   else if size = ">50" then tumor_size = 3;
run;

data glm.breastcancerdata;
   set glm.breastcancerdata;
   label
      Id='Patient ID'
      pid='Patient ID within Study'
      year='Year the patient was diagonised'
      age='Age of Patient'
      meno='Menopausal Status (0=Premenopausal, 1=Postmenopausal)'
      size='Size of Tumor'
      grade='Grade of Tumor'
      nodes='Number of Positive Axillary Nodes'
      pgr='Progesterone Receptor Status'
      er='Estrogen Receptor Status'
      hormon='Hormonal Therapy (0=No, 1=Yes)'
      chemo='Chemotherapy received or not (0 = no, 1 = yes)'
      recurence_free='Recurrence-Free Survival Time (Months)'
      rtime ='time between start and recurrence or last follow-up date(if no recurrence was observed)'
      recur = 'Whether or not the patient experienced recurrence (0 = no, 1 = yes)'
      dtime = 'time in months between the start and death or the last follow-up (if the patient was still alive)'
      death='Whether the patient died during the follow-up period 0=Alive, 1=Death'
      tumor_size='Size of tumor, <=20 is 1, 20-50 is 2 and >50 is 3'; 
run;

PROC MEANS DATA=glm.breastcancerdata N MEAN MEDIAN MIN MAX STDDEV SKEWNESS;
   VAR death age meno tumor_size grade nodes pgr er hormon chemo rtime recur dtime;
RUN;

PROC UNIVARIATE DATA=glm.breastcancerdata ;
   VAR death age meno tumor_size grade nodes pgr er hormon chemo rtime recur dtime;
   HISTOGRAM / NORMAL;
RUN;

PROC UNIVARIATE DATA=glm.breastcancerdata ;
   VAR death age meno tumor_size grade nodes pgr er hormon chemo rtime recur dtime;
   QQPLOT / NORMAL;
run;

PROC UNIVARIATE DATA=glm.breastcancerdata ;
   VAR death age meno tumor_size grade nodes pgr er hormon chemo rtime recur dtime;
   PPPLOT / NORMAL;
run;

proc logistic data= glm.breastcancerdata;
   model death = age meno tumor_size grade nodes pgr er hormon chemo rtime recur dtime/ selection=forward;
run;

proc logistic data= glm.breastcancerdata descending;
   model death = age meno tumor_size grade nodes pgr er hormon chemo rtime recur dtime/ selection=forward;
run;
 
proc freq data=glm.breastcancerdata order= data;
tables death age meno tumor_size grade nodes pgr er hormon chemo rtime recur dtime;
run;

proc corr data=glm.breastcancerdata;
var death age meno tumor_size grade nodes pgr er hormon chemo rtime recur dtime;
run;

proc logistic data= glm.breastcancerdata;
   model hormon = age meno tumor_size grade nodes pgr er death chemo rtime recur dtime/ selection=forward;
run;

proc logistic data= glm.breastcancerdata;
   model chemo = age meno tumor_size grade nodes pgr er hormon death rtime recur dtime/ selection=forward;
run;

proc logistic data= glm.breastcancerdata;
   model recur = age meno tumor_size grade nodes pgr er hormon chemo rtime death dtime/ selection=forward;
run;

PROC GENMOD data= glm.breastcancerdata;
   model nodes = age meno tumor_size grade death pgr er hormon chemo rtime recur dtime/ DIST =Poisson Link=Log;
RUN;

PROC GENMOD data=glm.breastcancerdata;
   model nodes = age meno tumor_size grade death pgr er hormon chemo rtime recur dtime/ DIST =negbin Link=Log;
RUN;

PROC GENMOD DATA=glm.breastcancerdata;
   MODEL nodes = age meno tumor_size grade death pgr er hormon chemo rtime recur dtime/ DIST=zip LINK=LOG;
   zeromodel age meno tumor_size grade death pgr er hormon chemo rtime recur dtime ;
RUN;

PROC GENMOD DATA=glm.breastcancerdata;
   MODEL nodes = age meno tumor_size grade death pgr er hormon chemo rtime recur dtime/ DIST=zinb link = log ;
   zeroModel age meno tumor_size grade death pgr er hormon chemo rtime recur dtime  ;
RUN;

proc reg data=glm.breastcancerdata;
   model rtime = age meno tumor_size grade death pgr er hormon chemo nodes recur dtime ;
run;

proc reg data=glm.breastcancerdata;
   model meno = age rtime tumor_size grade death pgr er hormon chemo nodes recur dtime;
run;

proc reg data=glm.breastcancerdata;
   model tumor_size = age meno rtime grade death pgr er hormon chemo nodes recur dtime;
run;

proc reg data=glm.breastcancerdata;
   model grade = age meno tumor_size rtime death pgr er hormon chemo nodes recur dtime;
run;

proc reg data=glm.breastcancerdata;
   model pgr = age meno tumor_size grade death rtime er hormon chemo nodes recur dtime;
run;

proc reg data=glm.breastcancerdata;
   model er = age meno tumor_size grade death pgr rtime hormon chemo nodes recur dtime;
run;

proc reg data=glm.breastcancerdata;
   model dtime = age meno tumor_size grade death pgr er hormon chemo nodes recur rtime;
run;

quit;













