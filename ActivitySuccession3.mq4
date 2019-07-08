//+------------------------------------------------------------------+
//|                                                      MA_Vic1.mq4 |
//|                                                  Victor Mitchell |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Victor Mitchell"          
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//|Paramaters that can be changed  to Optimize EA!                   |
//+------------------------------------------------------------------+

extern string Testing                  = "Control speed of the chart speed when using strategy tester in visual mode";
extern int speed                       = 500;

extern string info1                    = "Use these parameters to modify your money management";
extern int Takeprofit                  = 50;
extern int Stoploss                    = 25;
extern double Lotsize                  = 0.01;
extern int Slippage                    = 3;
extern int MagicNumber                 =1234;

extern string info2                    = "Use these parameters to modify your Breakeven function";
extern bool UseMoveToBreakeven         =true;
extern int WhenToMoveToBE              =100;
extern int PipsToLockIn                =5;

extern string info3                    = "Use these parameters to modify your Trailing Stop function";
extern bool UseTrailingStop            =false;
extern int WhenToTrail                 =100;
extern int TrailAmount                 =50;

extern string info4                    = "Number of increasing volume bars you would like to have in a row. Pick a number between 2 and 8";
extern int ActivitySuccession          =4;

extern string info5                    = "Candle 1 should have the highest volume since _ number of candles";
extern bool UsePreviousDayVolume       =false;
extern int NumberOfVolumesAgo          =24;

extern string info6                    = "Candle 1 should be the highest/lowest point since _ number of candles";
extern bool UsePreviousHighLow         =false;
extern int NumberOfCandlesAgo          =24;

extern string info7                    = "A pinbar is required for the trade to take place / How much larger than the body should it be";
extern bool PinBarRequired             = false;
extern double TimesBiggerThanTheBody   = 2;

extern string info8                    = "The number of pips there must be between the ActivitySuccession candles";
extern int PipDifference               =100;

extern string info9                    = "Only take buy trades in bullish trend / only take sell trades in bearish trend";
extern bool UseTrendDetector           = true;
extern int MAPeriod                    =200;
extern int MAType                      =1;

extern string info10                   = "Only take the trade if you are within this range of a psychological level";
extern bool UsePsychLevels             = false;
extern double upperlowerlimit          =0.001;

extern string info11                   = "Place the stoploss X number of pips above/below the previous candle";
extern bool UseSmartSL                 = false;
   
extern string info12                   = "Days of the week to trade";
extern bool Monday                     =1;
extern bool Tuesday                    =1;
extern bool Wednesday                  =1;
extern bool Thursday                   =1;
extern bool Friday                     =1;
extern bool Saturday                   =1;
extern bool Sunday                     =1;

extern string info13                   = "Hours of the day to trade (between 0 and 23)";
extern int StartHour                   =0;
extern int EndHour                     =23;
double pips;

extern string info14                   = "Only consider certain days of the month? 0 is Sunday, 6 is Saturday // days before MonthDay day are considered";
extern bool UseDayOfMonth              = false;
extern int WeekDay                     = 5;
extern int MonthDay                    = 7;
//+------------------------------------------------------------------+
//| Expert initialization function. Size correction so that decimals |
//| do not have to be used in the inputs                             |
//+------------------------------------------------------------------+

