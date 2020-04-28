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

extern string info0                    = "Miscellaneous";
extern bool VoiceComment               = true;
bool voicecomment                      = VoiceComment;
extern bool OrderVisual                = true;
bool preordervisual                    = OrderVisual;

extern string info1                    = "Use these parameters to modify your money management";
extern int Takeprofit                  = 50;
extern int Stoploss                    = 25;
extern int Straddlesize                = 15;
extern double Lotsize                  = 0.01;
extern double MaxSpread                = 10;
extern int Slippage                    = 3;
extern int MagicNumber                 =1234;

extern string info24                   = "Mode 1 is Straddle, Mode 2 is Fade";
extern int TradingMode                 = 1;
int tradingmode = TradingMode; 

extern string info2                    = "Use these parameters to modify your Breakeven function";
extern bool UseMoveToBreakeven         =false;
extern int WhenToMoveToBE              =100;
extern int PipsToLockIn                =5;

extern string info3                    = "Use these parameters to modify your Trailing Stop function";
extern bool UseTrailingStop            =false;
extern int WhenToTrail                 =100;
extern int TrailAmount                 =50;

extern string info10                   = "Only take the trade if you are within this range of a psychological level";
extern bool UsePsychLevels             = false;
extern double upperlowerlimit          =0.001;

extern string info12                   = "Days of the week to trade";
extern bool Monday                     =1;
extern bool Tuesday                    =1;
extern bool Wednesday                  =1;
extern bool Thursday                   =1;
extern bool Friday                     =1;
extern bool Saturday                   =1;
extern bool Sunday                     =1;

extern string info14                   = "Only consider certain days of the month? 0 is Sunday, 6 is Saturday 0-6// days before MonthDay day are considered 1-31";
extern bool UseDayOfMonth              = false;
extern int WeekDay                     = 5;
extern int MonthDay                    = 7;

extern string info23                   = "Specific dates on which you wish to backtest trade 0-31";
extern bool UseManualDates             =true;
extern int janday                      =1;
extern int febday                      =1;
extern int marday                      =1;
extern int aprday                      =1;
extern int mayday                      =1;
extern int junday                      =1;
extern int julday                      =1;
extern int augday                      =1;
extern int sepday                      =1;
extern int octday                      =1;
extern int novday                      =1;
extern int decday                      =1;


double pips;

extern string info20                      = "Time during the day the trade takes place 0-24 // 0-60";
extern int TimeOfTradeHour             = 13;
extern int TimeOfTradeMinutes          = 0;
extern int EventTimeHour               = 13;
extern int EventTimeMinutes            = 30;

extern string info21                   = "Seconds after the event the stops are removed";
extern int PendingExpiry               = 300;

extern string info22                   = "Number of hours before the event that the trader is warned";
extern int HoursNotice                 = 12;

// Declaring the names of the boxes and the text lines
string rectangle     = "TimeBox";
string line1         = "line1";
string line2         = "line2";
string line3         = "line3";
string line4         = "line4";
string line5         = "line5";
string line6         = "line6";
string rectangle2    = "TradeBox";       
string line11        = "line11";
string line22        = "line22";
string line33        = "line33";
string line44        = "line44";
string line55        = "line55";
string rectangle3    = "StatusBox";
string line111       = "line111";
string line222       = "line222";
string line333       = "line333";
string line444       = "line444";
string rectangle4    = "SpreadBox";
string line1111      = "line1111";
string line2222      = "line2222";
string line3333      = "line3333";
string rectangle5    = "VoiceButton";
string line11111     = "line11111";
string rectangle6    = "VolumeTest";
string line111111    = "line111111;";
string rectangle7    = "backgroundbuttonbox";
string rectangle8    = "Long&Short";
string rectangle9    = "Long Only";
string rectangle10   = "Short Only";
string rectangle11   = "backgroundbuttonbox2";
string rectangle12   = "Close All";
string line_1        = "line_1";
string line_2        = "line_2";
string line_3        = "line_3";
string rectangle13   = "PaidSpread";
string line_11       = "line_11";
string line_12       = "line_12";
string line_13       = "line_13";
string rectangle14   = "FadeBox";
string rectangle15   = "Straddle";
string rectangle16   = "Fade";
string line_101      = "line_101";
string line_102      = "line_102";
string rectangle17   = "backgroundbuttonbox3";
string rectangle18   = "VisualPrePosition";
string line_1001     = "line_1001";
string line_1002     = "line_1002";
string Hline1        = "Hline1";
string Hline2        = "Hline2";
string Hline3        = "Hline3";
string Hline4        = "Hline4";
string Hline5        = "Hline5";
string Hline6        = "Hline6";
string Hline1_name   = "Hline1_name";
string Hline2_name   = "Hline2_name";
string Hline3_name   = "Hline3_name";
string Hline4_name   = "Hline4_name";
string Hline5_name   = "Hline5_name";
string Hline6_name   = "Hline6_name";


int secondstoexpiry     =0;
bool buttonenablerlong  =true; // Global switch for long trades ON/OFF
bool buttonenablershort =true; // Global switch for short trades ON/OFF
int buystopticket;
int sellstopticket;
bool closebuttonpressed = false; // Global close & disable trades switch





// Functionality button: Voice ON/OFF && Sound Test 
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
    {
bool button1 = ObjectGetInteger(0,rectangle5,OBJPROP_STATE);
 if(id == CHARTEVENT_OBJECT_CLICK && sparam == "VoiceButton")
switch(button1)
   {
   case false:
      {
      voicecomment = false;
      ObjectSetString(0,rectangle5,OBJPROP_TEXT,"Voice OFF");break;
      }
   
   case true:
      {
      voicecomment = true;
      ObjectSetString(0,rectangle5,OBJPROP_TEXT,"Voice ON");break;
      }
   }
bool button2 = ObjectGetInteger(0,rectangle5,OBJPROP_STATE);
if((button2) = true)
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "VolumeTest")
   {
   ObjectSetInteger(0,rectangle6,OBJPROP_STATE,0);
   if(voicecomment==1)
   PlaySound("ok.wav");
   }
 

// Three Buttons for position taking

bool longshortbutton = ObjectGetInteger(0,rectangle8,OBJPROP_STATE);
bool longbutton      = ObjectGetInteger(0,rectangle9,OBJPROP_STATE);          
bool shortbutton     = ObjectGetInteger(0,rectangle10,OBJPROP_STATE);          

// Mutually exclusive option to click each
int selection;
if(id == CHARTEVENT_OBJECT_CLICK && sparam == "Long&Short" )
   if(longshortbutton=true)
   {
   selection = 1;
   }
if(id == CHARTEVENT_OBJECT_CLICK && sparam == "Long Only" )
   if(longbutton=true) 
   {
   selection = 2;
   }
if(id == CHARTEVENT_OBJECT_CLICK && sparam == "Short Only" )
   if(shortbutton=true)
   {
   selection = 3;
   }
   
// Using a switch and other variables to disable/enable the orders in the code      
switch(selection)
   {
      case 1:
         {
            buttonenablerlong = true;   
            buttonenablershort = true;
            ObjectSetInteger(0,rectangle9,OBJPROP_STATE,0);
            ObjectSetInteger(0,rectangle10,OBJPROP_STATE,0);break;

         }
      case 2:
         {
            buttonenablerlong = true;   
            buttonenablershort = false;
            ObjectSetInteger(0,rectangle8,OBJPROP_STATE,0);
            ObjectSetInteger(0,rectangle10,OBJPROP_STATE,0);break;
   
         }
      case 3:
         {
            buttonenablerlong = false;   
            buttonenablershort = true;
            ObjectSetInteger(0,rectangle8,OBJPROP_STATE,0);
            ObjectSetInteger(0,rectangle9,OBJPROP_STATE,0);break; 
         }
   }
   
 // Two Buttons for the trading mode (Straddle or Fade)

bool straddlebutton = ObjectGetInteger(0,rectangle15,OBJPROP_STATE);
bool fadebutton     = ObjectGetInteger(0,rectangle16,OBJPROP_STATE);
  
//Mutually exclusive option to click each
int selection2;
if(id == CHARTEVENT_OBJECT_CLICK && sparam == "Straddle" )
   if(straddlebutton=true)
   {
   selection2 = 1;
   }
if(id == CHARTEVENT_OBJECT_CLICK && sparam == "Fade" )
   if(fadebutton=true)
   {
   selection2 = 2;
   }
   
