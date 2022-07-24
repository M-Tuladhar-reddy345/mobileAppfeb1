// ignore_for_file: missing_return, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/widgets/Appbar.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:convert';
import '../widgets/navbar.dart' as navbar;
class Subscriptions extends StatefulWidget {

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  getSubscriptions() async {
    final url = Uri.parse(main.url_start +
        'mobileApp/getSubscriptions/' +
        main.storage.getItem('phone') +
        '/'+main.storage.getItem('branch').toString()+'/');
    final response = await http.get(url);//, body: {'phone':main.storage.getItem('phone'), 'type':type,'branch':main.storage.getItem('branch')});
    // print(url);


    if (response.statusCode == 200) {
      // print(response.body);
      var data = json.decode(response.body) as Map;
      

      // List Products =
      //     data['results'].map((json) => models.product.fromjson(json)).toList();
      
    
         
         
      return data['subscriptionsCusomter'];
    }
  }
  cancelDay(subtype,qty,endDate,subid){
    TextEditingController quantity =  TextEditingController();
    DateTime enddate = DateTime.parse(endDate.toString());
    quantity.text = qty;
    showDialog(context: context, builder: (context)=> AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width-20,
        
        child: SingleChildScrollView(
          child: Column(
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
                          child: Text(subtype, style: Theme.of(context).primaryTextTheme.titleMedium,),
                        ),
                      ),
                    ),
                  )
                ],
              ),
             
              
              // Row(children: [Text('Total per day: Rs.'),Container(child: Center(child: Text(widget.TTlamt.toString())), color: Colors.white, width: 100,), ]),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Text('Select date to be canceled ', style: TextStyle(fontWeight: FontWeight.w900),),
                    SfDateRangePicker(
                      onSelectionChanged: ( DateRangePickerSelectionChangedArgs args ){
                        enddate = args.value;
                        },
                      selectionMode: DateRangePickerSelectionMode.single,
                      minDate: DateTime.now(),                    
                      maxDate: enddate,
                      //initialSelectedRange: PickerDateRange(DateTime.now(),DateTime.now().add(Duration(days: 30 ))),
                      initialSelectedDate: enddate,
                    ),
                    
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                // ignore: dead_code
                child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),onPressed:false? null: () async{
                  
                  Map body = {
                    'branch':main.storage.getItem('branch'),
                    'quantity':quantity.text,
                    
                    'date':DateFormat('d-M-y').format(enddate),
                    'subscrId': subid.toString(),
        
                    };
                    print(body);
                  final response = await http.post(Uri.parse(main.url_start+'mobileApp/cancelDay/'), body: body);
                 
                  if (response.statusCode == 200){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Subscriptions()));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully updated subscription'),backgroundColor: Colors.green,));
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
        ),
      ),
    ));
  }
  editSubscriptions_dialog(subtype,qty,endDate,subid){
    TextEditingController quantity =  TextEditingController();
    DateTime enddate = DateTime.parse(endDate.toString());
    quantity.text = qty;
    showDialog(context: context, builder: (context)=> AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width-20,
        
        child: SingleChildScrollView(
          child: Column(
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
                          child: Text(subtype, style: Theme.of(context).primaryTextTheme.titleMedium,),
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
                     
                    },
                    decoration: InputDecoration(labelText: 'Quantity'),
                  controller: quantity,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
            ),
            
                ),
              ),
              // Row(children: [Text('Total per day: Rs.'),Container(child: Center(child: Text(widget.TTlamt.toString())), color: Colors.white, width: 100,), ]),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Text('Select end date ', style: TextStyle(fontWeight: FontWeight.w900),),
                    SfDateRangePicker(
                      onSelectionChanged: ( DateRangePickerSelectionChangedArgs args ){
                        enddate = args.value;
                        },
                      selectionMode: DateRangePickerSelectionMode.single,
                      minDate: DateTime.now(),                    
                      maxDate: enddate,
                      //initialSelectedRange: PickerDateRange(DateTime.now(),DateTime.now().add(Duration(days: 30 ))),
                      initialSelectedDate: enddate,
                    ),
                    
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                // ignore: dead_code
                child: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),onPressed:false? null: () async{
                  
                  Map body = {
                    'branch':main.storage.getItem('branch'),
                    'quantity':quantity.text,
                    
                    'enddate':DateFormat('d-M-y').format(enddate),
                    'subscrId': subid.toString(),
        
                    };
                    print(body);
                  final response = await http.post(Uri.parse(main.url_start+'mobileApp/editSubscriptions/'), body: body);
                 
                  if (response.statusCode == 200){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Subscriptions()));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully updated subscription'),backgroundColor: Colors.green,));
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
        ),
      ),
    ));
  }
  showDates(dates, subtype){
    showDialog(context: context, builder: (context)=> AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width-20,
      
        child: Column(
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
                        child: Text(subtype, style: Theme.of(context).primaryTextTheme.titleMedium,),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SfDateRangePicker(
                  onSelectionChanged: null,
                  selectionMode: DateRangePickerSelectionMode.multiple,
                  initialSelectedDates: dates,   
                                                           
                                                ),
          ],
        ),
      ),
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbar.Navbar(),
      appBar: AppBarCustom('Subscriptions', Size(MediaQuery.of(context).size.width,56)),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            
            FutureBuilder(builder: (context, snapshot) {
               switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                                      return Center(
                                        child: Container(
                                          width: 30,
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                  case ConnectionState.done:
                  print(snapshot.data == []);
                                    if(snapshot.data != null || snapshot.data != [] ){
                                      final data = snapshot.data as List;
                                                 
                                      return Column(
                                        children: data.reversed.map<Widget>((valueDict){ 
                                          List<DateTime> dates = [];
                                          List Ddates = valueDict['DelDay'] as List;   
                                          Ddates.forEach((e) {
                                            print('67');
                                            print(e);
                                            dates.add(DateTime.parse(e.toString()));
                                          },);
                                          print(dates);
                                          return GestureDetector(
                                          //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>Orderpage(valueDict['orderNo'].toString()))),
                                          child: Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                          color: Theme.of(context).primaryColor,
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: 400,
                                              decoration:BoxDecoration(),
                                              child: Column(
                                                children: [
                                                  
                                                  Align(alignment:Alignment.topCenter, child: Row(children: [
                                                    Padding(
                           padding: const EdgeInsets.all(8.0),
                           child:  Container(height: 100,width: 100,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/prodtypes/'+valueDict['pimage'].toString()),fit:BoxFit.fill ))),
                         ), 
                         Align(alignment: Alignment.topCenter,child: Expanded(child: Text(valueDict['product'].toString(),style: Theme.of(context).primaryTextTheme.titleMedium,)))
                                                  ],), ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('subscription type :', style: Theme.of(context).primaryTextTheme.titleSmall,), Text(valueDict['subType'], style: Theme.of(context).primaryTextTheme.titleSmall)],),                          
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('quantity :', style: Theme.of(context).primaryTextTheme.titleSmall), Text(valueDict['quantity'].toString(), style: Theme.of(context).primaryTextTheme.titleSmall)],),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Amount per day :', style: Theme.of(context).primaryTextTheme.titleSmall), Text(valueDict['ttlamtperDay'].toString(), style: Theme.of(context).primaryTextTheme.titleSmall) ],),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Status :', style: Theme.of(context).primaryTextTheme.titleSmall), Text(valueDict['status'].toString(), style: Theme.of(context).primaryTextTheme.titleSmall) ],),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Start Date :', style: Theme.of(context).primaryTextTheme.titleSmall), Text(valueDict['startDate'].toString(), style: Theme.of(context).primaryTextTheme.titleSmall) ],),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('End Date :', style: Theme.of(context).primaryTextTheme.titleSmall), Text(valueDict['endDate'].toString(), style: Theme.of(context).primaryTextTheme.titleSmall) ],),  
                        ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent)),
                        onPressed: ()=>showDates(dates,valueDict['subType'].toString()), child: Text('Dates ',style: Theme.of(context).primaryTextTheme.titleSmall,)),
                        Expanded(child: Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Container(
                                                      height: 50,
                                                      child: ButtonBar(
                                                        children: [FlatButton(minWidth: (MediaQuery.of(context).size.width - 100 )/2,onPressed: ()=>cancelDay(valueDict['subType'], valueDict['quantity'].toString(), valueDict['endDate'].toString(), valueDict['subscrid'].toString()), child: Text('Cancel a Date',style: Theme.of(context).primaryTextTheme.titleSmall,)),VerticalDivider(thickness: 2,),FlatButton(minWidth: (MediaQuery.of(context).size.width - 100 )/2,onPressed: ()=>editSubscriptions_dialog(valueDict['subType'], valueDict['quantity'].toString(), valueDict['endDate'].toString(), valueDict['subscrid'].toString()), child: Text('Edit',style: Theme.of(context).primaryTextTheme.titleSmall,)) ],
                                                      ),
                                                    ),
                                                  ))
                                                ],
                                              )

                                              )
                                          )
                                          ),
                                    );}).toList(),
                                      );
                                      //child: Flexible(child: Text(snapshot.data.toString())),);
                                    }else{return  Container(child: Text('There are no subscriptions made',style: TextStyle(color: Colors.black),),);}
                       break;             
                 case ConnectionState.none:
                   // TODO: Handle this case.
                   break;
                 case ConnectionState.active:
                   // TODO: Handle this case.
                   break;
            }}
              ,future: getSubscriptions(),),
          ],
        ),
      ),
    );
  }
}