int OnInit()
  {
//---
   double ticksize=MarketInfo(Symbol(),MODE_TICKSIZE);
   if(ticksize==0.00001 || ticksize==0.001)
      pips=ticksize*10;
   else pips=ticksize;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+

void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//|Expert tick function. New trade or move to break even decision.   |
//|"Master function"                                                 |
//+------------------------------------------------------------------+

int start()
  {

// Solely to control the speed in the Strategy Tester   
   if(IsVisualMode()==true)
     {
      int Waitloop=0;
      while(Waitloop<speed){Comment("Wait Loop Count = ",Waitloop); Waitloop++;}
     }

// Conditions to take the trade: Use BE?, TS? Is it the right time to trade?      
   if(OpenOrdersThisPair(Symbol())>=1)
     {
      if(UseMoveToBreakeven)MoveToBreakeven();
      if(UseTrailingStop)AdjustTrail();
     }
   if(ValidDay()==true)
   if(ValidHour()==true)
   if(ValidDayOfMonth()==true)
   // Extra conditions related to more technical aspects.  
   if(PreviousVolumeCheck()==true)
   if(PreviousHighLowCheck()==true)
   if(CheckForPsychLevel()==true)
   // Take the trade! Includes: Activity Succession and PinBar.  
   if(IsNewCandle())CheckForVolumesTrade();
   return(0);
  }
//+------------------------------------------------------------------+
//| Function checking the conditions for breakeven and then          |
//| taking the necessary measures to put it in place for both buy    |
//| and sell. The for loop begins by reducing 1 from the total number|
//| of orders and calling this B. As long as B is larger or equal to |
//| 0, B will be decreased by 1 everytime the loop is executed. The  |
//| OrderSelect function is then used to select each of these orders |
//| and verifies the magic number is the same (if it is not the case |
//| the function is terminated). The EA then verifies whether or not |
//| it is the right currency pair and the right order direction.     |
//| The calculations for the BE will be different depending on the   |
//| direction that is taken. The OrderModify function is finally used| 
//| in order to change the variables.                                |
//+------------------------------------------------------------------+

void MoveToBreakeven()
  {

   for(int B=OrdersTotal()-1; B>=0; B--)
     {
      if(OrderSelect(B,SELECT_BY_POS,MODE_TRADES))
         if(OrderMagicNumber()==MagicNumber);
      else return;
      if(OrderSymbol()==Symbol())
         if(OrderType()==OP_BUY)
            if(Bid-OrderOpenPrice()>WhenToMoveToBE*pips)
               if(OrderOpenPrice()>OrderStopLoss())
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+(PipsToLockIn*pips),OrderTakeProfit(),0,Blue))
                     Print("Pips locked in on the long trade");
     }

   for(int S=OrdersTotal()-1; S>=0; S--)
     {
      if(OrderSelect(S,SELECT_BY_POS,MODE_TRADES))
         if(OrderMagicNumber()==MagicNumber);
      else return;
      if(OrderSymbol()==Symbol())
         if(OrderType()==OP_SELL)
            if(OrderOpenPrice()-Ask>WhenToMoveToBE*pips)
               if(OrderOpenPrice()<OrderStopLoss())
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-(PipsToLockIn*pips),OrderTakeProfit(),0,Blue))
                     Print("Pips locked in on the short trade");
     }
  }
//+------------------------------------------------------------------+
//| Trailing stop functions                                          |
//+------------------------------------------------------------------+

void AdjustTrail()
  {

   for(int B=OrdersTotal()-1;B>=0;B--) // 1. This is how it starts 2. As long as this is the case 3. This will keep happening
     {
      if(OrderSelect(B,SELECT_BY_POS,MODE_TRADES))
         if(OrderMagicNumber()==MagicNumber);
      else return;
      if(OrderSymbol()==Symbol())
         if(OrderType()==OP_BUY)
            if(Bid-OrderOpenPrice()>WhenToTrail*pips)
               if(OrderStopLoss()<Bid-pips*TrailAmount)
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),Bid-(pips*TrailAmount),OrderTakeProfit(),0,Purple))
                     Print("Trail stop changed the Stop Loss up.");
     }

   for(int S=OrdersTotal()-1;S>=0;S--)
     {
      if(OrderSelect(S,SELECT_BY_POS,MODE_TRADES))
         if(OrderMagicNumber()==MagicNumber);
      else return;
      if(OrderSymbol()==Symbol())
         if(OrderType()==OP_SELL)
            if(OrderOpenPrice()-Ask>WhenToTrail*pips)
               if(OrderStopLoss()>Ask+pips*TrailAmount || OrderStopLoss()==0) // special condition if stop loss is 0 on the sell side. This is so the trailing stop can be created
                  if(OrderModify(OrderTicket(),OrderOpenPrice(),Ask+(pips*TrailAmount),OrderTakeProfit(),0,Purple))
                     Print("Trail stop changed the Stop Loss down.");
     }
  }
