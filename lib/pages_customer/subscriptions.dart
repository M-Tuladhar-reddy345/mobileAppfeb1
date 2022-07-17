// ignore_for_file: missing_return, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/Appbar.dart';
import 'package:flutter_complete_guide/main.dart' as main;
import 'package:http/http.dart' as http;
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
  showDates(dates){
    print(dates);
    showDialog(context: context, builder: (context)=> AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width-20,
      
        child: Column(
          children: [
            SfDateRangePicker(
                                                  // onSelectionChanged: widget.selectedDates.length <= 5? _onSelectionChanged:null,
                  selectionMode: DateRangePickerSelectionMode.multiple,
                  initialSelectedDates: dates,             
                  showTodayButton: false,                             
                              
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
                        onPressed: ()=>showDates(dates), child: Text('Dates ',style: Theme.of(context).primaryTextTheme.titleSmall,)),
                        Expanded(child: Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: Container(
                                                      height: 50,
                                                      child: ButtonBar(
                                                        children: [FlatButton(minWidth: (MediaQuery.of(context).size.width - 100 )/2,onPressed: (){}, child: Text('Resume',style: Theme.of(context).primaryTextTheme.titleSmall,)),VerticalDivider(thickness: 2,),FlatButton(minWidth: (MediaQuery.of(context).size.width - 100 )/2,onPressed: (){}, child: Text('Edit',style: Theme.of(context).primaryTextTheme.titleSmall,)) ],
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