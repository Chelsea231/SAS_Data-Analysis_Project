/* COVER PAGE */
ods escapechar='^';
proc odstext;
p '^{newline 11}';
p "Data Programming with SAS- FINAL PROJECT" /
style=[font_size= 20pt fontweight=bold just= c];
p "Chelsea Rodrigues - 23200333" /
style=[font_size= 18pt just= c];
p '^{newline 11}';
p "I have read and understood the Honesty Code and 
have neither received nor given assistance in any way 
with the work contained in this submission." /
style=[font_size= 14pt font_style= italic just= c];
run;

title1 c=stb bcolor= LIGHTSKYBLUE Height=14pt "DATA ANALYSIS 1";

/* Importing the data */

FILENAME REFFILE '/home/u63919273/Final Project/Projected_annual_deaths_and_births.csv';

PROC IMPORT DATAFILE=REFFILE
    DBMS=CSV
    OUT= s40840fp.death_n_birth;
    GETNAMES=YES;
RUN;

PROC CONTENTS DATA= s40840fp.death_n_birth; 
RUN;

title1 c=stb bcolor=lightpink Height=14pt "Few rows of death and birth dataset";
/* Printing first few rows of the dataset */
PROC PRINT DATA= s40840fp.death_n_birth(OBS=5); 
RUN;


/* Converting YEAR and  VALUE to numeric */
/* Creating a new dataset with numeric variables */
DATA S40840FP.death_n_birth_numeric;
    SET s40840fp.death_n_birth ;
    
    /* Converting the 'Year' variable from character to numeric format */
    Year_Num = input(Year, 4.);
    
    /* Converting the 'VALUE' variable from character to numeric format */
    VALUE_Num = input(VALUE, 8.);
    
    FORMAT Year_Num 4. VALUE_Num 8.;
RUN;

/* Numerical Summaries- Generating numerical summaries for year and value */
title1 c=stb bcolor=lightpink Height=14pt "Numerical Summaries";
footnote 'Conclusion:
Year :As we can clearly notice from the above table that, the average year in the dataset is 2040,
and the years covered range from 2023 to 2057 showing a 35-year span this indiactes that there is small variation 
around the average.

Value:  The average projected value is about 33,505. Values vary widely, from 16,728 to 66,772 indiacting
large variation in projected values.';

PROC MEANS DATA=S40840FP.death_n_birth_numeric N MEAN STD MIN MAX;
    VAR Year_Num VALUE_Num;
RUN;


/* Frequency Distribution for categorical variables */
title1 c=stb bcolor=lightpink Height=14pt "Frequency distribution of categorical Variables";
footnote 'Conclusion:
The data is equally divided among Both sexes,Female and Male, with each category having about 33.33% of the total data.
The dataset is equally divided with 50% of Projected annual birth data and remaining 50% Projected annual birth data.';
PROC FREQ DATA= s40840fp.death_n_birth;
    /* Specify categorical variables, handling space in 'Statistic Label' */
    TABLES Sex 'Statistic Label'n UNIT;
RUN;

/* Graphical summaries- Scatter plot of value vs year */
title1 c=stb bcolor=lightpink Height=14pt "Graphical Summaries";
footnote'Conclusion:
The above graph indicates that Males have higher values of Projected death and birth than Females and both sexes category
 have very high values than individual ma1e and female category.';
 
proc sgplot data=S40840FP.DEATH_N_BIRTH_NUMERIC;
	title height=14pt "Scatter plot for Value vs Year grouped by sex";
	reg x=Year_Num y=VALUE_Num / nomarkers group=Sex;
	scatter x=Year_Num y=VALUE_Num / group=Sex markerattrs=(symbol=circlefilled);
	xaxis grid;
	yaxis grid;
run;

ods graphics / reset;
title;


title1 c=stb bcolor= LIGHTSKYBLUE Height=14pt "DATA ANALYSIS 2";


/*Importing the dataset */
FILENAME REFFILE '/home/u63919273/FinalProject/universities.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT= s40840fp.univerisities;
	GETNAMES=YES;
RUN;

/*prinitng the contents of the dataset */
footnote 'The output shows contents of Univeristy dataset';
proc contents data= s40840fp.univerisities varnum;
run;

/*Q1 */
title1 c=stb bcolor=lightpink Height=14pt "Q1. Few obs of Universities dataset";
footnote 'The above table displays few rows of Unversities dataset';
/*Printing first 5 observations and variables */
proc print data= s40840fp.univerisities(obs=5);
    var _all_;
