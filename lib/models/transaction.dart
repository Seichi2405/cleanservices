class TransactionStatus {
  String? _idTransaction;
  String? _idAppointment;
  String? _paymentMethod;
  String? _statusPay;

  TransactionStatus(
      {String? idTransaction,
      String? idAppointment,
      String? paymentMethod,
      String? statusPay}) {
    if (idTransaction != null) {
      this._idTransaction = idTransaction;
    }
    if (idAppointment != null) {
      this._idAppointment = idAppointment;
    }
    if (paymentMethod != null) {
      this._paymentMethod = paymentMethod;
    }
    if (statusPay != null) {
      this._statusPay = statusPay;
    }
  }

  String? get idTransaction => _idTransaction;
  set idTransaction(String? idTransaction) => _idTransaction = idTransaction;
  String? get idAppointment => _idAppointment;
  set idAppointment(String? idAppointment) => _idAppointment = idAppointment;
  String? get paymentMethod => _paymentMethod;
  set paymentMethod(String? paymentMethod) => _paymentMethod = paymentMethod;
  String? get statusPay => _statusPay;
  set statusPay(String? statusPay) => _statusPay = statusPay;

  TransactionStatus.fromJson(Map<String, dynamic> json) {
    _idTransaction = json['id_transaction'];
    _idAppointment = json['id_appointment'];
    _paymentMethod = json['payment_method'];
    _statusPay = json['status_pay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_transaction'] = this._idTransaction;
    data['id_appointment'] = this._idAppointment;
    data['payment_method'] = this._paymentMethod;
    data['status_pay'] = this._statusPay;
    return data;
  }
}