//+------------------------------------------------------------------+
//|This function is here to make sure the EA only checks if          |
//|conditions are met after every candle rather than on every single |
//|tick.                                                             |
//+------------------------------------------------------------------+

bool IsNewCandle()
  {
   static int BarsOnChart=0;     // static means it is only initialized once
   if(Bars==BarsOnChart)
      return(false);
   BarsOnChart=Bars;
   return(true);


  }
//+------------------------------------------------------------------+
//|This function checks the volumes                                  |         
//|it returns 0 or 1 depending on whether a buy or                   |
//|sell is necessary                                                 |
//|Every case presents a situation with an additional candle in which|
//|the activity has increased                                        |
//|Also includes the PinBar function: the trade is only taken if     |
//|the correct pinbar is identified for a buy or sell trade.         |
//|Price Action: Bin bar: Pin is large than body                     |
//|This function simply checks whether or not the "nose" of the      |
//|candlestick is large enough for a trade to take place.            |
//|A white body is an up candlestick and a black body is a down one. |
//+------------------------------------------------------------------+
void CheckForVolumesTrade()
  {
// variables to check the volume
   double firstclose= Close[1];
   double lastclose = Close[ActivitySuccession];
// variables for the pin   
   bool BuyPinExists = false;
   bool SellPinExists = false;
   double whitebody = Close[1]-Open[1];
   double blackbody = Open[1]-Close[1];         
   double bottompinofwhitebody = Open[1]-Low[1];
   double bottompinofblackbody = Close[1]-Low[1];
   double toppinofwhitebody = High[1]-Close[1];
   double toppinofblackbody = High[1]-Open[1];
// variables for the trend
   bool UpTrend = false;
   bool DownTrend = false;
   double PresentValueofMA = iMA(NULL,0,MAPeriod,0,MAType,0,1);
   double PreviousValueofMA = iMA(NULL,0,MAPeriod,0,MAType,0,2);
      
   
   if(PinBarRequired)        
               { 
        BuyPinExists = false;
        SellPinExists = false;                   
         // Buying Pinbars
                 if(Close[1]>Open[1])
                  {
                     if(bottompinofwhitebody >= TimesBiggerThanTheBody*whitebody)
                        if(bottompinofwhitebody >= toppinofwhitebody)
                           BuyPinExists = true;
                              else BuyPinExists = false;                                                  
                  }
                 if(Open[1]>Close[1])
                  {
                     if(bottompinofblackbody >= TimesBiggerThanTheBody*blackbody)
                        if(bottompinofblackbody >= toppinofblackbody)
                           BuyPinExists = true;
                              else BuyPinExists = false;                         
                  }
            // Selling Pinbars               
                 if(Close[1]>Open[1])
                  {
                     if(toppinofwhitebody >= TimesBiggerThanTheBody*whitebody)
                        if(toppinofwhitebody >= bottompinofwhitebody)
                           SellPinExists = true;
                              else SellPinExists = false;                        
                  }
                 if(Open[1]>Close[1])
                  {
                     if(toppinofblackbody >= TimesBiggerThanTheBody*blackbody)
                        if(toppinofblackbody >= bottompinofblackbody)
                           SellPinExists = true;
                              else SellPinExists = false;                        
                  }
               }
      else
         {
         SellPinExists = true;
         BuyPinExists = true;
         }


   if(UseTrendDetector)
      {
         //Uptrend Scenario
            if(PresentValueofMA>PreviousValueofMA)
               UpTrend = true;
         //Downtrend Scenario
            if(PresentValueofMA<PreviousValueofMA)
               DownTrend = true;
      }
      else
         {
         UpTrend = true;
         DownTrend = true;
         }
                 
      switch(ActivitySuccession) // Case number refers to the number of successive volume bars that have to be larger than the previous.
     {
      case 2:
         if(firstclose-lastclose >= PipDifference*pips && Volume[1]>Volume[2] && (SellPinExists==true) && (DownTrend==true))OrderEntry(1);
         if(lastclose-firstclose >= PipDifference*pips && Volume[1]>Volume[2] && (BuyPinExists==true) && (UpTrend==true))OrderEntry(0);break;
      case 3:
         if(firstclose-lastclose >= PipDifference*pips && Volume[1]>Volume[2] && Volume[2]>Volume[3] && (SellPinExists==true) && (DownTrend==true))OrderEntry(1);
         if(lastclose-firstclose >= PipDifference*pips && Volume[1]>Volume[2] && Volume[2]>Volume[3] && (BuyPinExists==true) && (UpTrend==true))OrderEntry(0);break;
      case 4:
         if(firstclose-lastclose >= PipDifference*pips && Volume[1]>Volume[2] && Volume[2]>Volume[3] && Volume[3]>Volume[4] && (SellPinExists==true) && (DownTrend==true))OrderEntry(1);
         if(lastclose-firstclose >= PipDifference*pips && Volume[1]>Volume[2] && Volume[2]>Volume[3] && Volume[3]>Volume[4] && (BuyPinExists==true) && (UpTrend==true))OrderEntry(0);break;
      case 5:
         if(firstclose-lastclose >= PipDifference*pips && Volume[1]>Volume[2] && Volume[2]>Volume[3] && Volume[3]>Volume[4] && Volume[4]>Volume[5] && (SellPinExists==true) && (DownTrend==true))OrderEntry(1);
         if(lastclose-firstclose >= PipDifference*pips && Volume[1]>Volume[2] && Volume[2]>Volume[3] && Volume[3]>Volume[4] && Volume[4]>Volume[5] && (BuyPinExists==true) && (UpTrend==true))OrderEntry(0);break;
      case 6:
         if(firstclose-lastclose >= PipDifference*pips && Volume[1]>Volume[2] && Volume[2]>Volume[3] && Volume[3]>Volume[4] && Volume[4]>Volume[5] && Volume[5]>Volume[6] && (SellPinExists==true) && (DownTrend==true))OrderEntry(1);
         if(lastclose-firstclose >= PipDifference*pips && Volume[1]>Volume[2] && Volume[2]>Volume[3] && Volume[3]>Volume[4] && Volume[4]>Volume[5] && Volume[5]>Volume[6] && (BuyPinExists==true) && (UpTrend==true))OrderEntry(0);break;
      case 7:
         if(firstclose-lastclose >= PipDifference*pips && Volume[1]>Volume[2] && Volume[2]>Volume[3] && Volume[3]>Volume[4] && Volume[4]>Volume[5] && Volume[5]>Volume[6] && Volume[6]>Volume[7] && (SellPinExists==true) && (DownTrend==true))OrderEntry(1);
         if(lastclose-firstclose >= PipDifference*pips && Volume[1]>Volume[2] && Volume[2]>Volume[3] && Volume[3]>Volume[4] && Volume[4]>Volume[5] && Volume[5]>Volume[6] && Volume[6]>Volume[7] && (BuyPinExists==true) && (UpTrend==true))OrderEntry(0);break;
      case 8:
         if(firstclose-lastclose >= PipDifference*pips && Volume[1]>Volume[2] && Volume[2]>Volume[3] && Volume[3]>Volume[4] && Volume[4]>Volume[5] && Volume[5]>Volume[6] && Volume[6]>Volume[7] && Volume[7]>Volume[8] && (SellPinExists=true) && (DownTrend==true))OrderEntry(1);
         if(lastclose-firstclose >= PipDifference*pips && Volume[1]>Volume[2] && Volume[2]>Volume[3] && Volume[3]>Volume[4] && Volume[4]>Volume[5] && Volume[5]>Volume[6] && Volume[6]>Volume[7] && Volume[7]>Volume[8] && (BuyPinExists=true) && (UpTrend==true))OrderEntry(0);break;
     }
  }
