import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment_flutter_app/service/payment-service.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  onItemPress(BuildContext context,int index) async{
    switch(index){
      case 0:
        payViaNewCard();
        break;
      case 1:
        //pay via card
        Navigator.pushNamed(context,"/existing-cards");
        break;
    }
  }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();

  }
 payViaNewCard() async{
   ProgressDialog progressDialog=new ProgressDialog(context);
   progressDialog.style(
       message: 'Please wait..'
   );
   await progressDialog.show();
   //pay via new card
   var response=await StripeService.payWithNewCard(
       amount: '600',
       currency: 'USD'
   );
   await progressDialog.hide();
     // ignore: deprecated_member_use
     Scaffold.of(this.context).showSnackBar(
       SnackBar(
         content: Text(response.message),
         duration: new Duration(
             milliseconds: response.success == true ? 1200 : 3000),
       ),
     );



 }
  @override
  Widget build(BuildContext context) {
    ThemeData themeData=Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context,index){
              Icon icon;
              Text text;

              switch(index){
                case 0:
                  icon=Icon(Icons.add_circle,color: themeData.primaryColor);
                  text=Text("Pay via new card");
                  break;

                case 1:
                  icon=Icon(Icons.credit_card,color: themeData.primaryColor);
                  text=Text("Pay via exiting card");
                  break;
              }

              return InkWell(
                onTap: (){
                  onItemPress(context,index);
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );

            },
            separatorBuilder: (context,index)=>Divider(
          color: themeData.primaryColor,
      ),
            itemCount: 2),
      ),

    );
  }
}
