import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Customer {
  String custName;
  String Osamt;
  String custCode;
  // String label = custName.toString() +
  //     '-' +
  //     custCode.toString() +
  //     '-' +
  //     Osamt.toString();
  Customer(this.custName, this.custCode, this.Osamt);

  factory Customer.fromjson(Map<String, dynamic> json) {
    return Customer(
        json['custName'], json['custCode'], json['Osamt'].toString());
  }
}

class Branch {
  String branch;
  String code;
  String address;
  // String label = custName.toString() +
  //     '-' +
  //     custCode.toString() +
  //     '-' +
  //     Osamt.toString();
  Branch(this.branch, this.code, this.address);

  factory Branch.fromjson(Map<String, dynamic> json) {
    return Branch(json['branch'], json['code'], json['address']);
  }
}

class product {
  String name;
  String code;
  String UnitRate;
  product(this.name, this.code, this.UnitRate);

  factory product.fromjson(Map<String, dynamic> json) {
    // print(json);
    return product(json['Name'], json['Code'], json['Unit']);
  }
}

class order_product_indent {
  DateTime date;
  String orderNo;
  String product;
  String UnitRate;
  String Quantity;
  String Discount;
  String Amount;
  String Remarks;
  String custcode;
  String no;
  order_product_indent(
      this.date,
      this.product,
      this.orderNo,
      this.UnitRate,
      this.Quantity,
      this.Discount,
      this.Amount,
      this.Remarks,
      this.custcode,
      this.no);
// ignore: missing_return
  factory order_product_indent.fromjson(Map<String, dynamic> e) {
    return order_product_indent(
        DateTime.now(),
        e['product'].toString(),
        e['orderNo'].toString(),
        e['UnitRate'].toString(),
        e['qty'].toString(),
        e['disc'].toString(),
        e['amt'].toString(),
        e['remarks'].toString(),
        e['custcode'].toString(),
        0.toString());
  }
  get_dict() {
    final returnn = {
      'date': DateFormat("y-M-d").format(this.date),
      'time': DateFormat("HH:mm").format(this.date),
      'orderNo': this.orderNo,
      'product': this.product,
      'UnitRate': this.UnitRate,
      'qty': this.Quantity,
      'disc': this.Discount,
      'amt': this.Amount,
      'remarks': this.Remarks,
      'custcode': this.custcode,
    };
    return returnn;
  }

  void update_orderNo(orderno) {
    this.orderNo = orderno;
  }

  void update_date(date) {
    this.date = date;
  }
}
