import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  // Update the default currency to AUD, the first item in the currencyList
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropDown(){


    List<DropdownMenuItem<String>> dropdownItems = [];



    for (String currency in currenciesList){

      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }


  return  DropdownButton<String>(
        style: TextStyle(
            color: Colors.white
        ),
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (value){
          setState(() {
            selectedCurrency = value;
            print(value);
            // Call getData() when the picker/dropdown changes
            getData();
          });
        }
    );
  }

  CupertinoPicker iOSPicker(){

    List<Text> pikerItems = [];

    for (String currency in currenciesList){
      pikerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.amber,
        itemExtent: 32,
        onSelectedItemChanged: (selectedIndex){
          print(selectedIndex);
          setState(() {
            // Save the selected currency to the property selectedCurrency
            selectedCurrency = currenciesList[selectedIndex];
            // Call getData() when the picker/dropdown changes
            getData();
          });
        },
        children: pikerItems
    );
  }
  // Create a variable to hold the value and use in our Text Widget. Give the variable a starting value of '?' before the data come back from the async methods
 // String bitcoinValueInUSD = '?';
  //String bitcoinValue = '?';

  Map<String, String> coinValues = {};

  bool isWaiting = false;

  // Create an async method here await the coin data from coin_data.dart
  void getData() async {

    try{
      // We're now passing the selectedCurrency when we call getCoinData().
      // Update this method to receive a Map containing the crypto:price key value
      var data = await CoinData().getCoinData(selectedCurrency);
      // We can't await in a setState(). So you have to separate it out into two.
      //7. Third, as soon the above line of code completes, we now have the data and no longer need to wait. So we can set isWaiting to false.
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    }catch(e){
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();
    // Call getData() when the screen loads up. We can't call CoinData().getCoinData() directly here because we can't make initState() async.
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker',textAlign:TextAlign.center,style: TextStyle(color: Colors.black),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: <Widget>[
              cryptoCard(
                cryptoCurrency: 'BTC',
                value: isWaiting ? '?' : coinValues['BTC'],
                selectedCurrency: selectedCurrency,
              ),cryptoCard(
                cryptoCurrency: 'ETH',
                value: isWaiting ? '?' : coinValues['BTC'],
                selectedCurrency: selectedCurrency,
              ),cryptoCard(
                cryptoCurrency: 'LTC',
                value: isWaiting ? '?' : coinValues['BTC'],
                selectedCurrency: selectedCurrency,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.amber,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}

class cryptoCard extends StatelessWidget {
   // You'll need to able to pass the selectedCurrency, value and cryptoCurrency to the constructor of this CryptoCard Widget
  cryptoCard({this.value, this.selectedCurrency, this.cryptoCurrency});

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch ,
        children: <Widget>[
          Card(
            color: Colors.amberAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
              child: Text(
                // Update the Text Widget with the data in bitcoinValueInUSD
                //'1 BTC = $bitcoinValueInUSD USD',
                // Update the currency name depending on the selectedCurrency
                '1 $cryptoCurrency = $value $selectedCurrency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

