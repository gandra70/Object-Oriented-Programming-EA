//+------------------------------------------------------------------+
//|                                              module_oo.mqh       |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                               drenjanind@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "drenjanind@mail.ru"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Order
  {
private:

   MqlTradeRequest   o_request;
   MqlTradeResult    o_result;
  
   int               OrderSL;
   int               OrderTP;
   
   double            order_SL;
   double            order_TP;

public:
     Order()
     {
      ZeroMemory(o_request);
      o_request.action        = TRADE_ACTION_DEAL;
      o_request.magic         = 0;
      o_request.symbol        = Symbol();
      o_request.volume        = 0;
      o_request.sl            = 0;
      o_request.deviation     = 5;
      o_request.type_filling  = ORDER_FILLING_FOK;
      o_request.type_time     = ORDER_TIME_DAY;
      o_request.expiration    = 0;

      OrderSL  = 0;
      OrderTP  = 0;

      order_SL= 0;
      order_TP= 0;
     }
   
   double GetSL(bool CheckBuyOrder)
   {
    if (OrderSL > 0)
     {
      if (CheckBuyOrder)
       {
        return SymbolInfoDouble(o_request.symbol, SYMBOL_ASK) - OrderSL * _Point;
       }
      else
       {
        return SymbolInfoDouble(o_request.symbol, SYMBOL_BID) + OrderSL * _Point;
       }
     }
     else return(order_SL);
   }
   
  double GetTP(bool CheckBuyOrder)
   {
    if (OrderTP > 0)
     {
      if (CheckBuyOrder)
       {
        return SymbolInfoDouble(o_request.symbol, SYMBOL_ASK) + OrderTP * _Point;
       }
      else
       {
        return SymbolInfoDouble(o_request.symbol, SYMBOL_BID) - OrderTP * _Point;
       }
     }
     else return(order_TP);
   }
   
   bool Execute()
     {
      bool err=OrderSend(o_request,o_result);
      if(!err)
        {
         Print("Greska prilikom izvrsenja naloga!");
        }
      return(err);
     }
   
  
   
   bool Buy()
     {               
      o_request.symbol = Symbol();    
      o_request.type  = ORDER_TYPE_BUY;
      o_request.price = SymbolInfoDouble(o_request.symbol, SYMBOL_ASK);
      o_request.sl    = GetSL(true);
      o_request.tp    = GetTP(true);
      return(Execute());
     }
   bool Sell()
     {                     
      o_request.symbol = Symbol(); 
      o_request.type  = ORDER_TYPE_SELL;
      o_request.price = SymbolInfoDouble(o_request.symbol, SYMBOL_BID);
      o_request.sl    = GetSL(false);
      o_request.tp    = GetTP(false);
      return(Execute());
     }
     
   bool Close()
     {
      bool ret;
      if(PositionSelect(o_request.symbol))
        {
         if(ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE))==POSITION_TYPE_BUY)
           {
            o_request.type  = ORDER_TYPE_BUY;
            o_request.price = SymbolInfoDouble(o_request.symbol, SYMBOL_ASK);
           }
         else if(ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE))==POSITION_TYPE_SELL)
           {
            o_request.type  = ORDER_TYPE_SELL;
            o_request.price = SymbolInfoDouble(o_request.symbol, SYMBOL_BID);
           }

         double vol       = o_request.volume;
         o_request.sl     = 0;
         o_request.tp     = 0;
         o_request.volume = PositionGetDouble(POSITION_VOLUME);
         ret=Execute();
         o_request.volume=vol;
        }
      else
        {
         Print("ZATVORI: Ne mozete odabrati poziciju! ");
         ret=false;
        }
      return(ret);
     }

   void SetMagic(int magic)
     {
      o_request.magic=magic;
     }

   void SetComment(string comment)
     {
      o_request.comment=comment;
     }

   void SetLots(double lots)
     {
      o_request.volume=lots;
     }

   void SetSL(int sl)
     {
      order_SL = 0;
      OrderSL  = sl;
     }

   void SetTP(int tp)
     {
      order_TP = 0;
      OrderTP  = tp;
     }
     
  void Signal()
   {
   ulong N = 500;
   ulong m_number = 191817;
   MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(NULL,0,0,100,rates);
   if(copied<=0) {
      Print("Error copying price data ",GetLastError());
   }
   else{
      Print("Copied ",ArraySize(rates)," bars");
     }
     
   if (     rates[0].high - rates[0].low > rates[1].high - rates[1].low && 
                        rates[0].high < rates[1].high  && 
                        rates[0].open < rates[1].close  && 
                        rates[0].close < rates[1].open  && 
                        rates[0].low < rates[1].low ){
    Sell();
    }
  else if (  rates[0].high - rates[0].low < rates[1].high - rates[1].low && 
                     rates[0].high > rates[1].high && 
                     rates[0].close > rates[1].open  && 
                     rates[0].open > rates[1].close  && 
                     rates[0].low > rates[1].low ){
    Buy();
    }
   
   }
   
  };
//+------------------------------------------------------------------+

