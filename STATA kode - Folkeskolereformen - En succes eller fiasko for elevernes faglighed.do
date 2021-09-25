** Gennemsnits karakter i folkeskolen **

clear

import excel "C:\Users\Bruger\Desktop\Opgave\Faglige_resultater_gennemsnit.xlsx", sheet("Ark2") firstrow
drop if Skoleår ==.

*Installere pakken reghdfe
ssc install ftools
ssc install reghdfe

* Laver dummy variabel, der indikere når treatment starter

gen post = (Skoleår>2014) & !missing(Skoleår)
gen reform_start_treat = 1 if treatment == 1 & Skoleår >=2015
recode reform_start_treat . = 0

* Stanardizere test score by Skoleår
egen karakter_mean = mean(karakter), by(Skoleår)
egen karakter_sd = sd(karakter), by(Skoleår)
gen karakter_std = (karakter-karakter_mean)/karakter_sd



*To skoler bliver fjernet grundet medtodiske overvejelser 
 drop if Institution == "10. klasse Gribskov og modtageklasser"
 drop if Institution == "10. klasseskolen"
 drop if Institution == "Ahlmann-Skolen"
 drop if Fag == "Fællesprøve i fysik/kemi, biologi og geografi"
 *Laver ID som Float variabel til hver skole:
egen id=group(Institution) 

*oversigt over output(karakter)
xtsum karakter, i(id)

*Ting med Simon
sort Institution Skoleår
drop if id==.


* Laver figur der viser den gennemsnitlige udvikling af karaktergennemsnit:

regress karakter i.Skoleår, cluster(Institution) //estimerer gennemsnit + CI henover år
margins, at(Skoleår=(2007(1)2020)) //overflytter resultater til margins
marginsplot, /// plotter resultaterne fra margins
ytitle("Skolernes karaktergennemsnit") xtitle(År) ///ændrer titlen på Y- og X-aksen
title("") ylab(,nogrid) // fjerner titel og vandrette streger

*Fixed effects og DD  
eststo clear
eststo model1: reg karakter reform_start_treat treatment post, cluster(Institution)
eststo model2: reghdfe karakter reform_start_treat treatment post, absorb(treatment id) cluster(Institution)
eststo model3: reghdfe karakter reform_start_treat treatment post, absorb(treatment id Skoleår) cluster(Institution)
esttab using tabel_samlet6.rtf, se  replace

*treatment post
*Fixed effects og DD --> STANDADISERET  
eststo clear
eststo model1: reg karakter_std reform_start_treat treatment post, cluster(Institution)
eststo model2: reghdfe karakter_std reform_start_treat treatment post, absorb(treatment id) cluster(Institution)
eststo model3: reghdfe karakter_std reform_start_treat treatment post, absorb(treatment id Skoleår) cluster(Institution)
esttab using tabel_samlet4.rtf, se  replace


*Kigger på common trends #FJERNER DATA

collapse (mean) karakter, by(Skoleår treatment)


twoway(connected karakter Skoleår if treatment==1) (connected karakter Skoleår if treatment==0), xline(2014.5)



clear

import excel "C:\Users\Bruger\Desktop\Opgave\Faglige_resultater_A.xlsx", sheet("Fysik-kemi") firstrow

*Installere pakken reghdfe
ssc install ftools
ssc install reghdfe

* Laver dummy variabel, der indikere når treatment starter

gen post = (Skoleår>2014) & !missing(Skoleår)
gen reform_start_treat = 1 if treatment == 1 & Skoleår >=2015
recode reform_start_treat . = 0

* Stanardizere test score by Skoleår
egen karakter_mean = mean(karakter), by(Skoleår)
egen karakter_sd = sd(karakter), by(Skoleår)
gen karakter_std = (karakter-karakter_mean)/karakter_sd

*To skoler bliver fjernet grundet medtodiske overvejelser 
 drop if Institution == "10. klasse Gribskov og modtageklasser"
 drop if Institution == "10. klasseskolen"
 drop if Institution == "Ahlmann-Skolen"
 drop if Fag == "Fællesprøve i fysik/kemi, biologi og geografi"
 


*Laver ID som Float variabel til hver skole:
egen id=group(Institution ) 

*oversigt over output(karakter)
xtsum karakter if Fag == "Dansk", i(id)
xtsum karakter if Fag == "Matematik", i(id)
xtsum karakter if Fag == "Engelsk", i(id)
xtsum karakter if Fag == "Fysik/kemi" "Fællesprøve i fysik/kemi, biologi og geografi", i(id)
xtsum karakter, i(id)
*Ting med Simon
sort Institution Skoleår
drop if id==.
*by Institution: egen Faggennemsnit =mean(karakter)
by Institution Skoleår: egen Faggennemsnit =mean(karakter)

*xtline karakter, ///xtline og den afhængige variabel
*i(id) t(Skoleår) /// specificerer enheds- og tids-variablene
*overlay ///alle linjer i én figur
*legend(off) ///slår legend fra
*xlabel(2007(1)2020) ///bestiller labels fra 2005 til 2011 på x-aksen
*ylabel(,nogrid) //slår vandrette streger fra

