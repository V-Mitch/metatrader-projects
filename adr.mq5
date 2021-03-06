//+------------------------------------------------------------------+
//|                                                          adr.mq5 |
//|                                                           Victor |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Victor"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include<Trade\Trade.mqh>
#include<Math\Stat\Normal.mqh>

CTrade trade;
input ENUM_TIMEFRAMES Timeframe = PERIOD_D1;
input int ADR_Period= 100;
input int NC_Period = 30;
input int top_dist = 40;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   return(INIT_SUCCEEDED);
  }
//---

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//|TIME FUNCTIONS                                                    |
//+------------------------------------------------------------------+
/*
bool newBar;
int barstemp=0;
void start()
{
    if(barstemp!=Bars)
    {
         barstemp = Bars;  
         newBar = true
    }
}
  */
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick()  
  {
//---
// Create Variables
//Range
   double S = 0; // sum
   double D = 0; // square of difference with mean
   double M = 0; // mean
   double Md= 0; // median
//Net Change
   double S1 = 0; // sum
   double D1 = 0; // square of difference with mean
   double M1 = 0; // mean
   double Md1= 0; // median
                  // Create arrays
   double High[],Low[],Range[],Open[],Close[],NetChange[];
//DailyRanges[],
//sort Arrays downwards
//ArraySetAsSeries(DailyRanges,true);
   ArraySetAsSeries(High,true);
   ArraySetAsSeries(Low,true);
   ArraySetAsSeries(Open,true);
   ArraySetAsSeries(Close,true);
//Fill arrays with data for x candles
   CopyHigh(_Symbol,Timeframe,0,ADR_Period,High);
   CopyLow(_Symbol,Timeframe,0,ADR_Period,Low);
   CopyOpen(_Symbol,Timeframe,0,NC_Period,Open);
   CopyClose(_Symbol,Timeframe,0,NC_Period,Close);
// make range the right size. 0 to ADR_Period - 1
   ArrayResize(Range,ADR_Period);
   ArrayResize(NetChange,NC_Period);

// loop that calculates the Range of each day, the Sum, Mean, Squared Difference with the Mean.
   for(int i=0; i<ArraySize(Range); i++)
     {
      Range[i]=High[i]-Low[i];
      S = S + Range[i];
      M = S/ADR_Period;
      D = D + MathPow((Range[i] - M),2);
     }

   for(int j=0; j<ArraySize(NetChange); j++)
     {
      NetChange[j]=Close[j]-Open[j];
      S1 = S1 + NetChange[j];
      M1 = S1/NC_Period;
      D1 = D1 + MathPow((NetChange[j] - M1),2);
     }
//Sort the ranges from smallest to Largest
   ArraySort(Range);
   ArraySort(NetChange);

// Calculation of the values
//Range
   double averageRange= S/ADR_Period;
   double stddevRange = MathSqrt(D)/(ADR_Period-1);
   double medianRange = High[(ADR_Period/2)-1] - Low[(ADR_Period/2)-1];
//Net Change
   double averageNetChange= S1/NC_Period;
   double stddevNetChange = MathSqrt(D1)/(NC_Period-1);
   double medianNetChange = Open[(NC_Period/2)-1] - Close[(NC_Period/2)-1];


//+------------------------------------------------------------------+
//|TRADE RULES AND EXECUTION                                         |
//+------------------------------------------------------------------+


double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits); // ask price
double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits); // bid 

MqlRates PriceInformation[]; // create price array

ArraySetAsSeries(PriceInformation,true); // sorting from current to oldest candle

int Data = CopyRates(Symbol(),Period(),0,Bars(Symbol(),Timeframe),PriceInformation); // Copy price data into the array

double openPrice = PriceInformation[0].open; // get open price

int nthDay = MathRound(NC_Period/3); //in the sorted array of bars, get a certain threshhold for buy criteria
int nthDay2 = MathRound((NC_Period/3)*2); //in the sorted array of bars, get a certain threshhold for sell criteria


/*int error_code1,error_code2;7
double quantile = MathQuantileNormal(0.975,averageRange,stddevRange,error_code1);
Print(quantile);*/

// if no open orders
if ((OrdersTotal()==0)&&(PositionsTotal()==0)) 
   // 66% of days fall above 10 pips (the array is sorted from smallest to largest)
      if (NetChange[nthDay] > 1*_Point)
   // price falls to an expected low:
         if (Ask < openPrice - 0.8 * averageRange)
            {
               trade.Buy(0.10,NULL,Ask,(Bid-(0.3*averageRange)),(Ask+(0.6*averageRange)),NULL); //Buy( volume,symbol=NULL,double price=0.0, sl=0.0, tp=0.0,comment="");
            }
         
// if no open orders
if ((OrdersTotal()==0)&&(PositionsTotal()==0)) 
   // 66% of days fall below -10 pips (the array is sorted from smallest to largest)
      if (NetChange[nthDay2] < -1*_Point)
   // price falls to an expected high:
         if (Bid > openPrice + 0.8 * averageRange)
            {
               trade.Sell(0.10,NULL,Bid,(Ask+(0.3*averageRange)),(Bid-(0.6*averageRange)),NULL); //Sell( volume,symbol=NULL,double price=0.0, sl=0.0, tp=0.0,comment="");
            }
//+------------------------------------------------------------------+
//|INFORMATION TEXT                                                  |
//+------------------------------------------------------------------+
//Create the Text for Information

   string font="Lucida Console";

//Range
   string displayedaverageRange= DoubleToString(NormalizeDouble(averageRange*10000,1),1);
   string displayedmedianRange = DoubleToString(NormalizeDouble(medianRange*10000,1),1);
   string displayedstddevRange = DoubleToString(NormalizeDouble(stddevRange*10000,1),1);
   string stringADR=DoubleToString(ADR_Period,0);