switch(selection2)
   {
   case 1:
      {
      tradingmode = 1;
      ObjectSetInteger(0,rectangle16,OBJPROP_STATE,0);break;
      } 
   case 2:
      {
      tradingmode = 2;
      ObjectSetInteger(0,rectangle15,OBJPROP_STATE,0);break;
      }
   }
 
  // The close all button OnChartEvent Code
 bool closebutton = ObjectGetInteger(0,rectangle12,OBJPROP_STATE);
 bool close; // a bool declaration is required for the order functions to work
 if(id == CHARTEVENT_OBJECT_CLICK && sparam == "Close All")
 {
 switch(closebutton)
    {
    case true:
      {
       
       ObjectSetString(0,rectangle12,OBJPROP_TEXT,"ON");                                 
       closebuttonpressed = true;      
                    
       for(int a=OrdersTotal()-1;a>=0;a--)                                          // Each of these blocks represents one of the six different order scenarios
           {           
            if(OrderSelect(a,SELECT_BY_POS,MODE_TRADES))
            {
               if(OrderType()==OP_SELL)
                  close = OrderClose(OrderTicket(),Lotsize,Ask,Slippage,Purple);
            }
           }               
       for(int b=OrdersTotal()-1;b>=0;b--)
           {                     
               if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
            {
               if(OrderType()==OP_BUY)
                  close = OrderClose(OrderTicket(),Lotsize,Bid,Slippage,Purple);
            }
           }
       for(int c=OrdersTotal()-1;c>=0;c--)
           {                     
      
               if(OrderSelect(c,SELECT_BY_POS,MODE_TRADES))
            {
               if(OrderType()==OP_SELLSTOP)
                  close = OrderDelete(OrderTicket(),Purple);
            }
           }
       for(int d=OrdersTotal()-1;d>=0;d--)
           {                     
               if(OrderSelect(d,SELECT_BY_POS,MODE_TRADES))
            {
               if(OrderType()==OP_BUYSTOP)
                  close = OrderDelete(OrderTicket(),Purple);
            }
           } 
       for(int e=OrdersTotal()-1;e>=0;e--)
           {                     
               if(OrderSelect(e,SELECT_BY_POS,MODE_TRADES))
            {
               if(OrderType()==OP_BUYLIMIT)
                  close = OrderDelete(OrderTicket(),Purple);
            }
           } 
       for(int f=OrdersTotal()-1;f>=0;f--)
           {                     
               if(OrderSelect(f,SELECT_BY_POS,MODE_TRADES))
            {
               if(OrderType()==OP_SELLLIMIT)
                  close = OrderDelete(OrderTicket(),Purple);
            }
           } 
           
                
                 
      } 
         break;                                                         // The break; has to be after the brackets or else the looping in the first switch does not function correctly
      
    case false:
       {
                  ObjectSetString(0,rectangle12,OBJPROP_TEXT,"OFF");
                  closebuttonpressed = false;
       } 
         break;
     }      
 }
   bool visualbutton = ObjectGetInteger(0,rectangle18,OBJPROP_STATE);
    if(id == CHARTEVENT_OBJECT_CLICK && sparam == "VisualPrePosition")
 {
 switch(visualbutton)
    {
    case true:
      {
         ObjectSetString(0,rectangle18,OBJPROP_TEXT,"Activated");                                 
         preordervisual = true;break;
      }
    case false:      
         ObjectSetString(0,rectangle18,OBJPROP_TEXT,"Deactivated");                                 
         preordervisual = false;break;
      }
    }
 
 
 
 
 
 
 
}
//+------------------------------------------------------------------+
//| Expert initialization function. Size correction so that decimals |
//| do not have to be used in the inputs                             |
//+------------------------------------------------------------------+

