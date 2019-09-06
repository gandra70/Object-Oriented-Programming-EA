//+------------------------------------------------------------------+
//|                                                     oo_ea_v0.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                               drenjanind@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "drenjanind@mail.ru"
#property version   "1.00"
#include <modul_oo.mqh>
#include <modul_oo_v2.mqh>
#include <Trade\SymbolInfo.mqh>  
CSymbolInfo    m_symbol;
//--- import classes
Order* ord;
Trade* trd;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
  trd=new Trade();
  ord=new Order();
  if(!m_symbol.Name(Symbol())) 
      return(INIT_FAILED);
  RefreshRates();
  
  return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
  delete ord;
  delete trd;
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  
  static datetime PrevBars=0;
  datetime time_0=iTime(0);
  if(time_0==PrevBars){
      return;
      PrevBars=time_0;}
      
  if(PositionsTotal()<1){
    if(!RefreshRates()){
      PrevBars=iTime(1);
      return;
    }
      ord.Signal();
      ord.SetLots(0.01);
      ord.SetSL(500);
      ord.SetTP(500);
      ord.SetMagic(5050);
      
      trd.Signal2();
      trd.SetLots(0.01);
      trd.SetSL(500);
      trd.SetTP(500);
      trd.SetMagic(5050);
    }
      
  }
//+------------------------------------------------------------------+
//| Refreshes the symbol quotes data                                 |
//+------------------------------------------------------------------+
bool RefreshRates(void)
  {
//--- refresh rates
  if(!m_symbol.RefreshRates()){
      Print("RefreshRates error");
      return(false);
    }
  if(m_symbol.Ask()==0 || m_symbol.Bid()==0)
      return(false);
//---
  return(true);
  }
//+------------------------------------------------------------------+ 
//| Get Time for specified bar index                                 | 
//+------------------------------------------------------------------+ 
datetime iTime(const int index,string symbol=NULL,ENUM_TIMEFRAMES timeframe=PERIOD_CURRENT)
{
  if(symbol==NULL)
      symbol=Symbol();
  if(timeframe==0)
      timeframe=Period();
    datetime Time[1];
    datetime time=0;
    int copied=CopyTime(symbol,timeframe,index,1,Time);
    if(copied>0) time=Time[0];
    return(time);
}
//+------------------------------------------------------------------+