* Laver figur der viser den gennemsnitlige udvikling af karaktergennemsnit:

regress karakter i.Skoleår if Fag == "Dansk", cluster(Institution) //estimerer gennemsnit + CI henover år
margins, at(Skoleår=(2007(1)2020)) //overflytter resultater til margins
marginsplot, /// plotter resultaterne fra margins
ytitle("Skolernes karaktergennemsnit i Dansk") xtitle(År) ///ændrer titlen på Y- og X-aksen
title("") ylab(,nogrid) // fjerner titel og vandrette streger

regress karakter i.Skoleår if Fag == "Matematik", cluster(Institution) //estimerer gennemsnit + CI henover år
margins, at(Skoleår=(2007(1)2020)) //overflytter resultater til margins
marginsplot, /// plotter resultaterne fra margins
ytitle("Skolernes karaktergennemsnit i Matematik") xtitle(År) ///ændrer titlen på Y- og X-aksen
title("") ylab(,nogrid) // fjerner titel og vandrette streger

regress karakter i.Skoleår if Fag == "Engelsk", cluster(Institution) //estimerer gennemsnit + CI henover år
margins, at(Skoleår=(2007(1)2020)) //overflytter resultater til margins
marginsplot, /// plotter resultaterne fra margins
ytitle("Skolernes karaktergennemsnit i Engelsk") xtitle(År) ///ændrer titlen på Y- og X-aksen
title("") ylab(,nogrid) // fjerner titel og vandrette streger

regress karakter i.Skoleår if Fag == "Fysik/kemi", cluster(Institution) //estimerer gennemsnit + CI henover år
margins, at(Skoleår=(2007(1)2016)) //overflytter resultater til margins
marginsplot, /// plotter resultaterne fra margins
ytitle("Skolernes karaktergennemsnit i Fysik/kemi") xtitle(År) ///ændrer titlen på Y- og X-aksen
title("") ylab(,nogrid) // fjerner titel og vandrette streger



* DD analyse med klyngerobuste standarfejl
putdocx begin
reg karakter treatment##ib2014.Skoleår, cluster(Institution)
putdocx table Table1=etable
putdocx save reform_matematik

*Fixed effects og DD  Dansk
eststo clear
eststo model1: reg karakter reform_start_treat treatment post if Fag == "Dansk", cluster(Institution)
eststo model2: reghdfe karakter reform_start_treat treatment post if Fag == "Dansk", absorb(id) cluster(Institution)
eststo model3: reghdfe karakter reform_start_treat treatment post if Fag == "Dansk", absorb(id Skoleår) cluster(Institution)
esttab using tabel_dansk.rtf, se  replace

*Fixed effects og DD  Matematik
eststo clear
eststo model1: reg karakter reform_start_treat treatment post if Fag == "Matematik", cluster(Institution)
eststo model2: reghdfe karakter reform_start_treat treatment post if Fag == "Matematik", absorb(treatment id) cluster(Institution)
eststo model3: reghdfe karakter reform_start_treat treatment post if Fag == "Matematik", absorb(treatment id Skoleår) cluster(Institution)
esttab using tabel_matematik2.rtf, se  replace

*Fixed effects og DD  Engelsk
eststo clear
eststo model1: reg karakter reform_start_treat treatment post if Fag == "Engelsk", cluster(Institution)
eststo model2: reghdfe karakter reform_start_treat treatment post if Fag == "Engelsk", absorb(id) cluster(Institution)
eststo model3: reghdfe karakter reform_start_treat treatment post if Fag == "Engelsk", absorb(id Skoleår) cluster(Institution)
esttab using tabel_engelsk.rtf, se  replace

*Fixed effects og DD  Fysik/kemi
eststo clear
eststo model1: reg karakter reform_start_treat treatment post if Fag == "Fysik/kemi", cluster(Institution)
eststo model2: reghdfe karakter reform_start_treat treatment post if Fag == "Fysik/kemi", absorb(id) cluster(Institution)
eststo model3: reghdfe karakter reform_start_treat treatment post if Fag == "Fysik/kemi", absorb(id Skoleår) cluster(Institution)
esttab using tabel_FysikKemi.rtf, se  replace

* Fixed effects og DD ---- SAMLET

eststo clear
eststo model1: reg Faggennemsnit reform_start_treat treatment post if Fag == "Dansk", cluster(Institution)
eststo model3: reghdfe Faggennemsnit reform_start_treat treatment post if Fag == "Dansk", absorb(id) cluster(Institution)
eststo model3: reghdfe Faggennemsnit reform_start_treat treatment post if Fag == "Dansk", absorb(id Skoleår) cluster(Institution)
eststo model4: reghdfe Faggennemsnit reform_start_treat treatment post if Fag == "Dansk", absorb(id Skoleår Fag) cluster(Institution)
esttab using tabel_samlet5.rtf, se  replace



collapse Institution, by(Faggennemsnit, treatment, post, reform_start_treat, id)


* Fixed effects og DD Standadiseret karakter

