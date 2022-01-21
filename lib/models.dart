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
