import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;


class StripeTransactionResponse{
  String message;
  bool success;
  StripeTransactionResponse({this.message,this.success});

}

class StripeService{
  static String apiBase='https://api.stripe.com//v1';
  static String paymentApiUrl='${StripeService.apiBase}/payment_intents';
  static String secret='sk_test_51IhD1zE5DAI6iBxtr09dD0fw38DayIDafSd3KtysmIWxCxhZ3fETnArME7aMsemGcy0XgNTpPKJ8pSw33l5kwnYa00z1riAen2';
  static Map<String,String> headers={
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init(){
    //test hesabı
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_51IhD1zE5DAI6iBxtSvgJnHx0nMejw5QT1MjtvpiKSxDppVyD6ZZiOG3OYsq1Zh9ORz7cql6r20mAbBkxwe0GwYyu0027RyWFvW",
        merchantId: "Test",
        androidPayMode: 'test'));

  }

  static Future<StripeTransactionResponse> payViaExistingCard({String amount, String currency, CreditCard card}) async{
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card)
      );
      var paymentIntent = await StripeService.createPaymentIntent(
          amount,
          currency
      );
      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
              clientSecret: paymentIntent['client_secret'],
              paymentMethodId: paymentMethod.id
          )
      );
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful',
            success: true
        );
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed',
            success: false
        );
      }
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}',
          success: false
      );
    }
  }
  static Future<StripeTransactionResponse> payWithNewCard({String amount,String currency}) async{
    try{
      var paymentMethod=await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest(),
      );
      var paymentIntent=await StripeService.createPaymentIntent(
          amount,
          currency);
      var response=await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id,
        )
      );
      if(response.status==true){
        return new StripeTransactionResponse(
          message: 'Transaction successful',
          success: true,
        );
      }else{
        return new StripeTransactionResponse(
          message: 'Transaction failed',
          success: false,
        );
      }


    }on PlatformException  catch(err) {
      return StripeService.getPlatformExeptionErrorResult(err);

    } catch(err){
      return new StripeTransactionResponse(
        message: 'Transaction failed: ${err.toString()}',
        success: false,
      );
    }

  }


  static getPlatformExeptionErrorResult(err){
    String message='Something went wrong';
    if(err.code=='cancelled'){
      message='Transaction canceled';
    }
    return new StripeTransactionResponse(
      message: message,
      success: false,
    );
  }

  static Future<Map<String,dynamic>> createPaymentIntent(String amount,String currency) async {
    try {
      Map<String,dynamic> body={
      'amount':amount,
        'currency':currency,
        'payment_method_types[]':'card'
    };
      var response=await http.post(
        StripeService.paymentApiUrl,
        body:body,
        headers:StripeService.headers
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charing user : ${err.toString()}');
    }
    return null;
  }
}