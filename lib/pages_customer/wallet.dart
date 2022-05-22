
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pages_customer/showTransactions.dart';
import 'package:flutter_complete_guide/widgets/Appbar.dart';
import 'package:flutter_complete_guide/widgets/loader.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../commonApi/walletApi.dart';
import '../widgets/navbar.dart' as navbar;
class Wallet extends StatefulWidget {
  int balance;
  String wallet_id;
  int rechargeAmount;
  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final _razorpay = Razorpay();
  List Rechargeamounts = ['1','50','100','200','500','1000'];
  @override
  void dispose() {
        // TODO: implement dispose
        super.dispose();
        _razorpay.clear();
      }
      void _handlePaymentSuccess(PaymentSuccessResponse response) {
      // Do something when payment succeeds
      print(response.paymentId);
     final walletdata =        rechargeWallet(widget.rechargeAmount);
          walletdata.then((value){
      setState(() {
       widget.balance = value[0];
       widget.wallet_id = value[1]; 
      });
      Navigator.pop(context);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
      // Do something when payment fails
  }
  void _handleExternalWallet(ExternalWalletResponse response) {
      // Do something when an external wallet is selected
    }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    final Future<List> walletdata = getWallet();
    
    walletdata.then((value){
      setState(() {
       widget.balance = value[0];
       widget.wallet_id = value[1]; 
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      drawer: navbar.Navbar(),
      appBar: AppBarCustom('Wallet', Size(MediaQuery.of(context).size.width,56)),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[ Container(
            padding: EdgeInsets.all(10),           
            height: 150,
            // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Card(  
              shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(25))),
              elevation: 10,
              color: Colors.red,
              child: Row(children: [
                
                Container(padding: EdgeInsets.only(left: 30,top: 30),width: 200,alignment: Alignment.centerLeft,child: Column(        
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Balance',style: Theme.of(context).primaryTextTheme.titleSmall, ),
                  Text(widget.balance.toString()+'/-',style: Theme.of(context).primaryTextTheme.titleLarge, )
                  ],),),
                  Container(padding: EdgeInsets.only(left: 45),child:Image(image:AssetImage('assets/icons/Balanceruppe.png'))),
              ]),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recharge options',style:  Theme.of(context).primaryTextTheme.titleLarge.copyWith(color: Colors.black),),
                SingleChildScrollView(scrollDirection: Axis.horizontal,
                child: Row(children: Rechargeamounts.map((e) { print(e);
                return Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: Container(
                    height: 50,
                    width: 110,
                    child: GestureDetector(
                      onTap:() {
                        LoaderDialogbox(context);
                        openRazorpay(_razorpay, e);
                        setState(() {
                          widget.rechargeAmount =int.parse(e);
                        });
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(25))),
                        color: Colors.red,
                        child: Align(alignment: Alignment.center,child: Text(e+'/-', style: Theme.of(context).primaryTextTheme.titleSmall,)),
                      ),
                    ),
                  ),
                );}).toList()),)
              ]),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Transactions',style:  Theme.of(context).primaryTextTheme.titleLarge.copyWith(color: Colors.black),),
                Container(
            padding: EdgeInsets.all(10),           
            height: 120,
            // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25))),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Transactions('Payment'),));
              },
              child: Card(  
                shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(25))),
                elevation: 10,
                color: Colors.red,
                child: Row(children: [                
                    Container(padding: EdgeInsets.only(left: 20),child:Image(image:AssetImage('assets/icons/transfer-money.png'))),
                    Container(padding: EdgeInsets.only(left: 10),child:Text('Payment Transactions', style: Theme.of(context).primaryTextTheme.titleMedium,)),
                ]),
              ),
            ),
          ), Container(
            padding: EdgeInsets.all(10),           
            height: 120,
            // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25))),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Transactions('Recharge'),));
              },
              child: Card(  
                shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(25))),
                elevation: 10,
                color: Colors.red,
                child: Row(children: [                
                    Container(padding: EdgeInsets.only(left: 20),child:Image(image:AssetImage('assets/icons/transaction.png'))),
                    Container(padding: EdgeInsets.only(left: 10),child:Text('Recharge Transactions', style: Theme.of(context).primaryTextTheme.titleMedium,)),
                ]),
              ),
            ),
          ), 
                ],
        ),
      )]))
    );
  }
}