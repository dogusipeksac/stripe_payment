import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse{
  String message;
  bool success;
  StripeTransactionResponse({this.message,this.success});

}

class StripeService{
  static String apiBase='https://api.stripe.com//v1';
  static String secret='';
  static init(){
    //test hesabı
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_51IhD1zE5DAI6iBxtSvgJnHx0nMejw5QT1MjtvpiKSxDppVyD6ZZiOG3OYsq1Zh9ORz7cql6r20mAbBkxwe0GwYyu0027RyWFvW",
        merchantId: "Test",
        androidPayMode: 'test'));

  }

  static StripeTransactionResponse payViaExistingCard({String amount,String  currency,card}){
    return new StripeTransactionResponse(
      message: 'Transaction successful',
      success: true
    );
  }
  static Future<StripeTransactionResponse> payWithNewCard({String amount,String currency}) async{
    try{
      var paymentMethod=await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest(),
      );
      print(jsonEncode(paymentMethod));
      return new StripeTransactionResponse(
          message: 'Transaction successful',
          success: true,
      );
    }catch(err){
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: true,
      );
    }



  }
}