//+------------------------------------------------------------------+
//|Psych. level function                                             |
//|Verifies that the trade should be taken close to x level          |
//|                                                                  |
//+------------------------------------------------------------------+

double closetimesonehundred = Close[1] * 100;
double leveldoublezerotimesonehundred = MathRound (closetimesonehundred);
double leveldoublezero = leveldoublezerotimesonehundred / 100;


bool CheckForPsychLevel ()
   {
   bool closetothelevel = false;
   if (UsePsychLevels)
      {             
         closetothelevel = false;
         if (Close[1] <= leveldoublezero + upperlowerlimit && Close[1] >= leveldoublezero - upperlowerlimit)            
            closetothelevel = true;
      } 
      else (closetothelevel = true);
   
      return(closetothelevel);
   }









//+------------------------------------------------------------------+
//|Previous volume relevance function                                |
//|Verifies that the previous volume is the largest since            |
//|NumberOfCandlesAgo.                                               |
//+------------------------------------------------------------------+

bool PreviousVolumeCheck()
  {
   bool volumechecked=false;
   if(UsePreviousDayVolume)
     {

      int counter=0;
      volumechecked=false;
      for(int n=NumberOfVolumesAgo;n>1 && Volume[n]<Volume[1]; n--)

        {
         counter++;
         if(counter==NumberOfVolumesAgo-1)
            volumechecked=true;
        }
     }
   else volumechecked=true;

   return(volumechecked);
  }