int OnInit()
  {
//---
   // Plays welcome sound
   
   if(voicecomment==true)
      PlaySound("stoolinitialized.wav");
     
   
   double ticksize=MarketInfo(Symbol(),MODE_TICKSIZE);
   if(ticksize==0.00001 || ticksize==0.001)
      pips=ticksize*10;
   else pips=ticksize;
    
   
//---

{
// string rectangle = "NewsBox";   

//+------------------------------------------------------------------+
//|The following lines ensure that 00 is used instead of 0 in the box|
//+------------------------------------------------------------------+

string ethdd;
string etmdd;
string tthdd;
string ttmdd;
int dayoftheweek = WeekDay;
string weekdayinwords;

if (EventTimeHour<10)
   (ethdd = "0"+IntegerToString(EventTimeHour));
      else ethdd = IntegerToString(EventTimeHour);
      
if (EventTimeMinutes<10)
   (etmdd = "0"+IntegerToString(EventTimeMinutes));
      else etmdd = IntegerToString(EventTimeMinutes); 
      
if (TimeOfTradeHour<10)
   (tthdd = "0"+IntegerToString(TimeOfTradeHour));
      else tthdd = IntegerToString(TimeOfTradeHour); 

if (TimeOfTradeMinutes<10)
   (ttmdd = "0"+IntegerToString(TimeOfTradeMinutes));
      else ttmdd = IntegerToString(TimeOfTradeMinutes); 
      
switch(dayoftheweek)
   {
      case 0:
       weekdayinwords = "Sunday";break;
      case 1:
       weekdayinwords = "Monday"; break;
      case 2:
       weekdayinwords = "Tuesday";break;
      case 3:
       weekdayinwords = "Wednesday";break;
      case 4:
       weekdayinwords = "Thursday";break;
      case 5:
       weekdayinwords = "Friday";break;
      case 6:
       weekdayinwords = "Saturday";break;
   }   
//+------------------------------------------------------------------+
//|Creation of the Information boxes                                 |
//+------------------------------------------------------------------+      



      // First box
    
string infotext1      = " Schedule";
string infotext2     = " Event set for: "+(ethdd)+":"+(etmdd);
string infotext3     = " on "+(weekdayinwords);
string infotext4     = " Trade set for: "+(tthdd)+":"+(ttmdd);
    
                  
      ObjectCreate(rectangle,OBJ_RECTANGLE_LABEL,0,0,0,0,0);
      ObjectSet(rectangle,OBJPROP_COLOR,Black);
      ObjectSetInteger(0,rectangle,OBJPROP_BGCOLOR,AliceBlue);
      ObjectSet(rectangle,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle,OBJPROP_WIDTH,1);
      ObjectSet(rectangle,OBJPROP_YDISTANCE,50);
      ObjectSet(rectangle,OBJPROP_XDISTANCE,30);
      ObjectSet(rectangle,OBJPROP_YSIZE,115);
      ObjectSet(rectangle,OBJPROP_XSIZE,160);
      ObjectSet(rectangle,OBJPROP_BACK,0);
      
            
      ObjectCreate(line1,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line1,OBJPROP_TEXT,infotext1);
      ObjectSet(line1,OBJPROP_COLOR,Black);
      ObjectSet(line1,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line1,OBJPROP_YDISTANCE,50);
      ObjectSet(line1,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line1,OBJPROP_FONTSIZE,9);
      ObjectSet(line1,OBJPROP_BACK,0);
      
      ObjectCreate(line2,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line2,OBJPROP_TEXT,infotext2);
      ObjectSet(line2,OBJPROP_COLOR,Gray);
      ObjectSet(line2,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line2,OBJPROP_YDISTANCE,70);
      ObjectSet(line2,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line2,OBJPROP_FONTSIZE,9);
      
      ObjectCreate(line3,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line3,OBJPROP_TEXT,infotext3);
      ObjectSet(line3,OBJPROP_COLOR,Gray);
      ObjectSet(line3,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line3,OBJPROP_YDISTANCE,88);
      ObjectSet(line3,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line3,OBJPROP_FONTSIZE,9);
      
      ObjectCreate(line4,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line4,OBJPROP_TEXT,infotext4);
      ObjectSet(line4,OBJPROP_COLOR,Gray);
      ObjectSet(line4,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line4,OBJPROP_YDISTANCE,105);
      ObjectSet(line4,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line4,OBJPROP_FONTSIZE,9);
 
 
      // The static 2nd Box. 
      
string infotext11    = " Trade Parameters";
string infotext22    = " Take Profit: "+IntegerToString(Takeprofit);
string infotext33    = " Stop Loss: "+IntegerToString(Stoploss);
string infotext44    = " Straddle Gap: "+IntegerToString(Straddlesize);
string infotext55    = " Expiry: "+IntegerToString(PendingExpiry)+" seconds";  
              
         
      ObjectCreate(rectangle2,OBJ_RECTANGLE_LABEL,0,0,0,0,0);
      ObjectSetInteger(0,rectangle2,OBJPROP_BGCOLOR,Linen);
      ObjectSet(rectangle2,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle2,OBJPROP_WIDTH,1);
      ObjectSet(rectangle2,OBJPROP_YDISTANCE,177);
      ObjectSet(rectangle2,OBJPROP_XDISTANCE,30);
      ObjectSet(rectangle2,OBJPROP_YSIZE,100);
      ObjectSet(rectangle2,OBJPROP_XSIZE,160);
      ObjectSet(rectangle2,OBJPROP_BACK,0);
      
  
      ObjectCreate(line11,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line11,OBJPROP_TEXT,infotext11);
      ObjectSet(line11,OBJPROP_COLOR,Black);
      ObjectSet(line11,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line11,OBJPROP_YDISTANCE,177);
      ObjectSet(line11,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line11,OBJPROP_FONTSIZE,9);
      
      ObjectCreate(line22,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line22,OBJPROP_TEXT,infotext22);
      ObjectSet(line22,OBJPROP_COLOR,Gray);
      ObjectSet(line22,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line22,OBJPROP_YDISTANCE,197);
      ObjectSet(line22,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line22,OBJPROP_FONTSIZE,9);
      
      ObjectCreate(line33,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line33,OBJPROP_TEXT,infotext33);
      ObjectSet(line33,OBJPROP_COLOR,Gray);
      ObjectSet(line33,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line33,OBJPROP_YDISTANCE,215);
      ObjectSet(line33,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line33,OBJPROP_FONTSIZE,9);
      
      ObjectCreate(line44,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line44,OBJPROP_TEXT,infotext44);
      ObjectSet(line44,OBJPROP_COLOR,Gray);
      ObjectSet(line44,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line44,OBJPROP_YDISTANCE,233);
      ObjectSet(line44,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line44,OBJPROP_FONTSIZE,9); 
      
      ObjectCreate(line55,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line55,OBJPROP_TEXT,infotext55);
      ObjectSet(line55,OBJPROP_COLOR,Gray);
      ObjectSet(line55,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line55,OBJPROP_YDISTANCE,250);
      ObjectSet(line55,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line55,OBJPROP_FONTSIZE,9);     

      //This is the 3rd Box and its title

string infotext111    = " Orders";      
      
      ObjectCreate(rectangle3,OBJ_RECTANGLE_LABEL,0,0,0,0,0);
      ObjectSetInteger(0,rectangle3,OBJPROP_BGCOLOR,Honeydew);
      ObjectSet(rectangle3,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle3,OBJPROP_WIDTH,1);
      ObjectSet(rectangle3,OBJPROP_YDISTANCE,289);
      ObjectSet(rectangle3,OBJPROP_XDISTANCE,30);
      ObjectSet(rectangle3,OBJPROP_YSIZE,85);
      ObjectSet(rectangle3,OBJPROP_XSIZE,250);
      ObjectSet(rectangle3,OBJPROP_BACK,0);

      ObjectCreate(line111,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line111,OBJPROP_TEXT,infotext111);
      ObjectSet(line111,OBJPROP_COLOR,Black);
      ObjectSet(line111,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line111,OBJPROP_YDISTANCE,289);
      ObjectSet(line111,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line111,OBJPROP_FONTSIZE,9);  
      
    //This is the 4th Box and its title 
    
string infotext1111    = " Spread"; 

      ObjectCreate(rectangle4,OBJ_RECTANGLE_LABEL,0,0,0,0,0);
      ObjectSetInteger(0,rectangle4,OBJPROP_BGCOLOR,Lavender);
      ObjectSet(rectangle4,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle4,OBJPROP_WIDTH,1);
      ObjectSet(rectangle4,OBJPROP_YDISTANCE,387);
      ObjectSet(rectangle4,OBJPROP_XDISTANCE,30);
      ObjectSet(rectangle4,OBJPROP_YSIZE,65);
      ObjectSet(rectangle4,OBJPROP_XSIZE,160);
      ObjectSet(rectangle4,OBJPROP_BACK,0);

      ObjectCreate(line1111,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line1111,OBJPROP_TEXT,infotext1111);
      ObjectSet(line1111,OBJPROP_COLOR,Black);
      ObjectSet(line1111,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line1111,OBJPROP_YDISTANCE,387);
      ObjectSet(line1111,OBJPROP_XDISTANCE,30);          
      ObjectSetInteger(0,line1111,OBJPROP_FONTSIZE,9); 
      
      // The box next to the spread one that calculates the paid spread, refer to the lines under the start function for the last 2 lines
      
string infotext_11    = " Incurred"; 
      
      ObjectCreate(rectangle13,OBJ_RECTANGLE_LABEL,0,0,0,0,0);
      ObjectSetInteger(0,rectangle13,OBJPROP_BGCOLOR,Lavender);
      ObjectSet(rectangle13,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle13,OBJPROP_WIDTH,1);
      ObjectSet(rectangle13,OBJPROP_YDISTANCE,387);
      ObjectSet(rectangle13,OBJPROP_XDISTANCE,200);
      ObjectSet(rectangle13,OBJPROP_YSIZE,65);
      ObjectSet(rectangle13,OBJPROP_XSIZE,80);
      ObjectSet(rectangle13,OBJPROP_BACK,0);

      ObjectCreate(line_11,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line_11,OBJPROP_TEXT,infotext_11);
      ObjectSet(line_11,OBJPROP_COLOR,Black);
      ObjectSet(line_11,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line_11,OBJPROP_YDISTANCE,387);
      ObjectSet(line_11,OBJPROP_XDISTANCE,200);          
      ObjectSetInteger(0,line_11,OBJPROP_FONTSIZE,9); 

      
// This is the Volume ON/OFF button

      ObjectCreate(rectangle5,OBJ_BUTTON,0,0,0,0,0);
      ObjectSetInteger(0,rectangle5,OBJPROP_BGCOLOR,WhiteSmoke);
      ObjectSetInteger(0,rectangle5,OBJPROP_COLOR,Black);      
      ObjectSet(rectangle5,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle5,OBJPROP_WIDTH,1);
      ObjectSet(rectangle5,OBJPROP_YDISTANCE,50);
      ObjectSet(rectangle5,OBJPROP_XDISTANCE,200);
      ObjectSet(rectangle5,OBJPROP_YSIZE,30);
      ObjectSet(rectangle5,OBJPROP_XSIZE,80);
      ObjectSet(rectangle5,OBJPROP_BACK,0);

// This small function just makes sure the text begins with the correct text, the OnChartEvent will continue this process.
string initialbuttontext;
   if(voicecomment=true)
      {
      ObjectSetInteger(0,rectangle5,OBJPROP_STATE,true);
      (initialbuttontext = "Voice ON");
      }
      else(initialbuttontext = "Voice OFF");
           
      ObjectSetString(0,rectangle5,OBJPROP_TEXT,initialbuttontext);
      ObjectSetInteger(0,rectangle5,OBJPROP_FONTSIZE,6);
      

// This is the Volume Test button  
 
      ObjectCreate(rectangle6,OBJ_BUTTON,0,0,0,0,0);
      ObjectSetInteger(0,rectangle6,OBJPROP_BGCOLOR,WhiteSmoke);
      ObjectSetInteger(0,rectangle6,OBJPROP_COLOR,Black);
      ObjectSet(rectangle6,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle6,OBJPROP_WIDTH,1);
      ObjectSet(rectangle6,OBJPROP_YDISTANCE,50);
      ObjectSet(rectangle6,OBJPROP_XDISTANCE,290);
      ObjectSet(rectangle6,OBJPROP_YSIZE,30);
      ObjectSet(rectangle6,OBJPROP_XSIZE,60);
      ObjectSet(rectangle6,OBJPROP_BACK,0);
      
      ObjectSetString(0,rectangle6,OBJPROP_TEXT,"Sound Test");
      ObjectSetInteger(0,rectangle6,OBJPROP_FONTSIZE,6); 
      
// This is the Indication of Orders Button and box      
      
      ObjectCreate(rectangle17,OBJ_RECTANGLE_LABEL,0,0,0,0,0);
      ObjectSetInteger(0,rectangle17,OBJPROP_BGCOLOR,AliceBlue);
      ObjectSetInteger(0,rectangle17,OBJPROP_COLOR,Black);
      ObjectSet(rectangle17,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle17,OBJPROP_WIDTH,1);
      ObjectSet(rectangle17,OBJPROP_YDISTANCE,92);
      ObjectSet(rectangle17,OBJPROP_XDISTANCE,200);
      ObjectSet(rectangle17,OBJPROP_YSIZE,73);
      ObjectSet(rectangle17,OBJPROP_XSIZE,80);
      ObjectSet(rectangle17,OBJPROP_BACK,0);
      
      ObjectCreate(line_1001,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line_1001,OBJPROP_TEXT,"Pre-Order");
      ObjectSet(line_1001,OBJPROP_COLOR,Black);
      ObjectSet(line_1001,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line_1001,OBJPROP_YDISTANCE,95);
      ObjectSet(line_1001,OBJPROP_XDISTANCE,205);
      ObjectSetInteger(0,line_1001,OBJPROP_FONTSIZE,7);
      ObjectSet(line_1001,OBJPROP_BACK,0);

      ObjectCreate(line_1002,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line_1002,OBJPROP_TEXT,"Visual");
      ObjectSet(line_1002,OBJPROP_COLOR,Black);
      ObjectSet(line_1002,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line_1002,OBJPROP_YDISTANCE,111);
      ObjectSet(line_1002,OBJPROP_XDISTANCE,205);
      ObjectSetInteger(0,line_1002,OBJPROP_FONTSIZE,7);
      ObjectSet(line_1002,OBJPROP_BACK,0);

      ObjectCreate(rectangle18,OBJ_BUTTON,0,0,0,0,0);
      ObjectSetInteger(0,rectangle18,OBJPROP_BGCOLOR,WhiteSmoke);
      ObjectSetInteger(0,rectangle18,OBJPROP_COLOR,Black);
      ObjectSet(rectangle18,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle18,OBJPROP_WIDTH,1);
      ObjectSet(rectangle18,OBJPROP_YDISTANCE,128);
      ObjectSet(rectangle18,OBJPROP_XDISTANCE,205);
      ObjectSet(rectangle18,OBJPROP_YSIZE,30);
      ObjectSet(rectangle18,OBJPROP_XSIZE,70);
      ObjectSet(rectangle18,OBJPROP_BACK,0);
      ObjectSetInteger(0,rectangle18,OBJPROP_FONTSIZE,10);
      
      // This small function just makes sure the text begins with the correct text, the OnChartEvent will continue this process.
string initialbuttontext2;
   if(preordervisual=true)
      {
      ObjectSet(rectangle18,OBJPROP_STATE,true);
      (initialbuttontext2 = "Activated");
      }
      else(initialbuttontext2 = "Deactivated");
           
      ObjectSetString(0,rectangle18,OBJPROP_TEXT,initialbuttontext2);
      ObjectSetInteger(0,rectangle18,OBJPROP_FONTSIZE,6);
 



      // The grayed out button for the Close All

      ObjectCreate(rectangle11,OBJ_RECTANGLE_LABEL,0,0,0,0,0);
      ObjectSetInteger(0,rectangle11,OBJPROP_BGCOLOR,Honeydew);
      ObjectSet(rectangle11,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle11,OBJPROP_WIDTH,1);
      ObjectSet(rectangle11,OBJPROP_YDISTANCE,289);
      ObjectSet(rectangle11,OBJPROP_XDISTANCE,289);
      ObjectSet(rectangle11,OBJPROP_YSIZE,85);
      ObjectSet(rectangle11,OBJPROP_XSIZE,61);
      ObjectSet(rectangle11,OBJPROP_BACK,0);

      ObjectCreate(line_1,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line_1,OBJPROP_TEXT,"Close &");
      ObjectSet(line_1,OBJPROP_COLOR,Black);
      ObjectSet(line_1,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line_1,OBJPROP_YDISTANCE,292);
      ObjectSet(line_1,OBJPROP_XDISTANCE,295);
      ObjectSetInteger(0,line_1,OBJPROP_FONTSIZE,7);
      

      ObjectCreate(line_2,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line_2,OBJPROP_TEXT,"Disable");
      ObjectSet(line_2,OBJPROP_COLOR,Black);
      ObjectSet(line_2,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line_2,OBJPROP_YDISTANCE,307);
      ObjectSet(line_2,OBJPROP_XDISTANCE,295);
      ObjectSetInteger(0,line_2,OBJPROP_FONTSIZE,7);
      
      ObjectCreate(line_3,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line_3,OBJPROP_TEXT,"Trades");
      ObjectSet(line_3,OBJPROP_COLOR,Black);
      ObjectSet(line_3,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line_3,OBJPROP_YDISTANCE,322);
      ObjectSet(line_3,OBJPROP_XDISTANCE,295);
      ObjectSetInteger(0,line_3,OBJPROP_FONTSIZE,7);


      ObjectCreate(rectangle12,OBJ_BUTTON,0,0,0,0,0);
      ObjectSetInteger(0,rectangle12,OBJPROP_BGCOLOR,LightSlateGray);
      ObjectSetInteger(0,rectangle12,OBJPROP_COLOR,Black);
      ObjectSet(rectangle12,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle12,OBJPROP_WIDTH,1);
      ObjectSet(rectangle12,OBJPROP_YDISTANCE,343);
      ObjectSet(rectangle12,OBJPROP_XDISTANCE,300);
      ObjectSet(rectangle12,OBJPROP_YSIZE,20);
      ObjectSet(rectangle12,OBJPROP_XSIZE,40);
      ObjectSet(rectangle12,OBJPROP_BACK,0);
      ObjectSet(rectangle12,OBJPROP_ZORDER,1);
      ObjectSetString(0,rectangle12,OBJPROP_TEXT,"OFF");
      ObjectSetInteger(0,rectangle12,OBJPROP_FONTSIZE,7);
      

// The Background rectangle & the three other buttons inside it

      ObjectCreate(rectangle7,OBJ_RECTANGLE_LABEL,0,0,0,0,0);
      ObjectSetInteger(0,rectangle7,OBJPROP_BGCOLOR,Linen);
      ObjectSet(rectangle7,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle7,OBJPROP_WIDTH,1);
      ObjectSet(rectangle7,OBJPROP_YDISTANCE,177);
      ObjectSet(rectangle7,OBJPROP_XDISTANCE,200);
      ObjectSet(rectangle7,OBJPROP_YSIZE,100);
      ObjectSet(rectangle7,OBJPROP_XSIZE,80);
      ObjectSet(rectangle7,OBJPROP_BACK,0);
      ObjectSet(rectangle8,OBJPROP_ZORDER,1);

int initialmodelongshortbutton;                                                           // Function that retains the click if TimeFrame is changed and reinit runs
   if(buttonenablerlong==true && buttonenablershort==true)
   {
   initialmodelongshortbutton = 1;
   }
   else      
   {
   initialmodelongshortbutton = 0;
   }
      
      ObjectCreate(rectangle8,OBJ_BUTTON,0,0,0,0,0);
      ObjectSetInteger(0,rectangle8,OBJPROP_BGCOLOR,WhiteSmoke);
      ObjectSetInteger(0,rectangle8,OBJPROP_COLOR,Black);
      ObjectSet(rectangle8,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle8,OBJPROP_WIDTH,1);
      ObjectSet(rectangle8,OBJPROP_YDISTANCE,182);
      ObjectSet(rectangle8,OBJPROP_XDISTANCE,205);
      ObjectSet(rectangle8,OBJPROP_YSIZE,26);
      ObjectSet(rectangle8,OBJPROP_XSIZE,70);
      ObjectSet(rectangle8,OBJPROP_BACK,0);
      ObjectSet(rectangle8,OBJPROP_ZORDER,0);
      ObjectSetString(0,rectangle8,OBJPROP_TEXT,"Long & Short");
      ObjectSetInteger(0,rectangle8,OBJPROP_FONTSIZE,6);
      ObjectSetInteger(0,rectangle8,OBJPROP_STATE,initialmodelongshortbutton);             // Make sure "long & short" is pressed if previously selected (the default setting)

int initialmodelongbutton;                                                           // Function that retains the click if TimeFrame is changed and reinit runs
   if(buttonenablerlong==true && buttonenablershort==false)
   {
   initialmodelongbutton = 1;
   }
   else      
   {
   initialmodelongbutton = 0;
   }
         
      ObjectCreate(rectangle9,OBJ_BUTTON,0,0,0,0,0);
      ObjectSetInteger(0,rectangle9,OBJPROP_BGCOLOR,PaleGreen);
      ObjectSetInteger(0,rectangle9,OBJPROP_COLOR,Black);
      ObjectSet(rectangle9,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle9,OBJPROP_WIDTH,1);
      ObjectSet(rectangle9,OBJPROP_YDISTANCE,213);
      ObjectSet(rectangle9,OBJPROP_XDISTANCE,205);
      ObjectSet(rectangle9,OBJPROP_YSIZE,26);
      ObjectSet(rectangle9,OBJPROP_XSIZE,70);
      ObjectSet(rectangle9,OBJPROP_BACK,0);
      ObjectSet(rectangle9,OBJPROP_ZORDER,0);
      ObjectSetString(0,rectangle9,OBJPROP_TEXT,"Long Only");
      ObjectSetInteger(0,rectangle9,OBJPROP_FONTSIZE,6);
      ObjectSetInteger(0,rectangle9,OBJPROP_STATE,initialmodelongbutton);

int initialmodeshortbutton;                                                           // Function that retains the click if TimeFrame is changed and reinit runs
   if(buttonenablerlong==false && buttonenablershort==true)
   {
   initialmodeshortbutton = 1;
   }
   else      
   {
   initialmodeshortbutton = 0;
   }
      
      ObjectCreate(rectangle10,OBJ_BUTTON,0,0,0,0,0);
      ObjectSetInteger(0,rectangle10,OBJPROP_BGCOLOR,LightCoral);
      ObjectSetInteger(0,rectangle10,OBJPROP_COLOR,Black);
      ObjectSet(rectangle10,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle10,OBJPROP_WIDTH,1);
      ObjectSet(rectangle10,OBJPROP_YDISTANCE,244);
      ObjectSet(rectangle10,OBJPROP_XDISTANCE,205);
      ObjectSet(rectangle10,OBJPROP_YSIZE,26);
      ObjectSet(rectangle10,OBJPROP_XSIZE,70);
      ObjectSet(rectangle10,OBJPROP_BACK,0);
      ObjectSet(rectangle10,OBJPROP_ZORDER,0);
      ObjectSetString(0,rectangle10,OBJPROP_TEXT,"Short Only");
      ObjectSetInteger(0,rectangle10,OBJPROP_FONTSIZE,6);
      ObjectSetInteger(0,rectangle10,OBJPROP_STATE,initialmodeshortbutton);
      
       // Straddle or Fade? the buttons
      
      ObjectCreate(rectangle14,OBJ_RECTANGLE_LABEL,0,0,0,0,0);
      ObjectSetInteger(0,rectangle14,OBJPROP_BGCOLOR,Linen);
      ObjectSet(rectangle14,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle14,OBJPROP_WIDTH,1);
      ObjectSet(rectangle14,OBJPROP_YDISTANCE,177);
      ObjectSet(rectangle14,OBJPROP_XDISTANCE,290);
      ObjectSet(rectangle14,OBJPROP_YSIZE,100);
      ObjectSet(rectangle14,OBJPROP_XSIZE,60);
      ObjectSet(rectangle14,OBJPROP_BACK,0);
      ObjectSet(rectangle14,OBJPROP_ZORDER,0);
      
bool initialmodestraddlebutton;
   if(tradingmode==1)
   {
   initialmodestraddlebutton = 1;
   }
   else
   {
   initialmodestraddlebutton = 0;
   }
      
      ObjectCreate(rectangle15,OBJ_BUTTON,0,0,0,0,0);
      ObjectSetInteger(0,rectangle15,OBJPROP_BGCOLOR,WhiteSmoke);
      ObjectSetInteger(0,rectangle15,OBJPROP_COLOR,Black);
      ObjectSet(rectangle15,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle15,OBJPROP_WIDTH,1);
      ObjectSet(rectangle15,OBJPROP_YDISTANCE,182);
      ObjectSet(rectangle15,OBJPROP_XDISTANCE,295);
      ObjectSet(rectangle15,OBJPROP_YSIZE,43);
      ObjectSet(rectangle15,OBJPROP_XSIZE,50);
      ObjectSet(rectangle15,OBJPROP_BACK,0);
      ObjectSet(rectangle15,OBJPROP_ZORDER,0);
      ObjectSetString(0,rectangle15,OBJPROP_TEXT,"Straddle");
      ObjectSetInteger(0,rectangle15,OBJPROP_FONTSIZE,6);
      ObjectSetInteger(0,rectangle15,OBJPROP_STATE,initialmodestraddlebutton);         // Make sure "Straddle" is pressed when initialized if selected (the default setting)
      
int initialmodefadebutton;
   if(tradingmode==2)
   {
   initialmodefadebutton = 1;
   }
   else      
   {
   initialmodefadebutton = 0;
   }
   
      ObjectCreate(rectangle16,OBJ_BUTTON,0,0,0,0,0);
      ObjectSetInteger(0,rectangle16,OBJPROP_BGCOLOR,WhiteSmoke);
      ObjectSetInteger(0,rectangle16,OBJPROP_COLOR,Black);
      ObjectSet(rectangle16,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(rectangle16,OBJPROP_WIDTH,1);
      ObjectSet(rectangle16,OBJPROP_YDISTANCE,230);
      ObjectSet(rectangle16,OBJPROP_XDISTANCE,295);
      ObjectSet(rectangle16,OBJPROP_YSIZE,43);
      ObjectSet(rectangle16,OBJPROP_XSIZE,50);
      ObjectSet(rectangle16,OBJPROP_BACK,0);
      ObjectSet(rectangle16,OBJPROP_ZORDER,0);
      ObjectSetString(0,rectangle16,OBJPROP_TEXT,"Fade");
      ObjectSetInteger(0,rectangle16,OBJPROP_FONTSIZE,6);
      ObjectSetInteger(0,rectangle16,OBJPROP_STATE,initialmodefadebutton);
      
      

   return(INIT_SUCCEEDED);
  }
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+

int deinit()
  {
//---
  ObjectDelete(rectangle);
  ObjectDelete(line1);
  ObjectDelete(line2);
  ObjectDelete(line3);
  ObjectDelete(line4);
  ObjectDelete(line5);
  ObjectDelete(line6);
  ObjectDelete(rectangle2);
  ObjectDelete(line11);
  ObjectDelete(line22);
  ObjectDelete(line33);
  ObjectDelete(line44);
  ObjectDelete(line55);
  ObjectDelete(rectangle3);
  ObjectDelete(line111);
  ObjectDelete(line222);
  ObjectDelete(line333);
  ObjectDelete(line444);  
  ObjectDelete(rectangle4);
  ObjectDelete(line1111);
  ObjectDelete(line2222);
  ObjectDelete(line3333);
  ObjectDelete(rectangle5);
  ObjectDelete(line11111);
  ObjectDelete(rectangle6);
  ObjectDelete(line111111);
  ObjectDelete(rectangle7);
  ObjectDelete(rectangle8);
  ObjectDelete(rectangle9);
  ObjectDelete(rectangle10);
  ObjectDelete(rectangle11);
  ObjectDelete(rectangle12);
  ObjectDelete(line_1);
  ObjectDelete(line_2);
  ObjectDelete(line_3);
  ObjectDelete(rectangle13);
  ObjectDelete(line_11);
  ObjectDelete(line_12);
  ObjectDelete(line_13);
  ObjectDelete(rectangle14);
  ObjectDelete(rectangle15);
  ObjectDelete(rectangle16);
  ObjectDelete(line_101);
  ObjectDelete(line_102);
  ObjectDelete(rectangle17);
  ObjectDelete(rectangle18);
  ObjectDelete(line_1001);
  ObjectDelete(line_1002);
  ObjectDelete(Hline1);
  ObjectDelete(Hline2);
  ObjectDelete(Hline3);
  ObjectDelete(Hline4);
  ObjectDelete(Hline5);
  ObjectDelete(Hline6);
  ObjectDelete(Hline1_name);
  ObjectDelete(Hline2_name);
  ObjectDelete(Hline3_name);
  ObjectDelete(Hline4_name);
  ObjectDelete(Hline5_name);
  ObjectDelete(Hline6_name);

  
     if(voicecomment==true)
      PlaySound("stoolremoved.wav");



 return(0);
  }
//+------------------------------------------------------------------+/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//|Expert tick function. Everything has to go through this function  |/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//|in order to work.                                                 |/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//|"Master function"                                                 |/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

int start()
  {

// Solely to control the speed in the Strategy Tester   
   if(IsVisualMode()==true)
     {
      int Waitloop=0;
      while(Waitloop<speed){Comment("Wait Loop Count = ",Waitloop); Waitloop++;}
     }
   ChartSetInteger(0,CHART_FOREGROUND,0,false);
   updateboxparameters();
// Conditions to take the trade: Use BE?, TS? Is it the right time to trade?      
   if(OpenOrdersThisPair(Symbol())>=1)
      if(OrderType()==OP_BUY || OrderType()==OP_SELL)
      {
      if(UseTrailingStop)AdjustTrail();   
      }  
   if(ValidWeekDay()==true)
   // Extra conditions related to more technical aspects.  
   if(CheckForPsychLevel()==true)
   // Take the trade! Includes: Activity Succession and PinBar.  
 //  if(IsNewCandle()==true)
   if(ValidDayOfMonth()==true)
   if(ValidDayOfMonthTomorrow() == true)
   if(CheckTheDayManually()==true)
   if(closebuttonpressed==false)
   if (Hour()==TimeOfTradeHour && Minute()==TimeOfTradeMinutes)
   if (((Ask-Bid)/pips) <= MaxSpread)OrderStopEntry();
   return(0);
  }
  
//+------------------------------------------------------------------+
//|These following lines need to be in start function so they update |
//|the information boxes                                             |
//+------------------------------------------------------------------+    

void updateboxparameters()
{
      
      
// When the event occurs, the voice must forewarn
   if(CheckTheDayManually()==true)
      if(Hour()==EventTimeHour && Minute()==EventTimeMinutes)
         if(Seconds()==1)
           if(voicecomment==true)
               PlaySound("potentialmarketmove.wav");

// When Stopped out
//Short SL
   
   for(int S=OrdersTotal()-1;S>=0;S--)
      {
         if(OrderSelect(S,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_SELL)
               if(OrderStopLoss()==Bid)
                  if(voicecomment==true)
                     PlaySound("shortpositionstoploss.wav");
      }
//Long SL

   for(int B=OrdersTotal()-1;B>=0;B--)
      {
         if(OrderSelect(B,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_BUY)
               if(OrderStopLoss()==Ask)
                  if(voicecomment==true)
                     PlaySound("longpositionstoploss.wav");
      }
      
// Whn Profit hits
// Short TP

   for(int S=OrdersTotal()-1;S>=0;S--)
      {
         if(OrderSelect(S,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_SELL)
               if(OrderTakeProfit()==Ask)
                  if(voicecomment==true)
                     PlaySound("shortpositiontakeprofit.wav");
     }
     
// Long TP

   for(int B=OrdersTotal()-1;B>=0;B--)
      {
         if(OrderSelect(B,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_BUY)
               if(OrderTakeProfit()==Bid)
                  if(voicecomment==true)
                     PlaySound("longpositiontakeprofit.wav");
     }


//First Box with the timezones

string infotext5     = " Local Time: "+TimeToStr(TimeLocal(),TIME_MINUTES);
string infotext6     = " Server Time: "+TimeToStr(TimeCurrent(),TIME_MINUTES);      
  
  
      ObjectCreate(line5,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line5,OBJPROP_TEXT,infotext5);
      ObjectSet(line5,OBJPROP_COLOR,Gray);
      ObjectSet(line5,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line5,OBJPROP_YDISTANCE,122);
      ObjectSet(line5,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line5,OBJPROP_FONTSIZE,9);
      
      ObjectCreate(line6,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line6,OBJPROP_TEXT,infotext6);
      ObjectSet(line6,OBJPROP_COLOR,Gray);
      ObjectSet(line6,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line6,OBJPROP_YDISTANCE,139);
      ObjectSet(line6,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line6,OBJPROP_FONTSIZE,9);
      
//|Check whether one is in a trade and the expiry in seconds. This is the 3rd box dynamic components.
      

//the buy line in the Orders Box

string tradestatusbuy = "none";
if((OpenOrdersThisPair(Symbol())>=1))
   {      
      for(int B=OrdersTotal()-1;B>=0;B--)
      {
         if(OrderSelect(B,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_BUYSTOP)         
               tradestatusbuy = "BuyStop ready at "+DoubleToStr(OrderOpenPrice(),4);
            if(OrderType()==OP_BUYLIMIT)
               tradestatusbuy = "BuyLimit ready at "+DoubleToStr(OrderOpenPrice(),4);
            if(OrderType()==OP_BUY)
               {
               tradestatusbuy = "Entered at "+DoubleToStr(OrderOpenPrice(),4);                    
               //Voice notification buy
               if(voicecomment==true)
                  if(OrderOpenTime()==TimeCurrent())
                     PlaySound("buystoptriggered.wav");
               }
               
      }
   }            
string infotext222    = " Long: "+tradestatusbuy;

//the sell line

string tradestatussell = "none";
if((OpenOrdersThisPair(Symbol())>=1))
   {      
      for(int S=OrdersTotal()-1;S>=0;S--)
      {
         if(OrderSelect(S,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_SELLSTOP)         
               tradestatussell = "SellStop ready at "+DoubleToStr(OrderOpenPrice(),4);
            if(OrderType()==OP_SELLLIMIT)         
               tradestatussell = "SellLimit ready at "+DoubleToStr(OrderOpenPrice(),4);
            if(OrderType()==OP_SELL)
               {                            
               tradestatussell = "Entered at "+DoubleToStr(OrderOpenPrice(),4);
                             
               //Voice notification sell
               if(voicecomment==true)
                  if(OrderOpenTime()==TimeCurrent())
                     PlaySound("sellstoptriggered.wav");
               }
             
      }         
   }            
string infotext333    = " Short: "+tradestatussell;

//|Expiry time in seconds countdown      
   if(OpenOrdersThisPair(Symbol())>=1)
      if(OrderType()==OP_SELLSTOP || OrderType()==OP_BUYSTOP || OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT)
         secondstoexpiry = (EventTimeHour*3600+EventTimeMinutes*60+PendingExpiry)-(Hour()*3600+Minute()*60+Seconds());
            if(secondstoexpiry==1)
                  
            //Voice notification expiry      
            if(voicecomment==true)
            
               PlaySound("buyandsellstopsexpired.wav");

   else( secondstoexpiry = 0);

string infotext444    = " Expires in: "+IntegerToString(secondstoexpiry)+" seconds";

      ObjectCreate(line222,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line222,OBJPROP_TEXT,infotext222);
      ObjectSet(line222,OBJPROP_COLOR,Gray);
      ObjectSet(line222,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line222,OBJPROP_YDISTANCE,309);
      ObjectSet(line222,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line222,OBJPROP_FONTSIZE,9);
           

      ObjectCreate(line333,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line333,OBJPROP_TEXT,infotext333);
      ObjectSet(line333,OBJPROP_COLOR,Gray);
      ObjectSet(line333,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line333,OBJPROP_YDISTANCE,327);
      ObjectSet(line333,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line333,OBJPROP_FONTSIZE,9);     

      ObjectCreate(line444,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line444,OBJPROP_TEXT,infotext444);
      ObjectSet(line444,OBJPROP_COLOR,Gray);
      ObjectSet(line444,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line444,OBJPROP_YDISTANCE,345);
      ObjectSet(line444,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line444,OBJPROP_FONTSIZE,9); 
      
      // The spread section
string infotext2222  = " Current Spread: "+DoubleToStr((Ask - Bid)/pips,1);
string infotext3333  = " Maximum Spread: "+DoubleToStr((MaxSpread),1);      
      
      ObjectCreate(line2222,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line2222,OBJPROP_TEXT,infotext2222);
      ObjectSet(line2222,OBJPROP_COLOR,Gray);
      ObjectSet(line2222,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line2222,OBJPROP_YDISTANCE,407);
      ObjectSet(line2222,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line2222,OBJPROP_FONTSIZE,9);
      
      ObjectCreate(line3333,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line3333,OBJPROP_TEXT,infotext3333);
      ObjectSet(line3333,OBJPROP_COLOR,Gray);
      ObjectSet(line3333,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line3333,OBJPROP_YDISTANCE,425);
      ObjectSet(line3333,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,line3333,OBJPROP_FONTSIZE,9);
      
      // Incurred Spread
int currentsecondofday =(Hour()*3600+Minute()*60+Seconds());
int EventTime = TimeOfTradeHour*3600+TimeOfTradeMinutes*60;    
string paidspreadlong = "0";      
string paidspreadshort = "0"; 

         
 if((OpenOrdersThisPair(Symbol())>=1))
   {      
      for(int B=OrdersTotal()-1;B>=0;B--)
      {
         if(OrderSelect(B,SELECT_BY_POS,MODE_TRADES))
           if(OrderOpenTime()==TimeCurrent())
               if(OrderType()==OP_BUY)
                  {                                           
                  paidspreadlong = DoubleToStr((Ask-Bid)/pips,1);
                  }
      }
   }
 if((OpenOrdersThisPair(Symbol())>=1))
   {                        
      for(int S=OrdersTotal()-1;S>=0;S--)
      {
         if(OrderSelect(S,SELECT_BY_POS,MODE_TRADES))
             if(OrderOpenTime()==TimeCurrent())
               if(OrderType()==OP_SELL)
                  {                                           
                  paidspreadshort = DoubleToStr((Ask-Bid)/pips,1);
                  }
            
      }
   }
//      Print(iTime(Symbol(),NULL,0));
      
      ObjectCreate(line_12,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line_12,OBJPROP_TEXT,"Long: "+paidspreadlong);
      ObjectSet(line_12,OBJPROP_COLOR,Gray);
      ObjectSet(line_12,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line_12,OBJPROP_YDISTANCE,407);
      ObjectSet(line_12,OBJPROP_XDISTANCE,203);
      ObjectSetInteger(0,line_12,OBJPROP_FONTSIZE,9);
     
      ObjectCreate(line_13,OBJ_LABEL,0,0,0,0,0);
      ObjectSetString(0,line_13,OBJPROP_TEXT,"Short: "+paidspreadshort);
      ObjectSet(line_13,OBJPROP_COLOR,Gray);
      ObjectSet(line_13,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSet(line_13,OBJPROP_YDISTANCE,425);
      ObjectSet(line_13,OBJPROP_XDISTANCE,203);
      ObjectSetInteger(0,line_13,OBJPROP_FONTSIZE,9);

// Since expiry does not work unless its larger than 10 minutes on the orders themselves, 
// I added this function to make sure it was possible to have shorter expiries.

bool deleteorders = false;
if(OpenOrdersThisPair(Symbol())>=0)

 for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      if(OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP || OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT)
   if((Hour()*3600+Minute()*60) == (EventTimeHour*3600+EventTimeMinutes*60+PendingExpiry))
      {
      deleteorders = OrderDelete(OrderTicket(),Yellow);
      deleteorders = OrderDelete(OrderTicket(),Yellow);
      }
      
     }

// This part of the function creates the small lines and text visible before a trade so one can see where they will be placed beforehand
     
if(preordervisual==true)
   {
   ObjectCreate(0,Hline1,OBJ_TREND,0,0,0,0);
   ObjectCreate(0,Hline2,OBJ_TREND,0,0,0,0);
   ObjectCreate(0,Hline3,OBJ_TREND,0,0,0,0);
   ObjectCreate(0,Hline4,OBJ_TREND,0,0,0,0);
   ObjectCreate(0,Hline5,OBJ_TREND,0,0,0,0);
   ObjectCreate(0,Hline6,OBJ_TREND,0,0,0,0);
   ObjectCreate(0,Hline1_name,OBJ_TEXT,0,0,0,0);
   ObjectCreate(0,Hline2_name,OBJ_TEXT,0,0,0,0);
   ObjectCreate(0,Hline3_name,OBJ_TEXT,0,0,0,0);
   ObjectCreate(0,Hline4_name,OBJ_TEXT,0,0,0,0);
   ObjectCreate(0,Hline5_name,OBJ_TEXT,0,0,0,0);
   ObjectCreate(0,Hline6_name,OBJ_TEXT,0,0,0,0);
      
   if(tradingmode==1)
      {                                                                  // Straddle Indications
      if(buttonenablerlong==true)                                                          // Long Straddle
         {
         ObjectSet(Hline1,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(Hline1,OBJPROP_BACK,0);
         ObjectSet(Hline1,OBJPROP_RAY,false);
         ObjectSet(Hline1,OBJPROP_COLOR,Lime);
         ObjectMove(0,Hline1,0,Time[1],Ask+Straddlesize*pips);
         ObjectMove(0,Hline1,1,Time[6],Ask+Straddlesize*pips);
         ObjectMove(0,Hline1,2,Time[12],Ask+Straddlesize*pips);
         
         ObjectSetString(0,Hline1_name,OBJPROP_TEXT,"BS"); 
         ObjectSetInteger(0,Hline1_name,OBJPROP_FONTSIZE,8);     
         ObjectMove(0,Hline1_name,0,Time[1],Ask+Straddlesize*pips);
         ObjectMove(0,Hline1_name,1,Time[6],Ask+Straddlesize*pips);
         ObjectMove(0,Hline1_name,2,Time[12],Ask+Straddlesize*pips);
         
         ObjectSet(Hline2,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(Hline2,OBJPROP_BACK,0);
         ObjectSet(Hline2,OBJPROP_RAY,false);
         ObjectSet(Hline2,OBJPROP_COLOR,FireBrick);
         ObjectMove(0,Hline2,0,Time[1],Ask+Straddlesize*pips+Takeprofit*pips);
         ObjectMove(0,Hline2,1,Time[6],Ask+Straddlesize*pips+Takeprofit*pips);
         ObjectMove(0,Hline2,2,Time[12],Ask+Straddlesize*pips+Takeprofit*pips);
         
         ObjectSetString(0,Hline2_name,OBJPROP_TEXT,"BS TP"); 
         ObjectSetInteger(0,Hline2_name,OBJPROP_FONTSIZE,8);     
         ObjectMove(0,Hline2_name,0,Time[1],Ask+Straddlesize*pips+Takeprofit*pips);
         ObjectMove(0,Hline2_name,1,Time[6],Ask+Straddlesize*pips+Takeprofit*pips);
         ObjectMove(0,Hline2_name,2,Time[12],Ask+Straddlesize*pips+Takeprofit*pips);
   
         ObjectSet(Hline3,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(Hline3,OBJPROP_BACK,0);
         ObjectSet(Hline3,OBJPROP_RAY,false);
         ObjectSet(Hline3,OBJPROP_COLOR,FireBrick);
         ObjectMove(0,Hline3,0,Time[1],Ask+Straddlesize*pips-Stoploss*pips);
         ObjectMove(0,Hline3,1,Time[6],Ask+Straddlesize*pips-Stoploss*pips);
         ObjectMove(0,Hline3,2,Time[12],Ask+Straddlesize*pips-Stoploss*pips);
         
         ObjectSetString(0,Hline3_name,OBJPROP_TEXT,"BS SL"); 
         ObjectSetInteger(0,Hline3_name,OBJPROP_FONTSIZE,8);     
         ObjectMove(0,Hline3_name,0,Time[1],Ask+Straddlesize*pips-Stoploss*pips);
         ObjectMove(0,Hline3_name,1,Time[6],Ask+Straddlesize*pips-Stoploss*pips);
         ObjectMove(0,Hline3_name,2,Time[12],Ask+Straddlesize*pips-Stoploss*pips);
         }
         else
         {
         ObjectDelete(Hline1);
         ObjectDelete(Hline2);
         ObjectDelete(Hline3);
         ObjectDelete(Hline1_name);
         ObjectDelete(Hline2_name);
         ObjectDelete(Hline3_name);
         }      
        if(buttonenablershort==true)                                                          // Short Straddle
         {
         ObjectSet(Hline4,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(Hline4,OBJPROP_BACK,0);
         ObjectSet(Hline4,OBJPROP_RAY,false);
         ObjectSet(Hline4,OBJPROP_COLOR,Lime);
         ObjectMove(0,Hline4,0,Time[1],Bid-Straddlesize*pips);
         ObjectMove(0,Hline4,1,Time[6],Bid-Straddlesize*pips);
         ObjectMove(0,Hline4,2,Time[12],Bid-Straddlesize*pips);
         
         ObjectSetString(0,Hline4_name,OBJPROP_TEXT,"SS"); 
         ObjectSetInteger(0,Hline4_name,OBJPROP_FONTSIZE,8);     
         ObjectMove(0,Hline4_name,0,Time[1],Bid-Straddlesize*pips);
         ObjectMove(0,Hline4_name,1,Time[6],Bid-Straddlesize*pips);
         ObjectMove(0,Hline4_name,2,Time[12],Bid-Straddlesize*pips);
         
         ObjectSet(Hline5,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(Hline5,OBJPROP_BACK,0);
         ObjectSet(Hline5,OBJPROP_RAY,false);
         ObjectSet(Hline5,OBJPROP_COLOR,FireBrick);
         ObjectMove(0,Hline5,0,Time[1],Bid-Straddlesize*pips-Takeprofit*pips);
         ObjectMove(0,Hline5,1,Time[6],Bid-Straddlesize*pips-Takeprofit*pips);
         ObjectMove(0,Hline5,2,Time[12],Bid-Straddlesize*pips-Takeprofit*pips);
         
         ObjectSetString(0,Hline5_name,OBJPROP_TEXT,"SS TP"); 
         ObjectSetInteger(0,Hline5_name,OBJPROP_FONTSIZE,8);     
         ObjectMove(0,Hline5_name,0,Time[1],Bid-Straddlesize*pips-Takeprofit*pips);
         ObjectMove(0,Hline5_name,1,Time[6],Bid-Straddlesize*pips-Takeprofit*pips);
         ObjectMove(0,Hline5_name,2,Time[12],Bid-Straddlesize*pips-Takeprofit*pips);
   
         ObjectSet(Hline6,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(Hline6,OBJPROP_BACK,0);
         ObjectSet(Hline6,OBJPROP_RAY,false);
         ObjectSet(Hline6,OBJPROP_COLOR,FireBrick);
         ObjectMove(0,Hline6,0,Time[1],Bid-Straddlesize*pips+Stoploss*pips);
         ObjectMove(0,Hline6,1,Time[6],Bid-Straddlesize*pips+Stoploss*pips);
         ObjectMove(0,Hline6,2,Time[12],Bid-Straddlesize*pips+Stoploss*pips);
         
         ObjectSetString(0,Hline6_name,OBJPROP_TEXT,"SS SL"); 
         ObjectSetInteger(0,Hline6_name,OBJPROP_FONTSIZE,8);     
         ObjectMove(0,Hline6_name,0,Time[1],Bid-Straddlesize*pips+Stoploss*pips);
         ObjectMove(0,Hline6_name,1,Time[6],Bid-Straddlesize*pips+Stoploss*pips);
         ObjectMove(0,Hline6_name,2,Time[12],Bid-Straddlesize*pips+Stoploss*pips);
         }
         else
         {
         ObjectDelete(Hline4);
         ObjectDelete(Hline5);
         ObjectDelete(Hline6);
         ObjectDelete(Hline4_name);
         ObjectDelete(Hline5_name);
         ObjectDelete(Hline6_name);
         }      

      }
     if(tradingmode==2)                                                                  // Fade Indications
      {
      if(buttonenablerlong==true)                                                          // Long Fade
         {
         ObjectSet(Hline1,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(Hline1,OBJPROP_BACK,0);
         ObjectSet(Hline1,OBJPROP_RAY,false);
         ObjectSet(Hline1,OBJPROP_COLOR,Lime);
         ObjectMove(0,Hline1,0,Time[1],Ask-Straddlesize*pips);
         ObjectMove(0,Hline1,1,Time[6],Ask-Straddlesize*pips);
         ObjectMove(0,Hline1,2,Time[12],Ask-Straddlesize*pips);
         
         ObjectSetString(0,Hline1_name,OBJPROP_TEXT,"BL"); 
         ObjectSetInteger(0,Hline1_name,OBJPROP_FONTSIZE,8);     
         ObjectMove(0,Hline1_name,0,Time[1],Ask-Straddlesize*pips);
         ObjectMove(0,Hline1_name,1,Time[6],Ask-Straddlesize*pips);
         ObjectMove(0,Hline1_name,2,Time[12],Ask-Straddlesize*pips);
         
         ObjectSet(Hline2,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(Hline2,OBJPROP_BACK,0);
         ObjectSet(Hline2,OBJPROP_RAY,false);
         ObjectSet(Hline2,OBJPROP_COLOR,FireBrick);
         ObjectMove(0,Hline2,0,Time[1],Ask-Straddlesize*pips+Takeprofit*pips);
         ObjectMove(0,Hline2,1,Time[6],Ask-Straddlesize*pips+Takeprofit*pips);
         ObjectMove(0,Hline2,2,Time[12],Ask-Straddlesize*pips+Takeprofit*pips);
         
         ObjectSetString(0,Hline2_name,OBJPROP_TEXT,"BL TP"); 
         ObjectSetInteger(0,Hline2_name,OBJPROP_FONTSIZE,8);     
         ObjectMove(0,Hline2_name,0,Time[1],Ask-Straddlesize*pips+Takeprofit*pips);
         ObjectMove(0,Hline2_name,1,Time[6],Ask-Straddlesize*pips+Takeprofit*pips);
         ObjectMove(0,Hline2_name,2,Time[12],Ask-Straddlesize*pips+Takeprofit*pips);
   
         ObjectSet(Hline3,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(Hline3,OBJPROP_BACK,0);
         ObjectSet(Hline3,OBJPROP_RAY,false);
         ObjectSet(Hline3,OBJPROP_COLOR,FireBrick);
         ObjectMove(0,Hline3,0,Time[1],Ask-Straddlesize*pips-Stoploss*pips);
         ObjectMove(0,Hline3,1,Time[6],Ask-Straddlesize*pips-Stoploss*pips);
         ObjectMove(0,Hline3,2,Time[12],Ask-Straddlesize*pips-Stoploss*pips);
         
         ObjectSetString(0,Hline3_name,OBJPROP_TEXT,"BL SL"); 
         ObjectSetInteger(0,Hline3_name,OBJPROP_FONTSIZE,8);     
         ObjectMove(0,Hline3_name,0,Time[1],Ask-Straddlesize*pips-Stoploss*pips);
         ObjectMove(0,Hline3_name,1,Time[6],Ask-Straddlesize*pips-Stoploss*pips);
         ObjectMove(0,Hline3_name,2,Time[12],Ask-Straddlesize*pips-Stoploss*pips); 
         }
         else
         {
         ObjectDelete(Hline1);
         ObjectDelete(Hline2);
         ObjectDelete(Hline3);
         ObjectDelete(Hline1_name);
         ObjectDelete(Hline2_name);
         ObjectDelete(Hline3_name);
         }      

        if(buttonenablershort==true)                                                          // Short Fade
         {
         ObjectSet(Hline4,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(Hline4,OBJPROP_BACK,0);
         ObjectSet(Hline4,OBJPROP_RAY,false);
         ObjectSet(Hline4,OBJPROP_COLOR,Lime);
         ObjectMove(0,Hline4,0,Time[1],Bid+Straddlesize*pips);
         ObjectMove(0,Hline4,1,Time[6],Bid+Straddlesize*pips);
         ObjectMove(0,Hline4,2,Time[12],Bid+Straddlesize*pips);
         
         ObjectSetString(0,Hline4_name,OBJPROP_TEXT,"SL"); 
         ObjectSetInteger(0,Hline4_name,OBJPROP_FONTSIZE,8);     
         ObjectMove(0,Hline4_name,0,Time[1],Bid+Straddlesize*pips);
         ObjectMove(0,Hline4_name,1,Time[6],Bid+Straddlesize*pips);
         ObjectMove(0,Hline4_name,2,Time[12],Bid+Straddlesize*pips);
         
         ObjectSet(Hline5,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(Hline5,OBJPROP_BACK,0);
         ObjectSet(Hline5,OBJPROP_RAY,false);
         ObjectSet(Hline5,OBJPROP_COLOR,FireBrick);
         ObjectMove(0,Hline5,0,Time[1],Bid+Straddlesize*pips-Takeprofit*pips);
         ObjectMove(0,Hline5,1,Time[6],Bid+Straddlesize*pips-Takeprofit*pips);
         ObjectMove(0,Hline5,2,Time[12],Bid+Straddlesize*pips-Takeprofit*pips);
         
         ObjectSetString(0,Hline5_name,OBJPROP_TEXT,"SL TP"); 
         ObjectSetInteger(0,Hline5_name,OBJPROP_FONTSIZE,8);     
         ObjectMove(0,Hline5_name,0,Time[1],Bid+Straddlesize*pips-Takeprofit*pips);
         ObjectMove(0,Hline5_name,1,Time[6],Bid+Straddlesize*pips-Takeprofit*pips);
         ObjectMove(0,Hline5_name,2,Time[12],Bid+Straddlesize*pips-Takeprofit*pips);
   
         ObjectSet(Hline6,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(Hline6,OBJPROP_BACK,0);
         ObjectSet(Hline6,OBJPROP_RAY,false);
         ObjectSet(Hline6,OBJPROP_COLOR,FireBrick);
         ObjectMove(0,Hline6,0,Time[1],Bid+Straddlesize*pips+Stoploss*pips);
         ObjectMove(0,Hline6,1,Time[6],Bid+Straddlesize*pips+Stoploss*pips);
         ObjectMove(0,Hline6,2,Time[12],Bid+Straddlesize*pips+Stoploss*pips);
         
         ObjectSetString(0,Hline6_name,OBJPROP_TEXT,"SL SL"); 
         ObjectSetInteger(0,Hline6_name,OBJPROP_FONTSIZE,8);     
         ObjectMove(0,Hline6_name,0,Time[1],Bid+Straddlesize*pips+Stoploss*pips);
         ObjectMove(0,Hline6_name,1,Time[6],Bid+Straddlesize*pips+Stoploss*pips);
         ObjectMove(0,Hline6_name,2,Time[12],Bid+Straddlesize*pips+Stoploss*pips);
         }
      
      else
      {
      ObjectDelete(Hline4);
      ObjectDelete(Hline5);
      ObjectDelete(Hline6);
      ObjectDelete(Hline4_name);
      ObjectDelete(Hline5_name);
      ObjectDelete(Hline6_name);
      }      
     } 
   }        
   else
   {
   ObjectDelete(Hline1);
   ObjectDelete(Hline2);
   ObjectDelete(Hline3);
   ObjectDelete(Hline1_name);
   ObjectDelete(Hline2_name);
   ObjectDelete(Hline3_name);
   ObjectDelete(Hline4);
   ObjectDelete(Hline5);
   ObjectDelete(Hline6);
   ObjectDelete(Hline4_name);
   ObjectDelete(Hline5_name);
   ObjectDelete(Hline6_name);
   }      
              
}              
   
//+------------------------------------------------------------------+
//|Buy or Sell code: BUY=0 Sell=1                                    |
//|                                                                  |
//|                                                                  |
//|First sends an order with no SL or TP so all brokers accept the   |
//|order. Then modifies the order immediately with SL and TP.        |
//|The SmartSL simply modifies the way the stop loss is placed (obsolete)|
//|                                                                  |
//+------------------------------------------------------------------+
void OrderStopEntry()
   {
      
   double BSL;
   double BTP;
   double SSL;
   double STP;
   double BSL2;
   double BTP2;
   double SSL2;
   double STP2;
   datetime totaldistanceexpiry = (TimeCurrent()+(EventTimeHour*3600+EventTimeMinutes*60)-(TimeOfTradeHour*3600+TimeOfTradeMinutes*60)+PendingExpiry);

   
      if(Stoploss==0)BSL=0;
      else BSL=Ask+(Straddlesize*pips)-(Stoploss*pips);
      if(Takeprofit==0) BTP=0;
      else BTP=Ask+(Straddlesize*pips)+(Takeprofit*pips); 
      if(Stoploss==0) SSL=0;
      else SSL=Bid-(Straddlesize*pips)+(Stoploss*pips);  
      if(Takeprofit==0) STP=0;
      else STP=Bid-(Straddlesize*pips)-(Takeprofit*pips); 
      
      if(Stoploss==0)BSL2=0;                                         // These version "2" exist for the Fade stop losses and take profits. They are calculated differently.
      else BSL2=Ask-(Straddlesize*pips)-(Stoploss*pips);
      if(Takeprofit==0) BTP2=0;
      else BTP2=Ask-(Straddlesize*pips)+(Takeprofit*pips); 
      if(Stoploss==0) SSL2=0;
      else SSL2=Bid+(Straddlesize*pips)+(Stoploss*pips);  
      if(Takeprofit==0) STP2=0;
      else STP2=Bid+(Straddlesize*pips)-(Takeprofit*pips); 

         
          // Straddle scenario: trading mode is 1
          if(OpenOrdersThisPair(Symbol())==0)
          if(tradingmode==1)  
            {
               if(buttonenablerlong==true)
                  {
                  buystopticket=OrderSend(Symbol(),OP_BUYSTOP,Lotsize,Ask+Straddlesize*pips,Slippage,BSL,BTP,"BuyStop Order",MagicNumber,0,Green);
                  }
               if(buttonenablershort==true)
                  {                        
                  sellstopticket=OrderSend(Symbol(),OP_SELLSTOP,Lotsize,Bid-Straddlesize*pips,Slippage,SSL,STP,"SellStop Order",MagicNumber,0,Red);
                  }
                  
                 // Voice Comment "Buy and Sell Stops, Placed." 
                  
                  if(voicecomment==true)
                     PlaySound("buyandsellstopsplaced.wav");
            }            
           else 
            {
               buystopticket=-1;  //Ensure there is no identifed order
               sellstopticket=-1;
            }
               
          // Fade scenario: trading mode is 2  
          if(OpenOrdersThisPair(Symbol())==0) 
          if(tradingmode==2)
            {
                  if(buttonenablerlong==true)
                  {
                  buystopticket=OrderSend(Symbol(),OP_BUYLIMIT,Lotsize,Ask-Straddlesize*pips,Slippage,BSL2,BTP2,"BuyLimit Order",MagicNumber,0,Green);
                  }
                  if(buttonenablershort==true)
                  {                        
                  sellstopticket=OrderSend(Symbol(),OP_SELLLIMIT,Lotsize,Bid+Straddlesize*pips,Slippage,SSL2,STP2,"SellLimit Order",MagicNumber,0,Red);
                  }
            }
          else 
            {
               buystopticket=-1; 
               sellstopticket=-1;
            }   
//               if(buystopticket>0)
//               if(OrderModify(buystopticket,OrderOpenPrice(),BSL,BTP,0,Green))
//                     Print("BuyStop order successfully placed and modified");
                       
//               if(sellstopticket>0)
//               if(OrderModify(sellstopticket,OrderOpenPrice(),SSL,STP,0,Red))
//                     Print("SellStop order successfully placed and modified");















//                     
   }
   
   
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
/*
bool IsNewCandle()
  {
   static int BarsOnChart=0;     // static means it is only initialized once
   if(Bars==BarsOnChart)
      return(false);
   BarsOnChart=Bars;
   return(true);


  }

    */  
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

bool ValidWeekDay()
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

//+------------------------------------------------------------------+
//|Only trade on NFP days?                                           |
//+------------------------------------------------------------------+  

  bool ValidDayOfMonth()
   {
    bool dayofmonthtotrade=true;
    if(UseDayOfMonth)
      if((DayOfWeek() == WeekDay) && (Day() <= MonthDay)) 
         {     
         dayofmonthtotrade = true;
         Comment("if (ValidDayOfMonth() == true)");
         daybeforeorafter(1);
         }
      else dayofmonthtotrade = false;
    return (dayofmonthtotrade);
    }       
//+------------------------------------------------------------------+
//|1 Day Before the Event? (only used for the signal later)         |
//+------------------------------------------------------------------+  

  bool ValidDayOfMonthTomorrow()  
   {
    bool dayofmonthtotradetm=true;
    if(UseDayOfMonth)
      if((DayOfWeek() == WeekDay-1) && (Day() <= MonthDay-1)) 
         {     
         dayofmonthtotradetm = true;
         Comment("if (ValidDayOfMonthTomorrow() == true)");      
         daybeforeorafter(2);
         }
      else dayofmonthtotradetm = false;
    return (dayofmonthtotradetm);
    }       
//+------------------------------------------------------------------+
//|Place the dates manually. This allows for the backtest of events
//|unlike the NFP that are scheduled in an inconsistent manner.       
//+------------------------------------------------------------------+

bool CheckTheDayManually()
   {
   bool checkdaymanual = false;
   if(UseManualDates)
   {
      if(Month()==1)
         if(janday==Day())
            checkdaymanual=true;
            daybeforeorafter(1);
      if(Month()==2)
         if(febday==Day())
            checkdaymanual=true;
            daybeforeorafter(1);
      if(Month()==3)
         if(marday==Day())
            checkdaymanual=true;
            daybeforeorafter(1);
      if(Month()==4)
         if(aprday==Day())
            checkdaymanual=true;
            daybeforeorafter(1);
      if(Month()==5)
         if(mayday==Day())
            checkdaymanual=true;
            daybeforeorafter(1);
      if(Month()==6)
         if(junday==Day())
            checkdaymanual=true;
            daybeforeorafter(1);
      if(Month()==7)
         if(julday==Day())
            checkdaymanual=true;
            daybeforeorafter(1);
      if(Month()==8)
         if(augday==Day())
            checkdaymanual=true;
            daybeforeorafter(1);
      if(Month()==9)
         if(sepday==Day())
            checkdaymanual=true;
            daybeforeorafter(1);
      if(Month()==10)
         if(octday==Day())
            checkdaymanual=true;
            daybeforeorafter(1);
      if(Month()==11)
         if(novday==Day())
            checkdaymanual=true;
            daybeforeorafter(1);
      if(Month()==12)
         if(decday==Day())
            checkdaymanual=true;
            daybeforeorafter(1);
      }
      else
      {
      checkdaymanual=true;
      }
   
return(checkdaymanual);
}
 
  
//+------------------------------------------------------------------+
//|Determining whether event is tomorrow or today                    |
//+------------------------------------------------------------------+

void Placement()
   {
   if (ValidDayOfMonthTomorrow() == true)
      {
      Comment("if (ValidDayOfMonthTomorrow() == true)");
      daybeforeorafter(2);
      }
   if (ValidDayOfMonth() == true)
      {
      Comment("if (ValidDayOfMonth() == true)");
      daybeforeorafter(1);
      }
   else daybeforeorafter(0);
  
      
   }
   
//+------------------------------------------------------------------+
//|Create a signal for the trader                                    |
//+------------------------------------------------------------------+

void daybeforeorafter(int scenario)
{  

string name = "EventDaySignal";
string warning = "Event incoming in "+IntegerToString(HoursNotice)+" hour(s)";
 
   switch(scenario)
      {
      case 1:
         if((3600*Hour()+60*Minute()) == ((EventTimeHour*3600+EventTimeMinutes*60)-(HoursNotice*3600)))
            {
            ObjectCreate(name,OBJ_VLINE,0,TimeCurrent(),0,0,0);
            ObjectSet(name, OBJPROP_STYLE, 2);
            ObjectSet(name, OBJPROP_COLOR, Black);
            ObjectSetText(name,warning,10,NULL,Black);
            }
         if((3600*Hour()+60*Minute()) == ((EventTimeHour*3600+EventTimeMinutes*60)))
            ObjectDelete(name);break;
           
       

      case 2:
         if(((3600*Hour()+60*Minute()-86400)) == ((EventTimeHour*3600+EventTimeMinutes*60)-(HoursNotice*3600)))            
            ObjectCreate(name,OBJ_VLINE,0,TimeCurrent(),0,0,0);
            ObjectSet(name, OBJPROP_STYLE, 2);
            ObjectSet(name, OBJPROP_COLOR, Black);
            ObjectSetText(name,warning,10,NULL,Black);break;
        
         
            
/*         case 0:
      
         ObjectCreate(name,OBJ_VLINE,0,0,0,0,0);
         ObjectSet(name, OBJPROP_COLOR, Black);break;
         ObjectSet(name, OBJPROP_CORNER, 0);
         ObjectSet(name, OBJPROP_XDISTANCE, 100);
         ObjectSet(name, OBJPROP_YDISTANCE, 200);
         
  */       
        }
}

  