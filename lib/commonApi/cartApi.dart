import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models.dart';

void updatecart() async {
     List products = storage.getItem('cart').values.map(( e){
                        return {'pcode': e.product, 'quantity': e.Quantity};
                      }).toList();
                      final body = {
                        'phone':storage.getItem('phone'),
                      'ttlAmt': storage.getItem('ttl'),
                      'cartProds': storage.getItem('products'),
                      'products':products
                    };
                    print(body);
                    var url = Uri.parse(url_start +
                        'mobileApp/Updatecart/' );
                    await http.post(url,
                        headers: {"Content-Type": "application/json"},
                        encoding: Encoding.getByName("utf-8"),
                        body: json.encode(body));
                       
  }
  getCart() async{
    final body = {
      'phone': storage.getItem('phone')
    };
    print(storage.getItem('phone'));
    final url = Uri.parse(url_start +
        'mobileApp/getCart/' );
    final response = await http.post(url, body: body);
    if (response.statusCode == 200){
      final data = json.decode(response.body) as Map;
      print(data);
      Map<String,Customerprod> cart = {};
      
      int totalqty = 0;
      
      if (data['products'] == ''){
      storage.setItem('ttl', data['ttl']);
      storage.setItem('ttlqty', totalqty);
      storage.setItem('products', data['cartprods']);
      storage.setItem('cart',  <String,Customerprod> {} );}else{
        List products = data['products'] as List;
       for (var e in products){
        print(e);
        totalqty = totalqty + int.parse(e['quantity'].toString());
        cart.putIfAbsent(e['pcode'], () => Customerprod(
                        e['pcode'].toString(),
                        e['ptype'].toString(),
                        e['unitRate'].toString(),
                        e['quantity'].toString(),
                        e['amount'].toString(),
                        e['pimage'].toString(),
                        e['pname'].toString()),);
      }
      print("@89");
      print(cart);
 storage.setItem('ttl', data['ttl']);
      storage.setItem('products', data['cartprods']);
      storage.setItem('cart',  cart);

      storage.setItem('ttlqty', totalqty.toString());
      
      }
      print([data['ttl'], data['cartprods']]);
      return [data['ttl'], data['cartprods']];}
      
  }