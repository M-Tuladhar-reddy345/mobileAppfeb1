import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/pages_customer/addingtoCart.dart';
import 'package:flutter_complete_guide/pages_customer/subscriptions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_complete_guide/pages_customer/cart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_complete_guide/widgets/Appbar.dart';
import 'package:flutter_complete_guide/models.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:intl/intl.dart';
import '../widgets/navbar.dart' as navbar;
class Product extends StatefulWidget {
  String pcode;
  Map<String, Customerprod> cart = {};
  int cartProds = 0;
  int ttlqty = 0;
  double ttlamt = 0;
  DateTime selectedDate = DateTime.now();
  DateTime EndDate = DateTime.now().add(Duration(days: 30));
  Product(this.pcode);
  double TTlamt = 0;
  List selectedDates = [];
  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  void delete(pcode, unitrate){
       setState(() {
         widget.ttlamt = widget.ttlamt - (double.parse(widget.cart[pcode].Quantity) * double.parse(widget.cart[pcode].UnitRate));
        widget.ttlqty = widget.ttlqty - (int.parse(widget.cart[pcode].Quantity.toString().replaceAll('.0', '')));
        widget.cartProds = widget.cartProds - 1;
        widget.cart[pcode].Quantity = '0.0';
        
        
        widget.cart[pcode].Amount = '0.0';
       
        
      });
      print(widget.cart[pcode].Amount);
      main.storage.setItem('cart', widget.cart);
        main.storage.setItem('ttl', widget.ttlamt.toString());
        main.storage.setItem('products', widget.cartProds.toString());
        main.storage.setItem('ttlqty',widget.ttlqty.toString());
     }
  DailyDialogBox(qty){
    Color buttonColor = Theme.of(context).primaryColorDark;
    TextEditingController quantity = TextEditingController();
    quantity.text = qty;
     setState(() {
                        widget.TTlamt = double.parse(qty) * double.parse(widget.cart[widget.pcode].UnitRate);
                       
                      });
    showDialog(context: context, builder: (context){
      return StatefulBuilder(
        builder:(context, setState)=> SimpleDialog(
          
          insetPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          children: [
            Row(
              children: [
                Align(alignment: Alignment.centerLeft,child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Daily', style: Theme.of(context).primaryTextTheme.titleMedium,),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 60,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      widget.TTlamt = double.parse(value) * double.parse(widget.cart[widget.pcode].UnitRate);
                    });
                  },
                  decoration: InputDecoration(labelText: 'Quantity'),
                controller: quantity,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
          ),
          
              ),
            ),
            Row(children: [Text('Total per day: Rs.'),Container(child: Center(child: Text(widget.TTlamt.toString())), color: Colors.white, width: 100,), ]),
            Container(
              width: 100,
              child: Column(
                children: [
                  Text('Select Start Date'),
                  CalendarDatePicker(
                    firstDate: DateTime.now(),                    
                    lastDate: DateTime.now().add(Duration(days: 30 )),
                  initialDate: widget.selectedDate,
                  
                  onDateChanged: (date) {
                    setState(() {
                      widget.selectedDate = date;
                    });
                  },
          ),
                ],
              ),
            ),
            Container(
              width: 100,
              child: Column(
                children: [
                  Text('Select End Date'),
                  CalendarDatePicker(
                    firstDate: DateTime.now(),                    
                    lastDate: DateTime.now().add(Duration(days: 30 )),
                  initialDate: widget.EndDate,
                  
                  onDateChanged: (date) {
                    setState(() {
                      widget.EndDate = date;
                    });
                  },
          ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(buttonColor)),onPressed: quantity.text == '' || quantity.text == '0'||quantity.text == '0.0'? null: () async{
                print(widget.selectedDate);
                Map body = {
                  'phone': main.storage.getItem('phone'),
                  'branch':main.storage.getItem('branch'),
                  'prodcode':widget.pcode,
                  'quantity':quantity.text,
                  'subtype':'Daily',
                  'ttlAmount': widget.TTlamt.toString(),
                  'date':DateFormat('d-M-y').format(widget.selectedDate),
                  'enddate':DateFormat('d-M-y').format(widget.EndDate),

                  };
                  print(body);
                final response = await http.post(Uri.parse(main.url_start+'mobileApp/createSubscription_provided/'), body: body);
                setState(() {
                  widget.TTlamt =0;
                });
                if (response.statusCode == 200){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Subscriptions()));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully placed subscription'),backgroundColor: Colors.green,));
                }else if (response.statusCode == 104){
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed try again... sorry for inconvinience'),backgroundColor: Colors.red,));
                }else if (response.statusCode == 101){
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Not enough money in wallet'),backgroundColor: Colors.red,));
                }
              }, child: Text('Confirm')),
            )
          ],
        ),
      );
    });
  }
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
   if ( widget.selectedDates.length <= 4){
  setState(() {
     widget.selectedDates = args.value;
   });
   }
   
   
  }
  CustomDialogBox(qty){
    Color buttonColor = Theme.of(context).primaryColorDark;
    TextEditingController quantity = TextEditingController();
    quantity.text = qty;
     setState(() {
                        widget.TTlamt = double.parse(qty) * double.parse(widget.cart[widget.pcode].UnitRate);
                       
                      });
    showDialog(context: context, builder: (context){
      return StatefulBuilder(
        builder:(context, setState)=> SimpleDialog(
          
          insetPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          children: [
            Row(
              children: [
                Align(alignment: Alignment.centerLeft,child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Custom', style: Theme.of(context).primaryTextTheme.titleMedium,),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 60,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      widget.TTlamt = double.parse(value) * double.parse(widget.cart[widget.pcode].UnitRate);
                    });
                  },
                  decoration: InputDecoration(labelText: 'Quantity'),
                controller: quantity,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
          ),
          
              ),
            ),
            Row(children: [Text('Total per day: Rs.'),Container(child: Center(child: Text(widget.TTlamt.toString())), color: Colors.white, width: 100,), ]),
            Container(
              width: 100,
              child: Column(
                children: [
                  Text('Select 5 Dates max', style: TextStyle(fontWeight: FontWeight.w900),),
                  SfDateRangePicker(
                    onSelectionChanged: widget.selectedDates.length <= 5? _onSelectionChanged:null,
                    selectionMode: DateRangePickerSelectionMode.multiple,
                    minDate: DateTime.now(),                    
                    maxDate: DateTime.now().add(Duration(days: 30 )),
                    

                  ),
                  
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(buttonColor)),onPressed: quantity.text == '' || quantity.text == '0'||quantity.text == '0.0'? null: () async{
                print(widget.selectedDate);
                Map body = {
                  'phone': main.storage.getItem('phone'),
                  'branch':main.storage.getItem('branch'),
                  'prodcode':widget.pcode,
                  'quantity':quantity.text,
                  'subtype':'custom',
                  'ttlAmount': widget.TTlamt.toString(),
                  'date':DateFormat('d-M-y').format(widget.selectedDate),
                  'selectedDates': widget.selectedDates.toString(),
                  };
                  print(body);
                final response = await http.post(Uri.parse(main.url_start+'mobileApp/createSubscription_provided/'), body: body);
                setState(() {
                  widget.TTlamt =0;
                  widget.selectedDates = [] ;
                });
                if (response.statusCode == 200){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Subscriptions()));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully placed subscription'),backgroundColor: Colors.green,));
                }else if (response.statusCode == 104){
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed try again... sorry for inconvinience'),backgroundColor: Colors.red,));
                }else if (response.statusCode == 101){
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Not enough money in wallet'),backgroundColor: Colors.red,));
                }
              }, child: Text('Confirm')),
            )
          ],
        ),
      );
    });
  }
  AlternateDialogBox(qty){
    Color buttonColor = Theme.of(context).primaryColorDark;
    TextEditingController quantity = TextEditingController();
    TextEditingController Alternative = TextEditingController();
    Alternative.text ='1';
    quantity.text = qty;
     setState(() {
                        widget.TTlamt = double.parse(qty) * double.parse(widget.cart[widget.pcode].UnitRate);
                       
                      });
    showDialog(context: context, builder: (context){
      return StatefulBuilder(
        builder:(contex,setState)=> SimpleDialog(
          insetPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          children: [
            Row(
              children: [
                Align(alignment: Alignment.centerLeft,child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Alternate Days', style: Theme.of(context).primaryTextTheme.titleMedium,),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 60,
                child: TextFormField(
                  onChanged: (value) {
                      setState(() {
                        widget.TTlamt = double.parse(value) * double.parse(widget.cart[widget.pcode].UnitRate);
                       
                      });
                    },
                  decoration: InputDecoration(labelText: 'Quantity'),
                controller: quantity,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
          ),
              ),
            ),
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: SizedBox(
          //       width: 60,
          //       child: TextFormField(
          //         decoration: InputDecoration(labelText: 'Alternative days'),
          //       controller: Alternative,
          //       keyboardType: TextInputType.number,
          //       inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
          // ),
          //     ),
          //   ),
            Row(children: [Text('Total per day: Rs.'),Container(child: Center(child: Text(widget.TTlamt.toString())), color: Colors.white, width: 100,), ]),
            Container(
              width: 100,
              child: Column(
                children: [
                  Text('Select Start Date'),
                  CalendarDatePicker(
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2023, 12, 12),
                  initialDate: widget.selectedDate,
                  
                  onDateChanged: (date) {
                    setState(() {
                      widget.selectedDate = date;
                    });
                  },
          ),
                ],
              ),
            ),
            
            Container(
              width: 100,
              child: Column(
                children: [
                  Text('Select End Date'),
                  CalendarDatePicker(
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2023, 12, 12),
                  initialDate: widget.EndDate,
                  
                  onDateChanged: (date) {
                    setState(() {
                      widget.EndDate = date;
                    });
                  },
          ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(buttonColor)),onPressed:  quantity.text == '' || quantity.text == '0'||quantity.text == '0.0'? null: () async{
                Map body = {
                  'phone': main.storage.getItem('phone'),
                  'branch':main.storage.getItem('branch'),
                  'prodcode':widget.pcode,
                  'quantity':quantity.text,
                  'subtype':'Alternate Days',
                  'date':DateFormat('d-M-y').format(widget.selectedDate),
                  'enddate':DateFormat('d-M-y').format(widget.EndDate),
                  'ttlAmount':widget.TTlamt.toString(),
                  'AlternativeDays':Alternative.text
                  };
                  print(body);
                setState(() {
                    widget.TTlamt =0;
                  });
                  
                final response = await http.post(Uri.parse(main.url_start+'mobileApp/createSubscription_provided/'), body: body);
                if (response.statusCode == 200){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Subscriptions()));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully placed subscription'),backgroundColor: Colors.green,));
                }else if (response.statusCode == 104){
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed try again... sorry for inconvinience'),backgroundColor: Colors.red,));
                }else if (response.statusCode == 101){
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Not enough money in wallet'),backgroundColor: Colors.red,));
                }
              }, child: Text('Confirm')),
            )
          ],
        ),
      );
    });
  }
  void add(pcode, unitrate){
      if (widget.cart[pcode] != null){
        setState(() {
         
        widget.ttlqty = widget.ttlqty+1;
        widget.cart[pcode].Quantity = (double.parse(widget.cart[pcode].Quantity) + 1).toString();
        if (widget.cart[pcode].Quantity == '1.0'){
          widget.cartProds = widget.cartProds+1;
        }

        widget.cart[pcode].Amount = (double.parse(widget.cart[pcode].Quantity) * double.parse(widget.cart[pcode].UnitRate)).toString();
        widget.ttlamt = widget.ttlamt + (double.parse(widget.cart[pcode].UnitRate));
       
        
      });
      main.storage.setItem('cart', widget.cart);
         main.storage.setItem('ttl', widget.ttlamt.toString());
         main.storage.setItem('products', widget.cartProds.toString());
         main.storage.setItem('ttlqty',widget.ttlqty.toString());
      }
     }
    void subtract(pcode, unitrate){
      if (widget.cart[pcode].Quantity != '0.0'){
        setState(() {
        
        widget.cart[pcode].Quantity = (double.parse(widget.cart[pcode].Quantity) - 1).toString();
       
        if (widget.cart[pcode].Quantity == '0.0'){
          widget.cartProds = widget.cartProds-1;
        }
        widget.ttlqty = widget.ttlqty-1;
        widget.cart[pcode].Amount = (double.parse(widget.cart[pcode].Quantity) * double.parse(widget.cart[pcode].UnitRate)).toString();
        widget.ttlamt = widget.ttlamt - (double.parse(widget.cart[pcode].UnitRate));
        
      });
      main.storage.setItem('cart', widget.cart);
        main.storage.setItem('ttl', widget.ttlamt.toString());
        main.storage.setItem('products', widget.cartProds.toString());
        main.storage.setItem('ttlqty',widget.ttlqty.toString());
      }
     }
  @override
  Widget build(BuildContext context) {
    if (main.storage.getItem('ttl') != null && main.storage.getItem('products') != null&& main.storage.getItem('cart') != null &&main.storage.getItem('ttlqty') != null ){
      widget.cart = main.storage.getItem('cart');
    widget.cartProds = int.parse(main.storage.getItem('products'));
    widget.ttlamt = double.parse(main.storage.getItem('ttl'));
    widget.ttlqty = int.parse(main.storage.getItem('ttlqty').toString());
    }
    return Scaffold(
      drawer: navbar.Navbar(),
      appBar: AppBarCustom('Product', Size(MediaQuery.of(context).size.width,56)),
      body: SingleChildScrollView(child: Column(
        children: [
          Align(alignment: Alignment.centerLeft,child: FlatButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AddingToCartpage(widget.cart[widget.pcode].ptype, ['All',widget.cart[widget.pcode].ptype,]))), child: Icon(Icons.arrow_left, size: 40,))),
          Container(
          
            child: Column(
              children: [
                Padding(
                         padding: const EdgeInsets.all(10.0),
                         child:  Container(height: 300,width: 400,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/prodtypes/'+widget.cart[widget.pcode].pImage.toString()),fit:BoxFit.fill ))),
                       ),
                Container(
                  color: Theme.of(context).primaryColorLight,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Align(alignment: Alignment.centerLeft,child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.cart[widget.pcode].pname.toString(), style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(color: Colors.black),),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(top:8.0,bottom: 8),
                          child: VerticalDivider(color: Colors.black,thickness: 1,
                  ),
                        ),
                        Container(
                          
                          child: Row(children: [IconButton(onPressed: () => subtract(widget.cart[widget.pcode].product,widget.cart[widget.pcode].UnitRate), icon:Icon( Icons.remove_circle, color: Theme.of(context).primaryColor,)),Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Container(child: Center(child: Text(widget.cart[widget.pcode].Quantity.toString())), color: Colors.white, width: 50,),
                               ),IconButton(onPressed: () => add(widget.cart[widget.pcode].product,widget.cart[widget.pcode].UnitRate), icon:Icon( Icons.add_circle, color: Theme.of(context).primaryColor,))],),
                        )
                      ],
                    ),
                  ),
                ),
                Row(children: [Text('Total: Rs.'),Container(child: Center(child: Text(widget.cart[widget.pcode].Amount.toString())), color: Colors.white, width: 100,), ]),
              ],
            ),
            color: Colors.white,
            height: 400,
            width: MediaQuery.of(context).size.width,
          ),
          Align(alignment: Alignment.centerLeft,child: Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Text('Subscription Types',style: TextStyle(fontSize: 20)),
          ),),
          Container(
            width: MediaQuery.of(context).size.width,

            child: Wrap(children: [
              Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: Container(
                      height: 50,
                      width: 110,
                      child: GestureDetector(
                        onTap:() {
                          DailyDialogBox(widget.cart[widget.pcode].Quantity.toString());
                        },
                      
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(25))),
                          color: Colors.red,
                          
                          child: Align(alignment: Alignment.center,child: Text('Daily', style: Theme.of(context).primaryTextTheme.titleSmall,)),
                        ),
                      ),
                    ),
                  ),
                 Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: Container(
                      height: 50,
                      width: 150,
                      child: GestureDetector(
                        onTap:()=> AlternateDialogBox(widget.cart[widget.pcode].Quantity.toString()),
                      
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(25))),
                          color: Colors.red,
                          
                          child: Align(alignment: Alignment.center,child: Text('Alternate Days', style: Theme.of(context).primaryTextTheme.titleSmall,)),
                        ),
                      ),
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: Container(
                      height: 50,
                      width: 110,
                      child: GestureDetector(
                        onTap:widget.cart[widget.pcode].Quantity != '0.0' && widget.cart[widget.pcode].Quantity != '0'? (){Navigator.push(context, MaterialPageRoute(builder: ((context) => Cartpage())));}:()=> null,                      
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(25))),
                          color: Colors.red,
                          
                          child: Align(alignment: Alignment.center,child: Text('One Time', style: Theme.of(context).primaryTextTheme.titleSmall,)),
                        ),
                      ),
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: Container(
                      height: 50,
                      width: 110,
                      child: GestureDetector(
                        onTap:(){CustomDialogBox(widget.cart[widget.pcode].Quantity.toString());} ,
                      
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(25))),
                          color: Colors.red,
                          
                          child: Align(alignment: Alignment.center,child: Text('Custom', style: Theme.of(context).primaryTextTheme.titleSmall,)),
                        ),
                      ),
                    ),
                  ),
            ],),
          )
        ],
      ),)
    );
    
  }
}