run;


/* Q2. Numerical summary of the variable student_staff_ratio */
title1 c=stb bcolor=lightpink Height=14pt "Q2. Numerical Summary of student_staff_ratio";
footnote 'The above table displays Numerical Summaries of student_staff_ratio variable';
proc means data= s40840fp.univerisities mean std min max;
    var student_staff_ratio;
    output out=stats mean=mean std=stddev min=min max=max;
run;

/* round the data to 2 decimals */
title1 c=stb bcolor=lightgreen Height=14pt "Numerical summary rounded to 2 decimals";
footnote 'The above table displays Numerical Summaries rounded to 2 decimals of student_staff_ratio variable';
data rounded_data;
    set stats;
    mean = round(mean, 0.01);
    stddev = round(stddev, 0.01);
    min = round(min, 0.01);
    max = round(max, 0.01);
run;

proc print data=rounded_data noobs;
    var mean stddev min max;
run;
/* The mean of the student_staff_ratio is 15.99  */

/* Q3. Performing a univariate analysis on the variable 'number_of_students' */
title c=stb bcolor=lightpink Height=14pt "Q3. Univariate analysis of number_of_students";
footnote 'The mean number of students enrolled in universities is approximately 24505.
Each university has a very different student population; some universities have very few students, while others have a large number.
The average difference is 14091 students. 
Histogram - As we can clearly observe from the histogram that the graph is right skewed which indicates that most universities 
have a moderate number of students, but a few universities have a very large number of students.
Normal Probability Plot (Q-Q Plot)-
Even this plot indicates the same that the number of students isn’t normally distributed. 
The plots points deviate from the straight line, particularly at universities with large numbers of students, 
suggesting that the data is skewed.';
proc univariate data= S40840FP.univerisities;
    var num_students;
    /* plotting a histogram of the 'number_of_students' variable */
    histogram / normal;
    inset mean std min max / format=6.2 position=ne;
    /*Plotting a normal probability plot (Q-Q plot) to assess the normality of the data */
    probplot / normal(mu=est sigma=est) square;
run;

/* Q4. Correlation Analysis */
title1 c=stb bcolor=lightpink Height=14pt "Q4.Correlation Analysis";
footnote 'All  these correlations statistically significant different from 0 ';
proc corr data= s40840fp.univerisities nosimple;

/*Variables included in the correlation analysis */
    var score award pub teaching;
    with score award pub teaching;
    ods select PearsonCorr; /*Displaying correlation table */
run;

/*Q5 */
title1 c=stb bcolor=lightpink Height=14pt "Q5. Hypothesis test";
footnote 'Hypotheses:
Null Hypothesis (H₀): There is no significant difference between the mean number of students in USA universities and UK universities.
𝐻0:𝜇𝑈𝑆𝐴=𝜇𝑈K
​Alternative Hypothesis (H₁): There is a significant difference between the mean number of students in USA universities and UK universities.
𝐻1:𝜇𝑈𝑆𝐴≠𝜇U𝐾 

Plot Interpretation:
Boxplot - The box plots indicates that, on average, USA universities enrolls more students than UK universities as USA box plots are positioned on higher scale.
The statistical test and the differences in these plots verify that the average student population in US and UK universities differs significantly.
Q-Qplot - The distribution of number of students for USA and UK universities is normal as data points do not deviate much for both USA and UK universities. 

Conclusion: We reject the null hypothesis (H₀) because the p-value is less than the significance level of 0.01.
Interpretation: There is enough evidence to reach the conclusion that the mean number of students attending US and UK 
universities differs significantly.';
/*Filtering the data for USA and UK Universities */
data USA_UK_universities;
    set s40840fp.univerisities;
    where country in ('USA', 'United Kingdom');
run;

/* Performing ttest */
proc ttest data=USA_UK_universities plots=all;
    class country;
    var num_students;
run;

/*Creating the Subset (uni1) */
data s40840fp.uni1;
    set s40840fp.univerisities;
    where country in ('United Kingdom', 'Germany', 'Italy'); /*considering the variables given */
run;

/*Q6.*/
title1 c=stb bcolor=lightpink Height=14pt "Question 6.";
footnote 'Sapienza University of Rome is the highest ranked Italian university' ;
/* Print only the observations from 10 to 17  */
proc print data= s40840fp.uni1(firstobs=10 obs=17);
    var university_name year world_rank country national_rank ; /* printing first five variables */
