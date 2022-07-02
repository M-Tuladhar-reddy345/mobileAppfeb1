
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/commonApi/walletApi.dart';
import 'package:flutter_complete_guide/pages_customer/wallet.dart';
import 'package:flutter_complete_guide/widgets/Appbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:flutter_complete_guide/pages_common/home.dart';
import '../commonApi/cartApi.dart';
import '../models.dart' ;
import '../widgets/loader.dart';
import '../widgets/navbar.dart' as navbar;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_complete_guide/models.dart' as models;

class OrderConfirm extends StatefulWidget {
  String message;
  Map<String, models.Customerprod> cart = {};
  String orderRazorpay;
  bool Paid = false;
  String type;
  int cartProds = 0;
  int ttlqty = 0;
  double ttlamt = 0;
  String prodtype = 'All';  
  List prodtypes=['All'];
  StateSetter setModalState;
  int walletBalance;
  String paymentMethod;
  String orderNo;
  TextEditingController Address1 = TextEditingController()..text = '';
  TextEditingController Address2 = TextEditingController()..text = '';
  TextEditingController Address3 = TextEditingController()..text = '';
  TextEditingController Address4 = TextEditingController()..text = '';
  TextEditingController pincode = TextEditingController()..text = '';
  
  var transaction_id = 'cash on delivery ';
  @override
  State<OrderConfirm> createState() => _OrderConfirm();
}

class _OrderConfirm extends State<OrderConfirm> {
 
  final _razorpay = Razorpay();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddresses = get_addresses();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
      @override
      void dispose() {
            // TODO: implement dispose
        super.dispose();
        _razorpay.clear();
      }
      void _handlePaymentSuccess(PaymentSuccessResponse response) {
      // Do something when payment succeeds
      Navigator.pop(context);
      setState(() {
        widget.Paid=true;  
        widget.transaction_id = response.paymentId;
      });
      submit();

      }

  void _handlePaymentError(PaymentFailureResponse response) {
      // Do something when payment fails
  }
  void _handleExternalWallet(ExternalWalletResponse response) {
      // Do something when an external wallet is selected
    }
  
