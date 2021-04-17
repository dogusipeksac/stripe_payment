import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_payment_flutter_app/service/payment-service.dart';



class ExistingCardPage extends StatefulWidget {
  @override
  _ExistingCardPageState createState() => _ExistingCardPageState();
}

class _ExistingCardPageState extends State<ExistingCardPage> {

  List cards = [{
    'cardNumber': '4242424242424242',
    'expiryDate': '04/24',
    'cardHolderName': 'Dogus Ipeksaç',
    'cvvCode': '424',
    'showBackView': false,
  }];

  payViaExistingCard(BuildContext context,card){
    var response=StripeService.payViaExistingCard(
        amount: '150',
        currency: 'USD',
        card: card,
    );
    if(response.success==true) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: new Duration(
              milliseconds: response.success == true ? 1200 : 3000),
        ),
      ).closed.then((_){
        Navigator.pop(context);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chose Existing Card"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: cards.length,
            itemBuilder: (BuildContext context,int index){
              var card=cards[index];
                  return InkWell(
                    onTap: (){
                      payViaExistingCard(context, card);
                    },
                    child: CreditCardWidget(
                      cardNumber: card['cardNumber'],
                      expiryDate: card['expiryDate'],
                      cardHolderName: card['cardHolderName'],
                      cvvCode:card['cvvCode'],
                      showBackView: false, //true when you want to show cvv(back) view
                    ),
                  );
            },
        ),
      ),
    );
  }
}