//+------------------------------------------------------------------+
//|Previous High/Low relevance function                              |
//+------------------------------------------------------------------+
  
bool PreviousHighLowCheck()
   {
   bool lowchecked=false;
   bool highchecked=false;
   bool highlowchecked=false;
   if(UsePreviousHighLow)
      {      
      int counter=0;
      lowchecked=false;
      for(int n=NumberOfCandlesAgo;n>1 && Low[n]>Low[1]; n--)
         {
         counter++;
         if(counter==NumberOfCandlesAgo-1)
            lowchecked=true;
         }      
      int counter2=0;
      highchecked=false;
      for(int n=NumberOfCandlesAgo;n>1 && High[n]<High[1]; n--)
         {
         counter2++;
         if(counter2==NumberOfCandlesAgo-1)
            highchecked=true;
         }
   if (lowchecked == true || highchecked ==true)
      highlowchecked = true;  
      }
   else highlowchecked = true;
   
   return(highlowchecked);
  }


   


//+------------------------------------------------------------------+
//|Buy or Sell code: BUY=0 Sell=1                                    |
//|                                                                  |
//|                                                                  |
//|First sends an order with no SL or TP so all brokers accept the   |
//|order. Then modifies the order immediately with SL and TP.        |
//|The SmartSL simply modifies the way the stop loss is placed.      |
//|                                                                  |
//+------------------------------------------------------------------+
void OrderEntry(int direction)
  {
   double BSL;
   double BTP;
   double SSL;
   double STP;
   int buyticket;
   int sellticket;
   
   if(UseSmartSL=false)
      {
      switch(direction)
        {
         case 0:
            if(Stoploss==0)BSL=0;
            else BSL=Ask-(Stoploss*pips);
            if(Takeprofit==0) BTP=0;
            else BTP=Ask+(Takeprofit*pips);
   
            if(OpenOrdersThisPair(Symbol())==0)
               buyticket=OrderSend(Symbol(),OP_BUY,Lotsize,Ask,Slippage,0,0,"Buy Order",MagicNumber,0,Green);
            else buyticket=-1;
            if(buyticket>0)
               if(OrderModify(buyticket,OrderOpenPrice(),BSL,BTP,0,Green))
                  Print("Buy order successfully placed");break;
   
         case 1:
            if(Stoploss==0) SSL=0;
            else SSL=Bid+(Stoploss*pips);
            if(Takeprofit==0) STP=0;
            else STP=Bid-(Takeprofit*pips);
   
            if(OpenOrdersThisPair(Symbol())==0)
               sellticket=OrderSend(Symbol(),OP_SELL,Lotsize,Bid,Slippage,0,0,"Sell Order",MagicNumber,0,Red);
            else sellticket=-1;
            if(sellticket>0)
               if(OrderModify(sellticket,OrderOpenPrice(),SSL,STP,0,Red))
                  Print("Sell order successfully placed");break;
         }
     }
                  
   if(UseSmartSL=true)
      {
      switch(direction)
        {
         case 0:
            if(Stoploss==0)BSL=0;
            else BSL=Low[1]-(Stoploss*pips);
            if(Takeprofit==0) BTP=0;
            else BTP=Ask+(Takeprofit*pips);
   
            if(OpenOrdersThisPair(Symbol())==0)
               buyticket=OrderSend(Symbol(),OP_BUY,Lotsize,Ask,Slippage,0,0,"Buy Order",MagicNumber,0,Green);
            else buyticket=-1;
            if(buyticket>0)
               if(OrderModify(buyticket,OrderOpenPrice(),BSL,BTP,0,Green))
                  Print("Buy order successfully placed");break;
   
         case 1:
            if(Stoploss==0) SSL=0;
            else SSL=High[1]+(Stoploss*pips);
            if(Takeprofit==0) STP=0;
            else STP=Bid-(Takeprofit*pips);
   
            if(OpenOrdersThisPair(Symbol())==0)
               sellticket=OrderSend(Symbol(),OP_SELL,Lotsize,Bid,Slippage,0,0,"Sell Order",MagicNumber,0,Red);
            else sellticket=-1;
            if(sellticket>0)
               if(OrderModify(sellticket,OrderOpenPrice(),SSL,STP,0,Red))
                  Print("Sell order successfully placed");break;
         }
       }
  }
