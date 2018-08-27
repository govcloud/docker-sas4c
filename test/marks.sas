/* marks.sas */
options linesize=79 noovp formdlim='_';
title 'Grades from STA3000 at Roosevelt University:  Fall, 1957';
title2 'Illustrate Elementary Tests';

proc format; /* Used to label values of the categorical variables */
     value sexfmt    0 = 'Male'   1 = 'Female';
     value ethfmt    1 = 'Chinese'
                     2 = 'European'
                     3 = 'Other' ;
data grades;
     infile 'statclass1.dat';
     input sex ethnic quiz1-quiz8 comp1-comp9 midterm final;
     /* Drop lowest score for quiz & computer  */
     quizave = ( sum(of quiz1-quiz8) - min(of quiz1-quiz8) ) / 7;
     compave = ( sum(of comp1-comp9) - min(of comp1-comp9) ) / 8;
     label ethnic = 'Apparent ethnic background (ancestry)'
           quizave = 'Quiz Average (drop lowest)'
           compave = 'Computer Average (drop lowest)';
     mark = .3*quizave*10 + .1*compave*10 + .3*midterm + .3*final;
     label mark = 'Final Mark';
     diff = quiz8-quiz1; /* To illustrate matched t-test */
     label diff = 'Quiz 8 minus Quiz 1';
     mark2 = round(mark);
     /* Bump up at grade boundaries */
     if mark2=89 then mark2=90;
     if mark2=79 then mark2=80;
     if mark2=69 then mark2=70;
     if mark2=59 then mark2=60;
     /* Assign letter grade */
     if mark2=. then grade='Incomplete';
        else if mark2 ge 90 then grade = 'A';
        else if 80 le mark2 le 89 then grade='B';
        else if 70 le mark2 le 79 then grade='C';
        else if 60 le mark2 le 69 then grade='D';
        else grade='F';
     format sex sexfmt.;       /* Associates sex & ethnic    */
     format ethnic ethfmt.;    /* with formats defined above */

/* Now the proc steps */


proc freq;
      title3 'Frequency distributions of the categorical variables';
      tables sex ethnic grade;

proc means n mean std;
     title3 'Means and SDs of quantitative variables';
     var quiz1 -- mark;        /*  single dash only works with numbered
                                  lists, like quiz1-quiz8    */
proc ttest;
     title3 'Independent t-test';
     class sex;
     var mark;
proc means n mean std t;
     title3 'Matched t-test: Quiz 1 versus 8';
     var quiz1 quiz8 diff;
proc glm;
     title3 'One-way anova';
     class ethnic;
     model mark = ethnic;
     means ethnic;
     means ethnic / Tukey Bon Scheffe;
proc freq;
     title3 'Chi-squared Test of Independence';
     tables sex*ethnic sex*grade ethnic*grade / chisq;
proc freq; /*  Added after seeing warning from chisq test above */
     title3 'Chi-squared Test of Independence: Version 2';
     tables sex*ethnic grade*(sex ethnic) / norow nopercent chisq expected;
proc corr;
     title3 'Correlation Matrix';
     var final midterm quizave compave;
proc plot;
     title3 'Scatterplot';
     plot final*midterm; /* Really should do all combinations */
proc reg;
     title3 'Simple regression';
     model final=midterm;

/* Predict final exam score from midterm, quiz & computer */
proc reg simple;
     title3 'Multiple Regression';
     model final = midterm quizave compave / ss1;
     smalstuf: test quizave = 0, compave = 0;
run;

/* Note that the final run statement is not needed when
   running SAS from the unix command line. */
