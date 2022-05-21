import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/commonApi/commonApi.dart';
import 'package:flutter_complete_guide/widgets/Appbar.dart';

import '../widgets/navbar.dart' as navbar;
class Transactions extends StatefulWidget {
  String transactionType;
  Transactions(this.transactionType);
  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navbar.Navbar(),
      appBar: AppBarCustom('Transactions', Size(MediaQuery.of(context).size.width,56)),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(color: Theme.of(context).primaryColor,child: Center(child: Text(widget.transactionType+' Transactions', style: Theme.of(context).primaryTextTheme.titleLarge,)), width: MediaQuery.of(context).size.width,),
          // ignore: missing_return
          FutureBuilder(future: getTransactions(widget.transactionType),builder: ((context, snapshot) {
            switch (snapshot.connectionState){
            
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
                return Center(child: Text('No transactions found'),);
              }else{
                return ListView(
                  shrinkWrap: true,
                  
                  children: snapshot.data.map<Widget>((e)=>
                  Card(color: Colors.red,child:Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Text.rich(TextSpan(children : [TextSpan(text: 'Transaction_id: ', style: Theme.of(context).primaryTextTheme.titleSmall),TextSpan(text: e['transaction_id'], style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(fontWeight: FontWeight.w900)),])),
                    Text.rich(TextSpan(children : [TextSpan(text: 'Date: ', style: Theme.of(context).primaryTextTheme.titleSmall),TextSpan(text: e['date'], style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(fontWeight: FontWeight.w900)),])),
                    Text.rich(TextSpan(children : [TextSpan(text: 'Amount: ', style: Theme.of(context).primaryTextTheme.titleSmall),TextSpan(text: e['amount'].toString(), style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(fontWeight: FontWeight.w900)),])),
                    Text.rich(TextSpan(children : [TextSpan(text: 'Type: ', style: Theme.of(context).primaryTextTheme.titleSmall),TextSpan(text: e['type'], style: Theme.of(context).primaryTextTheme.titleMedium.copyWith(fontWeight: FontWeight.w900)),])),
                    ],),
                  ) )
                  ).toList(),
                );}
                break;
            }
          }))
        ]),
      ),
    );
  }
}