run;

/*Q7. */
title1 c=stb bcolor=lightpink Height=14pt "Q7. Mean Quality of education for uni1 dataset";
footnote 'Mean quality of education for whole uni1 dataset is 213.5543478';
/*Finding mean quality of education for the whole uni1 dataset */
proc means data= s40840fp.uni1 mean;
    var quality_of_education;
run;

/*  Calculate the Mean Quality of Education for the Subset Where quality_of_education > 100 */
title1 c=stb bcolor=lightgreen Height=14pt "Mean Quality of Education for the Subset Where quality_of_education > 100  ";
footnote ' Mean quality of education for subset where quality_of_education >100 is 266.3661972';
proc means data= s40840fp.uni1 mean;
    var quality_of_education;
    where quality_of_education > 100;
run;

/*Q8 */
title1 c=stb bcolor=lightpink Height=14pt "Q8.Summary statistics";
footnote 'From the above output we can clearly see that,
Mean Patents:
Italy has the highest average number of patents (532.21),Germany comes in second with 386.47 patents on average.
The United Kingdom has the lowest average, with 305.84 patents.
Standard Deviation Patents:
The United Kingdom shows the most variability, with a standard deviation of 204.70, 
indicating that the number of patents varies widely between universities.
Italy has the least standard deviation (121.10), indicating that the majority of Italian universities have a similar number of patents.
Germany exhibits a moderate variability (187.56).
Range of patents:
The largest range is seen in the United Kingdom, where patent counts range from 15 to 871, exhibiting both extremely low
and extremely high numbers.
Germany and Italy have smaller ranges of between 138 and 774 patents, respectively, and between 312 and 737 patents, respectively.';

/*Printing summary statistics of patents variable grouped by country */
proc means data= s40840fp.uni1 n mean std min max;
    class country;
    var patents;
run;

/*Q9 */
title1 c=stb bcolor=lightpink Height=14pt "Q9.Plots of publication variable by country";
footnote'The above plot is the visual comparison of publications output across UK, German and Italian universities.
1.United Kingdom:
We can notice that UK has more diversity in publication numbers, most of the universities have moderate number of publications,
while few universities have very high number of publications.
2. Germany:
We can notice that number of publications for German universities is between specific range and has few outliers compared to UK universities. 
3: Italy:
Even, Italian universities have publication counts that are fairly close to each other, with some variation.';

/*Plots for publication variable for UK, German and Italian Universities */
proc sgpanel data=s40840fp.uni1;
    panelby country / layout=rowlattice;
    histogram pub / scale=count fillattrs=(color=green);
    colaxis label="Number of Publications";
    rowaxis label="Frequency";
run;

/*TASKS DEMONSTRATION */
title c=stb bcolor= LIGHTSKYBLUE Height=14pt "TASKS DEMONSTRATION";
footnote '1.Purpose:
The Linear Regression task is used to model and analyze how several characterstics like publications, teaching quality, and international outlook—influence a universities overall rating (score).
 By examining these relationships, we can identify which factors have the most significant impact on the universities score, with this we can better understand what influences higher rankings.
2. Key Functionality of Linear Regression task:
Model Relationships:
These enable us to determine and measure the influence of several independent variables such as pub, teaching and international on dependent variable score.
Predict Outcomes:
By using the values of the independent variables, it assists in making predictions about the dependent variable.
Assess Model Fit: 
It provides statistical measures (e.g., coefficients, R-squared) and visualizations to evaluate how effectively the model explains the data variability and
 the degree of correlation between variables.';

/* Step 1: Importing the dataset */
FILENAME REFFILE '/home/u63919273/FinalProject/universities.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT= s40840fp.univerisities;
	GETNAMES=YES;
RUN;

/* Step 2: Running a Linear Regression */
PROC REG data= s40840fp.univerisities;
    model score = pub teaching international;
    title1 c=stb bcolor= LIGHTSKYBLUE Height=14pt "TASKS DEMONSTRATION";
    title2 c=stb bcolor= LIGHTPINK Height=14pt" Regression Analysis of University Scores on Publications, Teaching, and International ";
RUN;
QUIT;

/* Step 3: Generate outputs to evaluate the performance of the model. */
PROC SGPLOT data= s40840fp.univerisities;
    reg x=pub y=score / cli clm;
    title1 c=stb bcolor= LIGHTPINK Height=14pt "Regression of Score on Publications";
RUN;


