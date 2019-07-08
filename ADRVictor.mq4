//+------------------------------------------------------------------+
//|                                                    ADRVictor.mq4 |
//|                                                  Victor Mitchell |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Victor Mitchell"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
//--- input parameters
extern color font_color = White;
extern int font_size = 9;
extern string font_face = "Arial";
extern int corner = 0; //0 - for top-left corner, 1 - top-right, 2 - bottom-left, 3 - bottom-right
extern int spread_distance_x = 325;
extern int spread_distance_y = 1;
extern bool normalize = true; //If true then the spread is normalized to traditional pips
extern int periodfirst = 5;
extern int periodsecond = 30;

double Poin;
int n_digits = 0;
double divider = 1;
bool alert_done = false;
double ADR1;
double ADR2;
double CR;
double CompoundedRange1 = 0.00;
double CompoundedRange2 = 0.00;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   //Checking for unconvetional Point digits number
   if (Point == 0.00001) Poin = 0.0001; //5 digits
   else if (Point == 0.001) Poin = 0.01; //3 digits
   else Poin = Point; //Normal
   
   ObjectCreate("ADR1", OBJ_LABEL, 0, 0, 0);
   ObjectSet("ADR1", OBJPROP_CORNER, corner);
   ObjectSet("ADR1", OBJPROP_XDISTANCE, spread_distance_x);
   ObjectSet("ADR1", OBJPROP_YDISTANCE, spread_distance_y);
   ObjectCreate("ADR2", OBJ_LABEL, 0, 0, 0);
   ObjectSet("ADR2", OBJPROP_CORNER, corner);
   ObjectSet("ADR2", OBJPROP_XDISTANCE, spread_distance_x);
   ObjectSet("ADR2", OBJPROP_YDISTANCE, spread_distance_y + 20);
   ObjectCreate("CR", OBJ_LABEL, 0, 0, 0);
   ObjectSet("CR", OBJPROP_CORNER, corner);
   ObjectSet("CR", OBJPROP_XDISTANCE, spread_distance_x);
   ObjectSet("CR", OBJPROP_YDISTANCE, spread_distance_y + 40);
   
   
   if ((Poin > Point) && (normalize))
   {
      divider = 10.0;
      n_digits = 1;
   }
   
   for(int i=1;i<=periodfirst;i++)
   {
    CompoundedRange1 = CompoundedRange1 + ((iHigh(Symbol(),PERIOD_D1,i) - iLow(Symbol(),PERIOD_D1,i)))/Point;
   }  
   for(int i2=1;i2<=periodsecond;i2++)
   {
    CompoundedRange2 = CompoundedRange2 + ((iHigh(Symbol(),PERIOD_D1,i2) - iLow(Symbol(),PERIOD_D1,i2)))/Point;
   }
   
   double CurrentRange     = ((iHigh(Symbol(),PERIOD_D1,0) - iLow(Symbol(),PERIOD_D1,0)))/Point;
   
    ADR1 = (CompoundedRange1 / periodfirst);
    ADR2 = (CompoundedRange2 / periodsecond);
    CR   = (CurrentRange);
    string stringversionofperiodfirst = DoubleToStr(periodfirst,0);
    string stringversionofperiodsecond = DoubleToStr(periodsecond,0);
   ObjectSetText("ADR1","ADR " + "(" + stringversionofperiodfirst + "): " + DoubleToStr(NormalizeDouble(ADR1/divider,1),0),font_size,font_face,font_color);
   ObjectSetText("ADR2","ADR " + "(" + stringversionofperiodsecond + "): " + DoubleToStr(NormalizeDouble(ADR2/divider,1),0),font_size,font_face,font_color);
   ObjectSetText("CR","CR: " + DoubleToStr(NormalizeDouble(CR/divider,1),0),font_size,font_face,font_color);
   RefreshRates();
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
   ObjectDelete("ADR1");
   ObjectDelete("ADR2");
   ObjectDelete("CR");
   return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {            
      ADR1 = ((iHigh(Symbol(),PERIOD_D1,periodfirst) - iLow(Symbol(),PERIOD_D1,periodfirst))); // Point);
      ADR2 = ((iHigh(Symbol(),PERIOD_D1,periodsecond) - iLow(Symbol(),PERIOD_D1,periodsecond))); // Point);
      ObjectSetText("ADRs","ADR1:" + DoubleToStr(NormalizeDouble(ADR1/divider,1),0),font_size,font_face,font_color);
      RefreshRates();
//---
   
//--- return value of prev_calculated for next call
   return(0);
  }
//+------------------------------------------------------------------+