//+------------------------------------------------------------------+
//|Small function to select a pair and return the number of orders   |
//|for that particular pair. One at a time. Increases the "total"    |
//+------------------------------------------------------------------+  

int OpenOrdersThisPair(string pair) //  pair replaces "Symbol"
  {
   int total=0;
   for(int i=OrdersTotal()-1; i>=0; i--) // 1. initalize condition 2.body is executed if true 3.calculated after each iteration 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) // selecting the orders 1 by 1 // continue required to avoid warning
         if(OrderSymbol()==pair) total++;
     }
   return(total);                            // returns a total of orders for a particular pair
  }
//+------------------------------------------------------------------+
//|When during the week would you like to trade? function            |
//+------------------------------------------------------------------+

bool ValidDay()
  {
   bool daytotrade=false;

   if(DayOfWeek() == 1 && Monday==true)      daytotrade = true;
   if(DayOfWeek() == 2 && Tuesday==true)     daytotrade = true;
   if(DayOfWeek() == 3 && Wednesday==true)   daytotrade = true;
   if(DayOfWeek() == 4 && Thursday==true)    daytotrade = true;
   if(DayOfWeek() == 5 && Friday==true)      daytotrade = true;
   if(DayOfWeek() == 6 && Saturday==true)    daytotrade = true;
   if(DayOfWeek() == 0 && Sunday==true)      daytotrade = true;


   return(daytotrade);
  }
//+------------------------------------------------------------------+
//|When during the day would you like to tade? function              |
//+------------------------------------------------------------------+
bool ValidHour()
  {
   bool goodhour=false;

   for(int z=Hour();StartHour<=z && z<=EndHour;z++)
     {
      goodhour=true;
     }

   return(goodhour);
  }
//+------------------------------------------------------------------+
//|Only trade on NFP days?                                           |
//+------------------------------------------------------------------+  

  bool ValidDayOfMonth()
   {
    bool dayofmonthtotrade=false;
    if(UseDayOfMonth)
      if(DayOfWeek() == WeekDay && Day() < MonthDay)      dayofmonthtotrade = true;
    return (dayofmonthtotrade);
    }       
//+------------------------------------------------------------------+