  Future getAddresses;
  submit() async{
    // print(widget.Address1.text == '' ||widget.Address2.text == ''||widget.Address3.text == ''||widget.Address4.text == ''|| widget.pincode.text == '');
    if (widget.Address1.text == '' ||widget.Address2.text == ''||widget.Address3.text == ''||widget.Address4.text == ''|| widget.pincode.text == ''){
      ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Every Field need to be filled'), backgroundColor: Colors.red,));
    }else{
      
    final body = {
      'branch':main.storage.getItem('branch'),
      'phone':main.storage.getItem('phone'),
      'address1': widget.Address1.text,
      'address2': widget.Address2.text,
      'address3': widget.Address3.text,
      'address4': widget.Address4.text,
      'pincode':widget.pincode.text,
      'ifPaid':widget.Paid.toString(),
      'paymentMethod':widget.paymentMethod.toString(),
      'orderno': widget.orderNo.toString(),
      'transaction_id':widget.transaction_id.toString(),
      'ttlamt':widget.ttlamt.toString()
                    };
      final url = Uri.parse(main.url_start+'mobileApp/placeorder/');
      final response =  await http.post(url, body: body);
      if (response.statusCode == 200){
        Navigator.pop(context);
        var data = json.decode(response.body) as Map;
        if (data['message'] == 'Success'){
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Successfully placed order'), backgroundColor: Colors.green,));
          getCart();
          main.storage.setItem('ttl', '0');
          main.storage.setItem('products', '0');
          main.storage.setItem('cart',  <String,Customerprod> {} );
          Navigator.pushReplacement(context, MaterialPageRoute(builder:((context) => Homepage()) ));

        }else{
          ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text(data['message']), backgroundColor: Colors.red,));
        }
      }}
  }
  get_addresses() async {
    final url = Uri.parse(main.url_start +
        'mobileApp/getAddresses/' );
    final response = await http.post(url, body: {'phone': main.storage.getItem('phone')});
    // print(url);


    if (response.statusCode == 200) {
      // print(response.body);
      var data = json.decode(response.body) as Map;
      

      // List Products =
      //     data['results'].map((json) => models.product.fromjson(json)).toList();
      
    
         
         
      return data['addresses'];
    }
  }
  
  // ignore: missing_return
  Widget showCart(BuildContext ctx,StateSetter setModalState){
      showModalBottomSheet(context: ctx, builder: (ctx){
        return StatefulBuilder(builder: ((context, setState) {
          
          return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                      child: Container(
                    width: MediaQuery.of(ctx).size.width,
                    height: 400,
                    child: SingleChildScrollView(
                      child: Table(
                      defaultColumnWidth: FixedColumnWidth(60.0),
                      border: TableBorder.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                      children: [
                            TableRow(children: [
                              Column(children: [
                                Center(
                                    child: Text('Prod',
                                        style: TextStyle(fontSize: 15.0)))
                              ]),
                              Column(children: [
                                Center(
                                    child: Text('Qty',
                                        style: TextStyle(fontSize: 15.0)))
                              ]),
                              Column(children: [
                                Text('Amt', style: TextStyle(fontSize: 15.0))
                              ]),
                              
                              // Column(children: [
                              //   Text('Amt', style: TextStyle(fontSize: 20.0))
                              // ]),
                            ]),
                          ] + widget.cart.values.map((e){
                            print(e.product);
                            print(widget.cart.length);
                            if( e.Quantity != '0.0' ){
                            var image = e.pImage;
                            return TableRow(children: [
                              Column(children: [
                                Center(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(height: 50,width: 50,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/prodtypes/$image'),fit:BoxFit.fill ))),
                                        ),
                                        Text(e.product,
                                          style: TextStyle(fontSize: 15.0)),
                      
                                      ])
                              )]),
                              Column(children: [
                                Center(
                                    child: SizedBox(
                                      width: 30,
                                      child: Center(
                                        child: Text(e.Quantity,
                                          style: TextStyle(fontSize: 15.0)),
                                      ),
                                    ))
                              ]),
                              Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(alignment: Alignment.centerRight,child: Text(e.Amount, style: TextStyle(fontSize: 15.0))),
                                )
                              ]),
                              
                              // Column(children: [
                              //   Text('Amt', style: TextStyle(fontSize: 20.0))
                              // ]),
                            ]);}else{  
                            return TableRow(children: [
                              Column(children: [
                                Center(
                                    child: Container()
                              )]),
                              Column(children: [
                                Center(
                                    child: Container())
                              ]),
                              Column(children: [
                                Center(child: Container())
                              ]),
                              
                              // Column(children: [
                              //   Text('Amt', style: TextStyle(fontSize: 20.0))
                              // ]),
                            ]);}
                          }).toList()+[
                            TableRow(children: [
                              Column(children: [
                                Center(
                                    child: Text('Total',
                                        style: TextStyle(fontSize: 15.0)))
                              ]),
                              Column(children: [
                                Center(
                                    child: Text(widget.ttlqty.toString(),
                                        style: TextStyle(fontSize: 15.0)))
                              ]),
                              Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(alignment: Alignment.centerRight,child: Text(widget.ttlamt.toString(), style: TextStyle(fontSize: 15.0))),
                                )
                              ]),
                              
                              // Column(children: [
                              //   Text('Amt', style: TextStyle(fontSize: 20.0))
                              // ]),
                            ]),
                          ]
                          
                        ),
                    ),
                  )),
                );
        }));
        
      });
    }
  // payments ------

  void openRazorpay() async{
    setState(() {
      widget.paymentMethod ='Razorpay';
    });
    LoaderDialogbox(context);
    final url = Uri.parse(main.url_start +
        'mobileApp/razorPayordercreate/'+main.storage.getItem('ttl').toString() +'/'+main.storage.getItem('phone')+'/'+main.storage.getItem('branch')+'/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as Map;
      setState(() {
        widget.orderRazorpay = data['orderid'];
      });
      _razorpay.open({
        'key': main.Razorpay_key_id,
        'amount': int.parse(data['amt']), //in the smallest currency sub-unit.
        'name': 'Raithanna milk Dairy ',
        'order_id': widget.orderRazorpay, // Generate order_id using Orders API
        'description': 'Fresh milk and milk products',
        'timeout': main.Razorpay_timeout, // in seconds
        'prefill':{
          'contact':main.storage.getItem('phone')
        }
      });
      }
  }
  userWalletAmountRecharge(context){
  String amount;
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('Enter your amount'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                ),
                onChanged: (value) {
                  amount = value;
                },
              ),
            ),
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                return amount;
              },
              child: Text(
                'Submit',
              ),
            ),
          ],
        );
      });
      }
  void WalletPayment(context){
    setState(() {
      widget.paymentMethod='Wallet';
    });
    Navigator.pop(context);
    final Future<List> walletData = getWallet();
    
    walletData.then((value) { 
      setState(() {
        widget.walletBalance = value[0];
      });
    showDialog(context: context, builder: (_)=>Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),child: Container(height: 200,color:Theme.of(context).primaryColorDark,child: Column(
      children: <Widget>[
      Text('Wallet Payment', style: Theme.of(context).primaryTextTheme.titleLarge,),
      Text('Balance:'+value[0].toString(),style: TextStyle(color:Colors.white,fontSize:24 ),),
      
      Expanded(child: Align(alignment: Alignment.bottomCenter,child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: ()=>PayWallet(), child: Text('Pay  '+widget.ttlamt.toString())),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Wallet()));
              }, child: Text('To wallet')),
          ),
        ],
      )))
      
      ],

      ),),));});
  }
  void PayWallet()async{
    if (widget.walletBalance >= widget.ttlamt){
      final walletPay = PaywithWallet(widget.ttlamt);
      walletPay.then((value){
        print(value);
        setState(() {
        widget.Paid=true;
        widget.orderNo = value[3].toString();
        widget.transaction_id = value[4].toString();
        });
        submit();
      });

    }else{
      return showDialog(context: context, builder: (context)=>Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),child: Container(width: 200,height: 50,color: Theme.of(context).primaryColorDark, child: Align(alignment: Alignment.center,child: Text('Insuffeceint balance... Retry ',style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(color: Colors.white),)),),));
    }
  }
  void selectPaymentMethod(context){
    showDialog(context: context, builder: (_)=>Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Container(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child: Center(child: Text('Choose Payment Method',style: Theme.of(context).primaryTextTheme.titleMedium)),),
            FlatButton(onPressed: ()=>WalletPayment(context), child: Text('Pay Using Wallet',style: Theme.of(context).primaryTextTheme.titleSmall,),color: Theme.of(context).primaryColor,),
            FlatButton(onPressed: ()=>openRazorpay(), child: Text('Pay Using Razor pay',style: Theme.of(context).primaryTextTheme.titleSmall,),color: Theme.of(context).primaryColor,),
            FlatButton(onPressed: (){
              setState(() {
                widget.paymentMethod ='Cash on delivery';
                submit();
              });
            }, child: Text('Cash on delivery',style: Theme.of(context).primaryTextTheme.titleSmall,),color: Theme.of(context).primaryColor,),
            ])),backgroundColor: Theme.of(context).primaryColorDark,));
   }
   // --payment
  @override
  Widget build(BuildContext context) {
    widget.cart = main.storage.getItem('cart') ;
    widget.cartProds = int.parse(main.storage.getItem('products'));
    widget.ttlamt = double.parse(main.storage.getItem('ttl'));
    widget.ttlqty = int.parse(main.storage.getItem('ttlqty').toString());
    return    Scaffold(
    drawer: navbar.Navbar(),
        appBar: AppBarCustom('Confirm Order',Size(MediaQuery.of(context).size.width, 56)),
        body: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(child: FlatButton(onPressed: ()=> showCart(context,setState), child: Text('Show products', style: TextStyle(color: Theme.of(context).primaryColor),))),
              Text('Total:- '+ widget.ttlamt.toString(), style: TextStyle(fontSize: 20),),
              Text('Total products:- '+ widget.cartProds.toString()+'('+widget.ttlqty.toString()+')', style: TextStyle(fontSize: 20),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(height: 2,width: MediaQuery.of(context).size.width * (90/100),color: Theme.of(context).primaryColorLight,),
              ),
              Align(alignment: Alignment.centerRight,child: ElevatedButton(onPressed: (() {
                if (widget.Address1.text == '' ||widget.Address2.text == ''||widget.Address3.text == ''||widget.Address4.text == ''|| widget.pincode.text == ''){
      ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Every Field need to be filled'), backgroundColor: Colors.red,));
    }else{selectPaymentMethod(context);}
              }),child: Text('Place order', style: TextStyle(fontSize: 15),))),
              // ignore: missing_return
              FutureBuilder(future: getAddresses,builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  
                 
                  case ConnectionState.none:
                    // TODO: Handle this case.
                    break;
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                    break;
                  case ConnectionState.active:
                    // TODO: Handle this case.
                    break;
                  case ConnectionState.done:
                    if (snapshot.data == null){
                      return Container();

                    }else{
                      
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:    Column(children: snapshot.data.map <Widget>((e){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(onPressed: (){
                                  setState(() {
                                    widget.Address1.text = e[0].toString();
                                    widget.Address2.text = e[1].toString();
                                    widget.Address3.text = e[2].toString();
                                    widget.Address4.text = e[3].toString();
                                    widget.pincode.text = e[5].toString();
                                  });
                                }, child: Text(e[4].toString())),
                              );
                            }).toList(),)                  
                            
                          );
                        
                      
                    }
                    break;
                }
              })   ,
              Align(alignment: Alignment.centerLeft,child: Text('Address', style: TextStyle(fontSize: 15),)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText:'Flatno/Apartment/floor' 
                  ),
                  controller: widget.Address1,
                  // onChanged:(value){
                  //   setState(() {
                  //   widget.Address1.text = value;  
                  //   });                  
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText:'Street' 
                  ),
                  controller: widget.Address2
                  // onChanged:(value){
                  //   setState(() {
                  //   widget.Address2.text = value;  
                  //   });                  
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText:'colony/City' 
                  ),
                  controller: widget.Address3,
                  // onChanged:(value){
                  //   setState(() {
                  //   widget.Address3.text = value;  
                  //   });                  
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText:'District/State' 
                  ),
                  controller: widget.Address4,
                  // onChanged:(value){
                  //   setState(() {
                  //   widget.Address4.text = value;  
                  //   });                  
                  // },
                ),
              ),   
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText:'Pincode' 
                  ),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                  controller: widget.pincode,
                  maxLength: 6,
                  // onChanged:(value){
                  //   setState(() {
                  //   widget.Address4.text = value;  
                  //   });                  
                  // },
                ),
              ),     
              // ignore: missing_return
              
              ]
          ),
        )));

  }
}