// Average Daily Range Number of Days
   ObjectCreate(0,"L1",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"L1",OBJPROP_FONT,font);
   ObjectSetInteger(0,"L1",OBJPROP_FONTSIZE,9);
   ObjectSetInteger(0,"L1",OBJPROP_COLOR,clrDodgerBlue);
   ObjectSetString(0,"L1",OBJPROP_TEXT,0," Range Sample: "+stringADR);
   ObjectSetInteger(0,"L1",OBJPROP_XDISTANCE,5);
   ObjectSetInteger(0,"L1",OBJPROP_YDISTANCE,top_dist+30);
// Average Daily Range
   ObjectCreate(0,"L2",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"L2",OBJPROP_FONT,font);
   ObjectSetInteger(0,"L2",OBJPROP_FONTSIZE,9);
   ObjectSetInteger(0,"L2",OBJPROP_COLOR,clrDodgerBlue);
   ObjectSetString(0,"L2",OBJPROP_TEXT,0," Mean: "+displayedaverageRange);
   ObjectSetInteger(0,"L2",OBJPROP_XDISTANCE,5);
   ObjectSetInteger(0,"L2",OBJPROP_YDISTANCE,top_dist+60);
// Range Median
   ObjectCreate(0,"L3",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"L3",OBJPROP_FONT,font);
   ObjectSetInteger(0,"L3",OBJPROP_FONTSIZE,9);
   ObjectSetInteger(0,"L3",OBJPROP_COLOR,clrDodgerBlue);
   ObjectSetString(0,"L3",OBJPROP_TEXT,0," Median: "+displayedmedianRange);
   ObjectSetInteger(0,"L3",OBJPROP_XDISTANCE,5);
   ObjectSetInteger(0,"L3",OBJPROP_YDISTANCE,top_dist+90);
// Range Standard Deviation
   ObjectCreate(0,"L4",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"L4",OBJPROP_FONT,font);
   ObjectSetInteger(0,"L4",OBJPROP_FONTSIZE,9);
   ObjectSetInteger(0,"L4",OBJPROP_COLOR,clrDodgerBlue);
   ObjectSetString(0,"L4",OBJPROP_TEXT,0," Sdev: "+displayedstddevRange);
   ObjectSetInteger(0,"L4",OBJPROP_XDISTANCE,5);
   ObjectSetInteger(0,"L4",OBJPROP_YDISTANCE,top_dist+120);

//Net Change
   string displayedaverageNetChange= DoubleToString(NormalizeDouble(averageNetChange*10000,1),1);
   string displayedmedianNetChange = DoubleToString(NormalizeDouble(medianNetChange*10000,1),1);
   string displayedstddevNetChange = DoubleToString(NormalizeDouble(stddevNetChange*10000,1),1);
   string stringNC=DoubleToString(NC_Period,0);
// Net Change Number of Days
   ObjectCreate(0,"L5",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"L5",OBJPROP_FONT,font);
   ObjectSetInteger(0,"L5",OBJPROP_FONTSIZE,9);
   ObjectSetInteger(0,"L5",OBJPROP_COLOR,clrFireBrick);
   ObjectSetString(0,"L5",OBJPROP_TEXT,0," Net Change Sample: "+stringNC);
   ObjectSetInteger(0,"L5",OBJPROP_XDISTANCE,5);
   ObjectSetInteger(0,"L5",OBJPROP_YDISTANCE,top_dist+150);
// Net Change Range
   ObjectCreate(0,"L6",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"L6",OBJPROP_FONT,font);
   ObjectSetInteger(0,"L6",OBJPROP_FONTSIZE,9);
   ObjectSetInteger(0,"L6",OBJPROP_COLOR,clrFireBrick);
   ObjectSetString(0,"L6",OBJPROP_TEXT,0," Mean "+displayedaverageNetChange);
   ObjectSetInteger(0,"L6",OBJPROP_XDISTANCE,5);
   ObjectSetInteger(0,"L6",OBJPROP_YDISTANCE,top_dist+180);
// Net Change Median
   ObjectCreate(0,"L7",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"L7",OBJPROP_FONT,font);
   ObjectSetInteger(0,"L7",OBJPROP_FONTSIZE,9);
   ObjectSetInteger(0,"L7",OBJPROP_COLOR,clrFireBrick);
   ObjectSetString(0,"L7",OBJPROP_TEXT,0," Median: "+displayedmedianNetChange);
   ObjectSetInteger(0,"L7",OBJPROP_XDISTANCE,5);
   ObjectSetInteger(0,"L7",OBJPROP_YDISTANCE,top_dist+210);
// Net Change Standard Deviation
   ObjectCreate(0,"L8",OBJ_LABEL,0,0,0);
   ObjectSetString(0,"L8",OBJPROP_FONT,font);
   ObjectSetInteger(0,"L8",OBJPROP_FONTSIZE,9);
   ObjectSetInteger(0,"L8",OBJPROP_COLOR,clrFireBrick);
   ObjectSetString(0,"L8",OBJPROP_TEXT,0," Sdev: "+displayedstddevNetChange);
   ObjectSetInteger(0,"L8",OBJPROP_XDISTANCE,5);
   ObjectSetInteger(0,"L8",OBJPROP_YDISTANCE,top_dist+240);

//+------------------------------------------------------------------+
//|PRINTING INFORMATION FOR RESEARCH                                 |
//+------------------------------------------------------------------+
  
//Show array in the log

//   ArrayPrint(NetChange,5,NULL,0,WHOLE_ARRAY);
  
  
  
//+------------------------------------------------------------------+


  }
  
  
