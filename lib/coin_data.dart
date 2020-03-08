import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '06CB115F-2046-445B-A7FD-A1C7A6F96D21';




//  const bitcoinAverageURL =  'https://apiv2.bitcoinaverage.com/indices/global/ticker';
class CoinData {
  // create the asynchronous method getCoinData() that returns a Future (the price data).
  // update getCoinData() to take the selected currency
//  Future getCoinData(String selectedCurrency) async {
//    // create a url combining the coinAPIURL with the currencies we are interested, BTC to USD
//    // update the URL to use the selectedCurrency input
//    String requestURL = '$bitcoinAverageURL/BTC$selectedCurrency';
//    // Make a GET request to the URL and wait for the response.
//    http.Response response = await http.get(requestURL);
//
//    // Check that the request was successful
//    if (response.statusCode == 200) {
//      // Use the 'dart:convert' package to decode the JSON data that comes from coinapi.io
//      var decodeData = jsonDecode(response.body);
//      // Get the last price of bitcoin with the key 'last'
//      double lastPrice = decodeData['last'];
//      // Output the last price from the method
//      return lastPrice.toStringAsFixed(0);
//    }  else{
//      // Handle any errors that occur during the request
//      print(response.statusCode);
//      // Throw an error if our request fails
//      throw 'Problem with the get request';
//    }
//  }



Future getCoinData(String selectedCurrency) async {
  // use a for loop here to loop through the cryptoList and request the data for each of them in turn
  // return a Map of the results instead of a single value
  Map<String, String> cryptoPrices = {};
  for(String crypto in cryptoList){
      //Update the URL to use the crypto symbol from the cryptoList
    String requestURL = '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
    http.Response response = await http.get(requestURL);
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      double lastPrice = decodedData['rate'];
      //Create a new key value pair, with the key being the crypto symbol and the value being the lastPrice of that crypto currency.
      cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
    }else{
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }
  return cryptoPrices;
}
}
