/* This do-file uses the US real GDP and performs a serie of detrending exercises.   */
/* The real GDP is at http://bea.gov/national/index.htm  -> Interactive tables  -> Table 1.1.6  */

clear all

/*We specify the directory to get the data.
IMPORTANT: this won't work as you as such (unless you have access to my computer), so you need to adjust this for the directory in which you put the data*/
cd "M:\BACKUP_IHEID\Work_files\Teaching\HEID_2023_2024_acad_year\Fall 2023 EI056 Macroeconomics A\Class_6_October_23_2023\Filtering_Stata"   
 
log using GDP_detrending.log, replace

use GDP_US.dta   /*This loads the US quarterly GDP from 1950 Q1 to 2023 Q2, contains one variable "GDP" which is the level of GDP */
gen LGDP=ln(GDP)   /*Generates the log GDP*/

/*We set things so that the computer treats the data as a quarterly times serie starting in 1950 Q 1 */
generate time=tq(1950q1)+_n-1
format time %tq
tsset time
        
/*We run a HP filter setting the smoothing parameter at 1600, which is the standard one */
tsfilter hp HP_cycle=LGDP, trend(HP_trend)
/*HP_trend is the estimated trend, and HP_cycle is the cycle (HP_cycle = LGP - HP_trend)  */

/*We run a linear trend. This can be done as a HP filter setting the smoothin parameter to be very large */
tsfilter hp LT_cycle=LGDP, trend(LT_trend) smooth(10000000000000)
/*LT_trend is the estimated linear trend, and LT_cycle is the cycle LT_cycle = LGP - LT_trend)  */

/*We run a Baxter-King filter that removes the high frequency (less than 6 periods) and low frequency (more than 32 periods) data*/		
tsfilter bk BK_cycle=LGDP, trend(BK_trend) minperiod(6) maxperiod(32)
/*BK_trend is the estimated trend, and BK_cycle is the cycle BK_cycle = LGP - BK_trend)  */		
		
/*We can contrast the various filters by plotting the spectral density. We save the graphs as pdf's */
pergram LT_cycle
graph export Spectral_LT.pdf, replace
pergram HP_cycle
graph export Spectral_HP.pdf, replace
pergram BK_cycle
graph export Spectral_BK.pdf, replace

/*We do some graphs with the trends*/
tsline LGDP, ttitle("Time")   /*The raw data*/
graph export LogGDP.pdf, replace
tsline LGDP LT_trend, ttitle("Time") legend(order(1 "log GDP" 2 "linear trend"))   /*The data and the linear trend*/
graph export GDP_LTtrend.pdf, replace
tsline LGDP HP_trend, ttitle("Time") legend(order(1 "log GDP" 2 "HP trend"))    /*The data and the HP trend*/
graph export GDP_HPtrend.pdf, replace
tsline HP_cycle LT_cycle, ttitle("Time") legend(order(1 "Cycle: HP filter" 2 "Cycle: linear trend"))    /*Cycles according to LT and HP*/
graph export HP_LTcycle.pdf, replace
tsline HP_cycle BK_cycle, ttitle("Time") legend(order(1 "Cycle: HP filter" 2 "Cycle: BK filter"))     /*Cycles according to LT and BK*/
graph export HP_BKcycle.pdf, replace

		
	

log close
