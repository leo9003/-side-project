clear

cd "/Users/coco/Desktop/台大計量/stata"
log using "analyze.log", replace

use "inc108.dta"
append using "inc109.dta"
append using "inc110.dta"
append using "inc111.dta"
append using "inc112.dta"

keep id a5 a6 a7 a11 itm211 year

codebook itm211

duplicates drop

duplicates list

encode id, gen(idd)

tab a11

rename a5 job
tabulate job
tabulate job, gen(job_dummy)

rename a6 age
tabulate age

rename a7 gender
tabulate gender,gen (gender_dummy)

rename a11 edu
tabulate edu
recode edu (1/6 = 1) (7/8 = 2) (9/10 = 3)
label define edu_labels 1 "高中(含高中及五專前三年)以下" 2 "大學" 3 "研究所以上"
label values edu edu_labels
tabulate edu, gen (edu_dummy)

drop if missing(itm211)
generate ln_income = log(itm211)
describe ln_income

summarize

graph twoway (lfitci ln_income age) ///
(scatter ln_income age) ///
, title("本業薪資與年齡的關係") ///
ytitle("ln_income") ///
xtitle("age") ///
legend(ring(0) order(2 "linear fit" 1 "95% CI"))

histogram ln_income, ///
title("本業薪資的機率分配") ///
xtitle("income(%)") ///
ytitle("fequency", margin(medium)) ///
xlabel(11(1)16) ///
ylabel(0(0.1)1)

regress ln_income age

regress ln_income age gender_dummy1 edu_dummy2-edu_dummy3 job_dummy1-job_dummy12

xtset idd year

ssc install ftools
ssc install reghdfe

which ftools
which reghdfe

reghdfe ln_income age gender_dummy1 edu_dummy2-edu_dummy3 job_dummy1-job_dummy12, absorb(idd year) 

log close