eststo clear
eststo model1: reg karakter_std reform_start_treat treatment post, cluster(Institution)
eststo model2: reghdfe karakter_std reform_start_treat treatment post, absorb(id) cluster(Institution)
eststo model3: reghdfe karakter_std reform_start_treat treatment post, absorb(id Skoleår) cluster(Institution)
eststo model4: reghdfe karakter_std reform_start_treat treatment post, absorb(id Skoleår Fag) cluster(Institution)
esttab using tabel_std.rtf, se  replace



*Kigger på common trends #FJERNER DATA

collapse (mean) karakter, by(Skoleår treatment)


twoway(connected karakter Skoleår if treatment==1) (connected karakter Skoleår if treatment==0), xline(2014.5)


* Følgende kode bruges i diskussionen *

clear

import excel "C:\Users\Bruger\Desktop\Opgave\Karaktergennemsnit - mundtlig og skriflig matematik.xlsx", sheet("Ark4") firstrow

*Installere pakken reghdfe
ssc install ftools
ssc install reghdfe


* Laver dummy variabel, der indikere når treatment starter

gen post = (Skoleår>2014) & !missing(Skoleår)
gen reform_start_treat = 1 if treatment == 1 & Skoleår >=2015
recode reform_start_treat . = 0

*To skoler bliver fjernet grundet medtodiske overvejelser 
 drop if Institution == "10. klasse Gribskov og modtageklasser"
 drop if Institution == "10. klasseskolen"
 drop if Institution == "Ahlmann-Skolen"
 

 
 *Laver ID som Float variabel til hver skole:
egen id=group(Institution)

 *Ting med Simon
sort Institution Skoleår
drop if id==.

*oversigt over output(karakter)
xtsum karakter if Fag == "Skriftlig", i(id)
xtsum karakter if Fag == "Mundtlig", i(id)

*Fixed effects og DD  Skriflig
eststo clear
eststo model1: reg karakter reform_start_treat treatment post if Fag == "Skriftlig", cluster(Institution)
eststo model2: reghdfe karakter reform_start_treat treatment post if Fag == "Skriftlig", absorb(id) cluster(Institution)
eststo model3: reghdfe karakter reform_start_treat treatment post if Fag == "Skriftlig", absorb(id Skoleår) cluster(Institution)
esttab using Skriflig.rtf, se  replace

*Fixed effects og DD  Matematik
eststo clear
eststo model1: reg karakter reform_start_treat treatment post if Fag == "Mundtlig", cluster(Institution)
eststo model2: reghdfe karakter reform_start_treat treatment post if Fag == "Mundtlig", absorb(treatment id) cluster(Institution)
eststo model3: reghdfe karakter reform_start_treat treatment post if Fag == "Mundtlig", absorb(treatment id Skoleår) cluster(Institution)
esttab using tabel_Mundtlig.rtf, se  replace


clear

import excel "C:\Users\Bruger\Desktop\Opgave\Karaktergennemsnit - mundtlig og skriflig matematik.xlsx", sheet("Skriftlig") firstrow

*Installere pakken reghdfe
ssc install ftools
ssc install reghdfe


* Laver dummy variabel, der indikere når treatment starter

gen post = (Skoleår>2014) & !missing(Skoleår)
gen reform_start_treat = 1 if treatment == 1 & Skoleår >=2015
recode reform_start_treat . = 0

*To skoler bliver fjernet grundet medtodiske overvejelser 
 drop if Institution == "10. klasse Gribskov og modtageklasser"
 drop if Institution == "10. klasseskolen"
 drop if Institution == "Ahlmann-Skolen"
 

 
 *Laver ID som Float variabel til hver skole:
egen id=group(Institution)

 *Ting med Simon
sort Institution Skoleår
drop if id==.

*oversigt over output(karakter)
xtsum karakter, i(id)


*Fixed effects og DD  Skriflig
eststo clear
eststo model1: reg karakter reform_start_treat treatment, cluster(Institution)
eststo model2: reghdfe karakter reform_start_treat treatment post, absorb(id) cluster(Institution)
eststo model3: reghdfe karakter reform_start_treat treatment post, absorb(id Skoleår) cluster(Institution)
esttab using Skriflig.rtf, se  replace

* Laver figur der viser den gennemsnitlige udvikling af karaktergennemsnit:
regress karakter ib(2014).Skoleår if treatment == 1 , cluster(Institution)

regress karakter i.Skoleår if treatment == 1 , cluster(Institution) //estimerer gennemsnit + CI henover år
margins, at(Skoleår=(2007(1)2020)) //overflytter resultater til margins
marginsplot, /// plotter resultaterne fra margins
ytitle("Skolernes karaktergennemsnit skriftlig matematik") xtitle(År) ///ændrer titlen på Y- og X-aksen
title("") ylab(,nogrid) // fjerner titel og vandrette streger

***Med og uden hjælpemidler
clear
import excel "C:\Users\Bruger\Desktop\Opgave\Karaktergennemsnit - mundtlig og skriflig matematik.xlsx", sheet("MedUden") firstrow

twoway(connected karakter Skoleår if Fag==1) (connected karakter Skoleår if Fag==0), xline(2014.5)
 