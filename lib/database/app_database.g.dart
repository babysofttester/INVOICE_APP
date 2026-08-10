// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $InvoicesTable extends Invoices
    with TableInfo<$InvoicesTable, InvoiceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
      'number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _customerPhoneMeta =
      const VerificationMeta('customerPhone');
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
      'customer_phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _customerAddressMeta =
      const VerificationMeta('customerAddress');
  @override
  late final GeneratedColumn<String> customerAddress = GeneratedColumn<String>(
      'customer_address', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalDiscountMeta =
      const VerificationMeta('totalDiscount');
  @override
  late final GeneratedColumn<double> totalDiscount = GeneratedColumn<double>(
      'total_discount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _grandTotalMeta =
      const VerificationMeta('grandTotal');
  @override
  late final GeneratedColumn<double> grandTotal = GeneratedColumn<double>(
      'grand_total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _paymentModeMeta =
      const VerificationMeta('paymentMode');
  @override
  late final GeneratedColumn<String> paymentMode = GeneratedColumn<String>(
      'payment_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unpaid'));
  static const VerificationMeta _businessNameMeta =
      const VerificationMeta('businessName');
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
      'business_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Your Business Name'));
  static const VerificationMeta _businessSubtitleMeta =
      const VerificationMeta('businessSubtitle');
  @override
  late final GeneratedColumn<String> businessSubtitle = GeneratedColumn<String>(
      'business_subtitle', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _businessPhoneMeta =
      const VerificationMeta('businessPhone');
  @override
  late final GeneratedColumn<String> businessPhone = GeneratedColumn<String>(
      'business_phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _businessAddressMeta =
      const VerificationMeta('businessAddress');
  @override
  late final GeneratedColumn<String> businessAddress = GeneratedColumn<String>(
      'business_address', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _businessLogoBase64Meta =
      const VerificationMeta('businessLogoBase64');
  @override
  late final GeneratedColumn<String> businessLogoBase64 =
      GeneratedColumn<String>('business_logo_base64', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  static const VerificationMeta _pdfBase64Meta =
      const VerificationMeta('pdfBase64');
  @override
  late final GeneratedColumn<String> pdfBase64 = GeneratedColumn<String>(
      'pdf_base64', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        number,
        date,
        customerName,
        customerPhone,
        customerAddress,
        subtotal,
        totalDiscount,
        grandTotal,
        paymentMode,
        businessName,
        businessSubtitle,
        businessPhone,
        businessAddress,
        businessLogoBase64,
        pdfBase64
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(Insertable<InvoiceRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
          _customerPhoneMeta,
          customerPhone.isAcceptableOrUnknown(
              data['customer_phone']!, _customerPhoneMeta));
    }
    if (data.containsKey('customer_address')) {
      context.handle(
          _customerAddressMeta,
          customerAddress.isAcceptableOrUnknown(
              data['customer_address']!, _customerAddressMeta));
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    }
    if (data.containsKey('total_discount')) {
      context.handle(
          _totalDiscountMeta,
          totalDiscount.isAcceptableOrUnknown(
              data['total_discount']!, _totalDiscountMeta));
    }
    if (data.containsKey('grand_total')) {
      context.handle(
          _grandTotalMeta,
          grandTotal.isAcceptableOrUnknown(
              data['grand_total']!, _grandTotalMeta));
    }
    if (data.containsKey('payment_mode')) {
      context.handle(
          _paymentModeMeta,
          paymentMode.isAcceptableOrUnknown(
              data['payment_mode']!, _paymentModeMeta));
    }
    if (data.containsKey('business_name')) {
      context.handle(
          _businessNameMeta,
          businessName.isAcceptableOrUnknown(
              data['business_name']!, _businessNameMeta));
    }
    if (data.containsKey('business_subtitle')) {
      context.handle(
          _businessSubtitleMeta,
          businessSubtitle.isAcceptableOrUnknown(
              data['business_subtitle']!, _businessSubtitleMeta));
    }
    if (data.containsKey('business_phone')) {
      context.handle(
          _businessPhoneMeta,
          businessPhone.isAcceptableOrUnknown(
              data['business_phone']!, _businessPhoneMeta));
    }
    if (data.containsKey('business_address')) {
      context.handle(
          _businessAddressMeta,
          businessAddress.isAcceptableOrUnknown(
              data['business_address']!, _businessAddressMeta));
    }
    if (data.containsKey('business_logo_base64')) {
      context.handle(
          _businessLogoBase64Meta,
          businessLogoBase64.isAcceptableOrUnknown(
              data['business_logo_base64']!, _businessLogoBase64Meta));
    }
    if (data.containsKey('pdf_base64')) {
      context.handle(_pdfBase64Meta,
          pdfBase64.isAcceptableOrUnknown(data['pdf_base64']!, _pdfBase64Meta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}number'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name'])!,
      customerPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_phone'])!,
      customerAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}customer_address'])!,
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      totalDiscount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_discount'])!,
      grandTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}grand_total'])!,
      paymentMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_mode'])!,
      businessName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_name'])!,
      businessSubtitle: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}business_subtitle'])!,
      businessPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_phone'])!,
      businessAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}business_address'])!,
      businessLogoBase64: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}business_logo_base64'])!,
      pdfBase64: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pdf_base64'])!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class InvoiceRow extends DataClass implements Insertable<InvoiceRow> {
  final String id;
  final String number;
  final DateTime date;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final double subtotal;
  final double totalDiscount;
  final double grandTotal;
  final String paymentMode;
  final String businessName;
  final String businessSubtitle;
  final String businessPhone;
  final String businessAddress;
  final String businessLogoBase64;
  final String pdfBase64;
  const InvoiceRow(
      {required this.id,
      required this.number,
      required this.date,
      required this.customerName,
      required this.customerPhone,
      required this.customerAddress,
      required this.subtotal,
      required this.totalDiscount,
      required this.grandTotal,
      required this.paymentMode,
      required this.businessName,
      required this.businessSubtitle,
      required this.businessPhone,
      required this.businessAddress,
      required this.businessLogoBase64,
      required this.pdfBase64});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['number'] = Variable<String>(number);
    map['date'] = Variable<DateTime>(date);
    map['customer_name'] = Variable<String>(customerName);
    map['customer_phone'] = Variable<String>(customerPhone);
    map['customer_address'] = Variable<String>(customerAddress);
    map['subtotal'] = Variable<double>(subtotal);
    map['total_discount'] = Variable<double>(totalDiscount);
    map['grand_total'] = Variable<double>(grandTotal);
    map['payment_mode'] = Variable<String>(paymentMode);
    map['business_name'] = Variable<String>(businessName);
    map['business_subtitle'] = Variable<String>(businessSubtitle);
    map['business_phone'] = Variable<String>(businessPhone);
    map['business_address'] = Variable<String>(businessAddress);
    map['business_logo_base64'] = Variable<String>(businessLogoBase64);
    map['pdf_base64'] = Variable<String>(pdfBase64);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      number: Value(number),
      date: Value(date),
      customerName: Value(customerName),
      customerPhone: Value(customerPhone),
      customerAddress: Value(customerAddress),
      subtotal: Value(subtotal),
      totalDiscount: Value(totalDiscount),
      grandTotal: Value(grandTotal),
      paymentMode: Value(paymentMode),
      businessName: Value(businessName),
      businessSubtitle: Value(businessSubtitle),
      businessPhone: Value(businessPhone),
      businessAddress: Value(businessAddress),
      businessLogoBase64: Value(businessLogoBase64),
      pdfBase64: Value(pdfBase64),
    );
  }

  factory InvoiceRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceRow(
      id: serializer.fromJson<String>(json['id']),
      number: serializer.fromJson<String>(json['number']),
      date: serializer.fromJson<DateTime>(json['date']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerPhone: serializer.fromJson<String>(json['customerPhone']),
      customerAddress: serializer.fromJson<String>(json['customerAddress']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      totalDiscount: serializer.fromJson<double>(json['totalDiscount']),
      grandTotal: serializer.fromJson<double>(json['grandTotal']),
      paymentMode: serializer.fromJson<String>(json['paymentMode']),
      businessName: serializer.fromJson<String>(json['businessName']),
      businessSubtitle: serializer.fromJson<String>(json['businessSubtitle']),
      businessPhone: serializer.fromJson<String>(json['businessPhone']),
      businessAddress: serializer.fromJson<String>(json['businessAddress']),
      businessLogoBase64:
          serializer.fromJson<String>(json['businessLogoBase64']),
      pdfBase64: serializer.fromJson<String>(json['pdfBase64']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'number': serializer.toJson<String>(number),
      'date': serializer.toJson<DateTime>(date),
      'customerName': serializer.toJson<String>(customerName),
      'customerPhone': serializer.toJson<String>(customerPhone),
      'customerAddress': serializer.toJson<String>(customerAddress),
      'subtotal': serializer.toJson<double>(subtotal),
      'totalDiscount': serializer.toJson<double>(totalDiscount),
      'grandTotal': serializer.toJson<double>(grandTotal),
      'paymentMode': serializer.toJson<String>(paymentMode),
      'businessName': serializer.toJson<String>(businessName),
      'businessSubtitle': serializer.toJson<String>(businessSubtitle),
      'businessPhone': serializer.toJson<String>(businessPhone),
      'businessAddress': serializer.toJson<String>(businessAddress),
      'businessLogoBase64': serializer.toJson<String>(businessLogoBase64),
      'pdfBase64': serializer.toJson<String>(pdfBase64),
    };
  }

  InvoiceRow copyWith(
          {String? id,
          String? number,
          DateTime? date,
          String? customerName,
          String? customerPhone,
          String? customerAddress,
          double? subtotal,
          double? totalDiscount,
          double? grandTotal,
          String? paymentMode,
          String? businessName,
          String? businessSubtitle,
          String? businessPhone,
          String? businessAddress,
          String? businessLogoBase64,
          String? pdfBase64}) =>
      InvoiceRow(
        id: id ?? this.id,
        number: number ?? this.number,
        date: date ?? this.date,
        customerName: customerName ?? this.customerName,
        customerPhone: customerPhone ?? this.customerPhone,
        customerAddress: customerAddress ?? this.customerAddress,
        subtotal: subtotal ?? this.subtotal,
        totalDiscount: totalDiscount ?? this.totalDiscount,
        grandTotal: grandTotal ?? this.grandTotal,
        paymentMode: paymentMode ?? this.paymentMode,
        businessName: businessName ?? this.businessName,
        businessSubtitle: businessSubtitle ?? this.businessSubtitle,
        businessPhone: businessPhone ?? this.businessPhone,
        businessAddress: businessAddress ?? this.businessAddress,
        businessLogoBase64: businessLogoBase64 ?? this.businessLogoBase64,
        pdfBase64: pdfBase64 ?? this.pdfBase64,
      );
  InvoiceRow copyWithCompanion(InvoicesCompanion data) {
    return InvoiceRow(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      date: data.date.present ? data.date.value : this.date,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      customerAddress: data.customerAddress.present
          ? data.customerAddress.value
          : this.customerAddress,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      totalDiscount: data.totalDiscount.present
          ? data.totalDiscount.value
          : this.totalDiscount,
      grandTotal:
          data.grandTotal.present ? data.grandTotal.value : this.grandTotal,
      paymentMode:
          data.paymentMode.present ? data.paymentMode.value : this.paymentMode,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      businessSubtitle: data.businessSubtitle.present
          ? data.businessSubtitle.value
          : this.businessSubtitle,
      businessPhone: data.businessPhone.present
          ? data.businessPhone.value
          : this.businessPhone,
      businessAddress: data.businessAddress.present
          ? data.businessAddress.value
          : this.businessAddress,
      businessLogoBase64: data.businessLogoBase64.present
          ? data.businessLogoBase64.value
          : this.businessLogoBase64,
      pdfBase64: data.pdfBase64.present ? data.pdfBase64.value : this.pdfBase64,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceRow(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('date: $date, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('customerAddress: $customerAddress, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalDiscount: $totalDiscount, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('businessName: $businessName, ')
          ..write('businessSubtitle: $businessSubtitle, ')
          ..write('businessPhone: $businessPhone, ')
          ..write('businessAddress: $businessAddress, ')
          ..write('businessLogoBase64: $businessLogoBase64, ')
          ..write('pdfBase64: $pdfBase64')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      number,
      date,
      customerName,
      customerPhone,
      customerAddress,
      subtotal,
      totalDiscount,
      grandTotal,
      paymentMode,
      businessName,
      businessSubtitle,
      businessPhone,
      businessAddress,
      businessLogoBase64,
      pdfBase64);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceRow &&
          other.id == this.id &&
          other.number == this.number &&
          other.date == this.date &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.customerAddress == this.customerAddress &&
          other.subtotal == this.subtotal &&
          other.totalDiscount == this.totalDiscount &&
          other.grandTotal == this.grandTotal &&
          other.paymentMode == this.paymentMode &&
          other.businessName == this.businessName &&
          other.businessSubtitle == this.businessSubtitle &&
          other.businessPhone == this.businessPhone &&
          other.businessAddress == this.businessAddress &&
          other.businessLogoBase64 == this.businessLogoBase64 &&
          other.pdfBase64 == this.pdfBase64);
}

class InvoicesCompanion extends UpdateCompanion<InvoiceRow> {
  final Value<String> id;
  final Value<String> number;
  final Value<DateTime> date;
  final Value<String> customerName;
  final Value<String> customerPhone;
  final Value<String> customerAddress;
  final Value<double> subtotal;
  final Value<double> totalDiscount;
  final Value<double> grandTotal;
  final Value<String> paymentMode;
  final Value<String> businessName;
  final Value<String> businessSubtitle;
  final Value<String> businessPhone;
  final Value<String> businessAddress;
  final Value<String> businessLogoBase64;
  final Value<String> pdfBase64;
  final Value<int> rowid;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.date = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.customerAddress = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.totalDiscount = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.businessName = const Value.absent(),
    this.businessSubtitle = const Value.absent(),
    this.businessPhone = const Value.absent(),
    this.businessAddress = const Value.absent(),
    this.businessLogoBase64 = const Value.absent(),
    this.pdfBase64 = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoicesCompanion.insert({
    required String id,
    required String number,
    required DateTime date,
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.customerAddress = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.totalDiscount = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.businessName = const Value.absent(),
    this.businessSubtitle = const Value.absent(),
    this.businessPhone = const Value.absent(),
    this.businessAddress = const Value.absent(),
    this.businessLogoBase64 = const Value.absent(),
    this.pdfBase64 = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        number = Value(number),
        date = Value(date);
  static Insertable<InvoiceRow> custom({
    Expression<String>? id,
    Expression<String>? number,
    Expression<DateTime>? date,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<String>? customerAddress,
    Expression<double>? subtotal,
    Expression<double>? totalDiscount,
    Expression<double>? grandTotal,
    Expression<String>? paymentMode,
    Expression<String>? businessName,
    Expression<String>? businessSubtitle,
    Expression<String>? businessPhone,
    Expression<String>? businessAddress,
    Expression<String>? businessLogoBase64,
    Expression<String>? pdfBase64,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (date != null) 'date': date,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (customerAddress != null) 'customer_address': customerAddress,
      if (subtotal != null) 'subtotal': subtotal,
      if (totalDiscount != null) 'total_discount': totalDiscount,
      if (grandTotal != null) 'grand_total': grandTotal,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (businessName != null) 'business_name': businessName,
      if (businessSubtitle != null) 'business_subtitle': businessSubtitle,
      if (businessPhone != null) 'business_phone': businessPhone,
      if (businessAddress != null) 'business_address': businessAddress,
      if (businessLogoBase64 != null)
        'business_logo_base64': businessLogoBase64,
      if (pdfBase64 != null) 'pdf_base64': pdfBase64,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoicesCompanion copyWith(
      {Value<String>? id,
      Value<String>? number,
      Value<DateTime>? date,
      Value<String>? customerName,
      Value<String>? customerPhone,
      Value<String>? customerAddress,
      Value<double>? subtotal,
      Value<double>? totalDiscount,
      Value<double>? grandTotal,
      Value<String>? paymentMode,
      Value<String>? businessName,
      Value<String>? businessSubtitle,
      Value<String>? businessPhone,
      Value<String>? businessAddress,
      Value<String>? businessLogoBase64,
      Value<String>? pdfBase64,
      Value<int>? rowid}) {
    return InvoicesCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      date: date ?? this.date,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      subtotal: subtotal ?? this.subtotal,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMode: paymentMode ?? this.paymentMode,
      businessName: businessName ?? this.businessName,
      businessSubtitle: businessSubtitle ?? this.businessSubtitle,
      businessPhone: businessPhone ?? this.businessPhone,
      businessAddress: businessAddress ?? this.businessAddress,
      businessLogoBase64: businessLogoBase64 ?? this.businessLogoBase64,
      pdfBase64: pdfBase64 ?? this.pdfBase64,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (customerAddress.present) {
      map['customer_address'] = Variable<String>(customerAddress.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (totalDiscount.present) {
      map['total_discount'] = Variable<double>(totalDiscount.value);
    }
    if (grandTotal.present) {
      map['grand_total'] = Variable<double>(grandTotal.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(paymentMode.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (businessSubtitle.present) {
      map['business_subtitle'] = Variable<String>(businessSubtitle.value);
    }
    if (businessPhone.present) {
      map['business_phone'] = Variable<String>(businessPhone.value);
    }
    if (businessAddress.present) {
      map['business_address'] = Variable<String>(businessAddress.value);
    }
    if (businessLogoBase64.present) {
      map['business_logo_base64'] = Variable<String>(businessLogoBase64.value);
    }
    if (pdfBase64.present) {
      map['pdf_base64'] = Variable<String>(pdfBase64.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('date: $date, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('customerAddress: $customerAddress, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalDiscount: $totalDiscount, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('businessName: $businessName, ')
          ..write('businessSubtitle: $businessSubtitle, ')
          ..write('businessPhone: $businessPhone, ')
          ..write('businessAddress: $businessAddress, ')
          ..write('businessLogoBase64: $businessLogoBase64, ')
          ..write('pdfBase64: $pdfBase64, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoiceItemsTable extends InvoiceItems
    with TableInfo<$InvoiceItemsTable, InvoiceItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES invoices (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
      'qty', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [itemId, invoiceId, name, price, qty, discount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_items';
  @override
  VerificationContext validateIntegrity(Insertable<InvoiceItemRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
          _qtyMeta, qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta));
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    } else if (isInserting) {
      context.missing(_discountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  InvoiceItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceItemRow(
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      qty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}qty'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
    );
  }

  @override
  $InvoiceItemsTable createAlias(String alias) {
    return $InvoiceItemsTable(attachedDatabase, alias);
  }
}

class InvoiceItemRow extends DataClass implements Insertable<InvoiceItemRow> {
  final int itemId;
  final String invoiceId;
  final String name;
  final double price;
  final int qty;
  final double discount;
  const InvoiceItemRow(
      {required this.itemId,
      required this.invoiceId,
      required this.name,
      required this.price,
      required this.qty,
      required this.discount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<int>(itemId);
    map['invoice_id'] = Variable<String>(invoiceId);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['qty'] = Variable<int>(qty);
    map['discount'] = Variable<double>(discount);
    return map;
  }

  InvoiceItemsCompanion toCompanion(bool nullToAbsent) {
    return InvoiceItemsCompanion(
      itemId: Value(itemId),
      invoiceId: Value(invoiceId),
      name: Value(name),
      price: Value(price),
      qty: Value(qty),
      discount: Value(discount),
    );
  }

  factory InvoiceItemRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceItemRow(
      itemId: serializer.fromJson<int>(json['itemId']),
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      qty: serializer.fromJson<int>(json['qty']),
      discount: serializer.fromJson<double>(json['discount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<int>(itemId),
      'invoiceId': serializer.toJson<String>(invoiceId),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'qty': serializer.toJson<int>(qty),
      'discount': serializer.toJson<double>(discount),
    };
  }

  InvoiceItemRow copyWith(
          {int? itemId,
          String? invoiceId,
          String? name,
          double? price,
          int? qty,
          double? discount}) =>
      InvoiceItemRow(
        itemId: itemId ?? this.itemId,
        invoiceId: invoiceId ?? this.invoiceId,
        name: name ?? this.name,
        price: price ?? this.price,
        qty: qty ?? this.qty,
        discount: discount ?? this.discount,
      );
  InvoiceItemRow copyWithCompanion(InvoiceItemsCompanion data) {
    return InvoiceItemRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      qty: data.qty.present ? data.qty.value : this.qty,
      discount: data.discount.present ? data.discount.value : this.discount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItemRow(')
          ..write('itemId: $itemId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('qty: $qty, ')
          ..write('discount: $discount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(itemId, invoiceId, name, price, qty, discount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceItemRow &&
          other.itemId == this.itemId &&
          other.invoiceId == this.invoiceId &&
          other.name == this.name &&
          other.price == this.price &&
          other.qty == this.qty &&
          other.discount == this.discount);
}

class InvoiceItemsCompanion extends UpdateCompanion<InvoiceItemRow> {
  final Value<int> itemId;
  final Value<String> invoiceId;
  final Value<String> name;
  final Value<double> price;
  final Value<int> qty;
  final Value<double> discount;
  const InvoiceItemsCompanion({
    this.itemId = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.qty = const Value.absent(),
    this.discount = const Value.absent(),
  });
  InvoiceItemsCompanion.insert({
    this.itemId = const Value.absent(),
    required String invoiceId,
    required String name,
    required double price,
    required int qty,
    required double discount,
  })  : invoiceId = Value(invoiceId),
        name = Value(name),
        price = Value(price),
        qty = Value(qty),
        discount = Value(discount);
  static Insertable<InvoiceItemRow> custom({
    Expression<int>? itemId,
    Expression<String>? invoiceId,
    Expression<String>? name,
    Expression<double>? price,
    Expression<int>? qty,
    Expression<double>? discount,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (qty != null) 'qty': qty,
      if (discount != null) 'discount': discount,
    });
  }

  InvoiceItemsCompanion copyWith(
      {Value<int>? itemId,
      Value<String>? invoiceId,
      Value<String>? name,
      Value<double>? price,
      Value<int>? qty,
      Value<double>? discount}) {
    return InvoiceItemsCompanion(
      itemId: itemId ?? this.itemId,
      invoiceId: invoiceId ?? this.invoiceId,
      name: name ?? this.name,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      discount: discount ?? this.discount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItemsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('qty: $qty, ')
          ..write('discount: $discount')
          ..write(')'))
        .toString();
  }
}

class $BusinessProfileTableTable extends BusinessProfileTable
    with TableInfo<$BusinessProfileTableTable, BusinessProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessProfileTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Your Business Name'));
  static const VerificationMeta _subtitleMeta =
      const VerificationMeta('subtitle');
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
      'subtitle', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _logoBase64Meta =
      const VerificationMeta('logoBase64');
  @override
  late final GeneratedColumn<String> logoBase64 = GeneratedColumn<String>(
      'logo_base64', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, subtitle, phone, address, logoBase64];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_profile_table';
  @override
  VerificationContext validateIntegrity(Insertable<BusinessProfileRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('subtitle')) {
      context.handle(_subtitleMeta,
          subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('logo_base64')) {
      context.handle(
          _logoBase64Meta,
          logoBase64.isAcceptableOrUnknown(
              data['logo_base64']!, _logoBase64Meta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessProfileRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      subtitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subtitle'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      logoBase64: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_base64'])!,
    );
  }

  @override
  $BusinessProfileTableTable createAlias(String alias) {
    return $BusinessProfileTableTable(attachedDatabase, alias);
  }
}

class BusinessProfileRow extends DataClass
    implements Insertable<BusinessProfileRow> {
  final int id;
  final String name;
  final String subtitle;
  final String phone;
  final String address;
  final String logoBase64;
  const BusinessProfileRow(
      {required this.id,
      required this.name,
      required this.subtitle,
      required this.phone,
      required this.address,
      required this.logoBase64});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['subtitle'] = Variable<String>(subtitle);
    map['phone'] = Variable<String>(phone);
    map['address'] = Variable<String>(address);
    map['logo_base64'] = Variable<String>(logoBase64);
    return map;
  }

  BusinessProfileTableCompanion toCompanion(bool nullToAbsent) {
    return BusinessProfileTableCompanion(
      id: Value(id),
      name: Value(name),
      subtitle: Value(subtitle),
      phone: Value(phone),
      address: Value(address),
      logoBase64: Value(logoBase64),
    );
  }

  factory BusinessProfileRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessProfileRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      subtitle: serializer.fromJson<String>(json['subtitle']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String>(json['address']),
      logoBase64: serializer.fromJson<String>(json['logoBase64']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'subtitle': serializer.toJson<String>(subtitle),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String>(address),
      'logoBase64': serializer.toJson<String>(logoBase64),
    };
  }

  BusinessProfileRow copyWith(
          {int? id,
          String? name,
          String? subtitle,
          String? phone,
          String? address,
          String? logoBase64}) =>
      BusinessProfileRow(
        id: id ?? this.id,
        name: name ?? this.name,
        subtitle: subtitle ?? this.subtitle,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        logoBase64: logoBase64 ?? this.logoBase64,
      );
  BusinessProfileRow copyWithCompanion(BusinessProfileTableCompanion data) {
    return BusinessProfileRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      logoBase64:
          data.logoBase64.present ? data.logoBase64.value : this.logoBase64,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfileRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('subtitle: $subtitle, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('logoBase64: $logoBase64')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, subtitle, phone, address, logoBase64);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessProfileRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.subtitle == this.subtitle &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.logoBase64 == this.logoBase64);
}

class BusinessProfileTableCompanion
    extends UpdateCompanion<BusinessProfileRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> subtitle;
  final Value<String> phone;
  final Value<String> address;
  final Value<String> logoBase64;
  const BusinessProfileTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.logoBase64 = const Value.absent(),
  });
  BusinessProfileTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.logoBase64 = const Value.absent(),
  });
  static Insertable<BusinessProfileRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? subtitle,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? logoBase64,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (subtitle != null) 'subtitle': subtitle,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (logoBase64 != null) 'logo_base64': logoBase64,
    });
  }

  BusinessProfileTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? subtitle,
      Value<String>? phone,
      Value<String>? address,
      Value<String>? logoBase64}) {
    return BusinessProfileTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      logoBase64: logoBase64 ?? this.logoBase64,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (logoBase64.present) {
      map['logo_base64'] = Variable<String>(logoBase64.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfileTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('subtitle: $subtitle, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('logoBase64: $logoBase64')
          ..write(')'))
        .toString();
  }
}

class $DeviceMetaTable extends DeviceMeta
    with TableInfo<$DeviceMetaTable, DeviceMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _installIdMeta =
      const VerificationMeta('installId');
  @override
  late final GeneratedColumn<String> installId = GeneratedColumn<String>(
      'install_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, installId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_meta';
  @override
  VerificationContext validateIntegrity(Insertable<DeviceMetaRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('install_id')) {
      context.handle(_installIdMeta,
          installId.isAcceptableOrUnknown(data['install_id']!, _installIdMeta));
    } else if (isInserting) {
      context.missing(_installIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceMetaRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      installId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}install_id'])!,
    );
  }

  @override
  $DeviceMetaTable createAlias(String alias) {
    return $DeviceMetaTable(attachedDatabase, alias);
  }
}

class DeviceMetaRow extends DataClass implements Insertable<DeviceMetaRow> {
  final int id;
  final String installId;
  const DeviceMetaRow({required this.id, required this.installId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['install_id'] = Variable<String>(installId);
    return map;
  }

  DeviceMetaCompanion toCompanion(bool nullToAbsent) {
    return DeviceMetaCompanion(
      id: Value(id),
      installId: Value(installId),
    );
  }

  factory DeviceMetaRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceMetaRow(
      id: serializer.fromJson<int>(json['id']),
      installId: serializer.fromJson<String>(json['installId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'installId': serializer.toJson<String>(installId),
    };
  }

  DeviceMetaRow copyWith({int? id, String? installId}) => DeviceMetaRow(
        id: id ?? this.id,
        installId: installId ?? this.installId,
      );
  DeviceMetaRow copyWithCompanion(DeviceMetaCompanion data) {
    return DeviceMetaRow(
      id: data.id.present ? data.id.value : this.id,
      installId: data.installId.present ? data.installId.value : this.installId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceMetaRow(')
          ..write('id: $id, ')
          ..write('installId: $installId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, installId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceMetaRow &&
          other.id == this.id &&
          other.installId == this.installId);
}

class DeviceMetaCompanion extends UpdateCompanion<DeviceMetaRow> {
  final Value<int> id;
  final Value<String> installId;
  const DeviceMetaCompanion({
    this.id = const Value.absent(),
    this.installId = const Value.absent(),
  });
  DeviceMetaCompanion.insert({
    this.id = const Value.absent(),
    required String installId,
  }) : installId = Value(installId);
  static Insertable<DeviceMetaRow> custom({
    Expression<int>? id,
    Expression<String>? installId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (installId != null) 'install_id': installId,
    });
  }

  DeviceMetaCompanion copyWith({Value<int>? id, Value<String>? installId}) {
    return DeviceMetaCompanion(
      id: id ?? this.id,
      installId: installId ?? this.installId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (installId.present) {
      map['install_id'] = Variable<String>(installId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceMetaCompanion(')
          ..write('id: $id, ')
          ..write('installId: $installId')
          ..write(')'))
        .toString();
  }
}

class $MigrationStateTable extends MigrationState
    with TableInfo<$MigrationStateTable, MigrationStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MigrationStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _hiveMigratedMeta =
      const VerificationMeta('hiveMigrated');
  @override
  late final GeneratedColumn<bool> hiveMigrated = GeneratedColumn<bool>(
      'hive_migrated', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("hive_migrated" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, hiveMigrated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'migration_state';
  @override
  VerificationContext validateIntegrity(Insertable<MigrationStateRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hive_migrated')) {
      context.handle(
          _hiveMigratedMeta,
          hiveMigrated.isAcceptableOrUnknown(
              data['hive_migrated']!, _hiveMigratedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MigrationStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MigrationStateRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      hiveMigrated: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hive_migrated'])!,
    );
  }

  @override
  $MigrationStateTable createAlias(String alias) {
    return $MigrationStateTable(attachedDatabase, alias);
  }
}

class MigrationStateRow extends DataClass
    implements Insertable<MigrationStateRow> {
  final int id;
  final bool hiveMigrated;
  const MigrationStateRow({required this.id, required this.hiveMigrated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hive_migrated'] = Variable<bool>(hiveMigrated);
    return map;
  }

  MigrationStateCompanion toCompanion(bool nullToAbsent) {
    return MigrationStateCompanion(
      id: Value(id),
      hiveMigrated: Value(hiveMigrated),
    );
  }

  factory MigrationStateRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MigrationStateRow(
      id: serializer.fromJson<int>(json['id']),
      hiveMigrated: serializer.fromJson<bool>(json['hiveMigrated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hiveMigrated': serializer.toJson<bool>(hiveMigrated),
    };
  }

  MigrationStateRow copyWith({int? id, bool? hiveMigrated}) =>
      MigrationStateRow(
        id: id ?? this.id,
        hiveMigrated: hiveMigrated ?? this.hiveMigrated,
      );
  MigrationStateRow copyWithCompanion(MigrationStateCompanion data) {
    return MigrationStateRow(
      id: data.id.present ? data.id.value : this.id,
      hiveMigrated: data.hiveMigrated.present
          ? data.hiveMigrated.value
          : this.hiveMigrated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MigrationStateRow(')
          ..write('id: $id, ')
          ..write('hiveMigrated: $hiveMigrated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hiveMigrated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MigrationStateRow &&
          other.id == this.id &&
          other.hiveMigrated == this.hiveMigrated);
}

class MigrationStateCompanion extends UpdateCompanion<MigrationStateRow> {
  final Value<int> id;
  final Value<bool> hiveMigrated;
  const MigrationStateCompanion({
    this.id = const Value.absent(),
    this.hiveMigrated = const Value.absent(),
  });
  MigrationStateCompanion.insert({
    this.id = const Value.absent(),
    this.hiveMigrated = const Value.absent(),
  });
  static Insertable<MigrationStateRow> custom({
    Expression<int>? id,
    Expression<bool>? hiveMigrated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hiveMigrated != null) 'hive_migrated': hiveMigrated,
    });
  }

  MigrationStateCompanion copyWith(
      {Value<int>? id, Value<bool>? hiveMigrated}) {
    return MigrationStateCompanion(
      id: id ?? this.id,
      hiveMigrated: hiveMigrated ?? this.hiveMigrated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hiveMigrated.present) {
      map['hive_migrated'] = Variable<bool>(hiveMigrated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MigrationStateCompanion(')
          ..write('id: $id, ')
          ..write('hiveMigrated: $hiveMigrated')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoiceItemsTable invoiceItems = $InvoiceItemsTable(this);
  late final $BusinessProfileTableTable businessProfileTable =
      $BusinessProfileTableTable(this);
  late final $DeviceMetaTable deviceMeta = $DeviceMetaTable(this);
  late final $MigrationStateTable migrationState = $MigrationStateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        invoices,
        invoiceItems,
        businessProfileTable,
        deviceMeta,
        migrationState
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('invoices',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('invoice_items', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$InvoicesTableCreateCompanionBuilder = InvoicesCompanion Function({
  required String id,
  required String number,
  required DateTime date,
  Value<String> customerName,
  Value<String> customerPhone,
  Value<String> customerAddress,
  Value<double> subtotal,
  Value<double> totalDiscount,
  Value<double> grandTotal,
  Value<String> paymentMode,
  Value<String> businessName,
  Value<String> businessSubtitle,
  Value<String> businessPhone,
  Value<String> businessAddress,
  Value<String> businessLogoBase64,
  Value<String> pdfBase64,
  Value<int> rowid,
});
typedef $$InvoicesTableUpdateCompanionBuilder = InvoicesCompanion Function({
  Value<String> id,
  Value<String> number,
  Value<DateTime> date,
  Value<String> customerName,
  Value<String> customerPhone,
  Value<String> customerAddress,
  Value<double> subtotal,
  Value<double> totalDiscount,
  Value<double> grandTotal,
  Value<String> paymentMode,
  Value<String> businessName,
  Value<String> businessSubtitle,
  Value<String> businessPhone,
  Value<String> businessAddress,
  Value<String> businessLogoBase64,
  Value<String> pdfBase64,
  Value<int> rowid,
});

final class $$InvoicesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoicesTable, InvoiceRow> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InvoiceItemsTable, List<InvoiceItemRow>>
      _invoiceItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.invoiceItems,
              aliasName: 'invoices__id__invoice_items__invoice_id');

  $$InvoiceItemsTableProcessedTableManager get invoiceItemsRefs {
    final manager = $$InvoiceItemsTableTableManager($_db, $_db.invoiceItems)
        .filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerAddress => $composableBuilder(
      column: $table.customerAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalDiscount => $composableBuilder(
      column: $table.totalDiscount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get grandTotal => $composableBuilder(
      column: $table.grandTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessName => $composableBuilder(
      column: $table.businessName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessSubtitle => $composableBuilder(
      column: $table.businessSubtitle,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessPhone => $composableBuilder(
      column: $table.businessPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessAddress => $composableBuilder(
      column: $table.businessAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessLogoBase64 => $composableBuilder(
      column: $table.businessLogoBase64,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pdfBase64 => $composableBuilder(
      column: $table.pdfBase64, builder: (column) => ColumnFilters(column));

  Expression<bool> invoiceItemsRefs(
      Expression<bool> Function($$InvoiceItemsTableFilterComposer f) f) {
    final $$InvoiceItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.invoiceItems,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoiceItemsTableFilterComposer(
              $db: $db,
              $table: $db.invoiceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerAddress => $composableBuilder(
      column: $table.customerAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalDiscount => $composableBuilder(
      column: $table.totalDiscount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get grandTotal => $composableBuilder(
      column: $table.grandTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessName => $composableBuilder(
      column: $table.businessName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessSubtitle => $composableBuilder(
      column: $table.businessSubtitle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessPhone => $composableBuilder(
      column: $table.businessPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessAddress => $composableBuilder(
      column: $table.businessAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessLogoBase64 => $composableBuilder(
      column: $table.businessLogoBase64,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pdfBase64 => $composableBuilder(
      column: $table.pdfBase64, builder: (column) => ColumnOrderings(column));
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => column);

  GeneratedColumn<String> get customerAddress => $composableBuilder(
      column: $table.customerAddress, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get totalDiscount => $composableBuilder(
      column: $table.totalDiscount, builder: (column) => column);

  GeneratedColumn<double> get grandTotal => $composableBuilder(
      column: $table.grandTotal, builder: (column) => column);

  GeneratedColumn<String> get paymentMode => $composableBuilder(
      column: $table.paymentMode, builder: (column) => column);

  GeneratedColumn<String> get businessName => $composableBuilder(
      column: $table.businessName, builder: (column) => column);

  GeneratedColumn<String> get businessSubtitle => $composableBuilder(
      column: $table.businessSubtitle, builder: (column) => column);

  GeneratedColumn<String> get businessPhone => $composableBuilder(
      column: $table.businessPhone, builder: (column) => column);

  GeneratedColumn<String> get businessAddress => $composableBuilder(
      column: $table.businessAddress, builder: (column) => column);

  GeneratedColumn<String> get businessLogoBase64 => $composableBuilder(
      column: $table.businessLogoBase64, builder: (column) => column);

  GeneratedColumn<String> get pdfBase64 =>
      $composableBuilder(column: $table.pdfBase64, builder: (column) => column);

  Expression<T> invoiceItemsRefs<T extends Object>(
      Expression<T> Function($$InvoiceItemsTableAnnotationComposer a) f) {
    final $$InvoiceItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.invoiceItems,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoiceItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.invoiceItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InvoicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvoicesTable,
    InvoiceRow,
    $$InvoicesTableFilterComposer,
    $$InvoicesTableOrderingComposer,
    $$InvoicesTableAnnotationComposer,
    $$InvoicesTableCreateCompanionBuilder,
    $$InvoicesTableUpdateCompanionBuilder,
    (InvoiceRow, $$InvoicesTableReferences),
    InvoiceRow,
    PrefetchHooks Function({bool invoiceItemsRefs})> {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> number = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<String> customerPhone = const Value.absent(),
            Value<String> customerAddress = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> totalDiscount = const Value.absent(),
            Value<double> grandTotal = const Value.absent(),
            Value<String> paymentMode = const Value.absent(),
            Value<String> businessName = const Value.absent(),
            Value<String> businessSubtitle = const Value.absent(),
            Value<String> businessPhone = const Value.absent(),
            Value<String> businessAddress = const Value.absent(),
            Value<String> businessLogoBase64 = const Value.absent(),
            Value<String> pdfBase64 = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvoicesCompanion(
            id: id,
            number: number,
            date: date,
            customerName: customerName,
            customerPhone: customerPhone,
            customerAddress: customerAddress,
            subtotal: subtotal,
            totalDiscount: totalDiscount,
            grandTotal: grandTotal,
            paymentMode: paymentMode,
            businessName: businessName,
            businessSubtitle: businessSubtitle,
            businessPhone: businessPhone,
            businessAddress: businessAddress,
            businessLogoBase64: businessLogoBase64,
            pdfBase64: pdfBase64,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String number,
            required DateTime date,
            Value<String> customerName = const Value.absent(),
            Value<String> customerPhone = const Value.absent(),
            Value<String> customerAddress = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> totalDiscount = const Value.absent(),
            Value<double> grandTotal = const Value.absent(),
            Value<String> paymentMode = const Value.absent(),
            Value<String> businessName = const Value.absent(),
            Value<String> businessSubtitle = const Value.absent(),
            Value<String> businessPhone = const Value.absent(),
            Value<String> businessAddress = const Value.absent(),
            Value<String> businessLogoBase64 = const Value.absent(),
            Value<String> pdfBase64 = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvoicesCompanion.insert(
            id: id,
            number: number,
            date: date,
            customerName: customerName,
            customerPhone: customerPhone,
            customerAddress: customerAddress,
            subtotal: subtotal,
            totalDiscount: totalDiscount,
            grandTotal: grandTotal,
            paymentMode: paymentMode,
            businessName: businessName,
            businessSubtitle: businessSubtitle,
            businessPhone: businessPhone,
            businessAddress: businessAddress,
            businessLogoBase64: businessLogoBase64,
            pdfBase64: pdfBase64,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$InvoicesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({invoiceItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (invoiceItemsRefs) db.invoiceItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (invoiceItemsRefs)
                    await $_getPrefetchedData<InvoiceRow, $InvoicesTable,
                            InvoiceItemRow>(
                        currentTable: table,
                        referencedTable: $$InvoicesTableReferences
                            ._invoiceItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InvoicesTableReferences(db, table, p0)
                                .invoiceItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.invoiceId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$InvoicesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InvoicesTable,
    InvoiceRow,
    $$InvoicesTableFilterComposer,
    $$InvoicesTableOrderingComposer,
    $$InvoicesTableAnnotationComposer,
    $$InvoicesTableCreateCompanionBuilder,
    $$InvoicesTableUpdateCompanionBuilder,
    (InvoiceRow, $$InvoicesTableReferences),
    InvoiceRow,
    PrefetchHooks Function({bool invoiceItemsRefs})>;
typedef $$InvoiceItemsTableCreateCompanionBuilder = InvoiceItemsCompanion
    Function({
  Value<int> itemId,
  required String invoiceId,
  required String name,
  required double price,
  required int qty,
  required double discount,
});
typedef $$InvoiceItemsTableUpdateCompanionBuilder = InvoiceItemsCompanion
    Function({
  Value<int> itemId,
  Value<String> invoiceId,
  Value<String> name,
  Value<double> price,
  Value<int> qty,
  Value<double> discount,
});

final class $$InvoiceItemsTableReferences
    extends BaseReferences<_$AppDatabase, $InvoiceItemsTable, InvoiceItemRow> {
  $$InvoiceItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('invoice_items__invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id')!;

    final manager = $$InvoicesTableTableManager($_db, $_db.invoices)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$InvoiceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get qty => $composableBuilder(
      column: $table.qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnFilters(column));

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableFilterComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvoiceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get qty => $composableBuilder(
      column: $table.qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnOrderings(column));

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableOrderingComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvoiceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvoicesTableAnnotationComposer(
              $db: $db,
              $table: $db.invoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvoiceItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvoiceItemsTable,
    InvoiceItemRow,
    $$InvoiceItemsTableFilterComposer,
    $$InvoiceItemsTableOrderingComposer,
    $$InvoiceItemsTableAnnotationComposer,
    $$InvoiceItemsTableCreateCompanionBuilder,
    $$InvoiceItemsTableUpdateCompanionBuilder,
    (InvoiceItemRow, $$InvoiceItemsTableReferences),
    InvoiceItemRow,
    PrefetchHooks Function({bool invoiceId})> {
  $$InvoiceItemsTableTableManager(_$AppDatabase db, $InvoiceItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> itemId = const Value.absent(),
            Value<String> invoiceId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<int> qty = const Value.absent(),
            Value<double> discount = const Value.absent(),
          }) =>
              InvoiceItemsCompanion(
            itemId: itemId,
            invoiceId: invoiceId,
            name: name,
            price: price,
            qty: qty,
            discount: discount,
          ),
          createCompanionCallback: ({
            Value<int> itemId = const Value.absent(),
            required String invoiceId,
            required String name,
            required double price,
            required int qty,
            required double discount,
          }) =>
              InvoiceItemsCompanion.insert(
            itemId: itemId,
            invoiceId: invoiceId,
            name: name,
            price: price,
            qty: qty,
            discount: discount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InvoiceItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (invoiceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.invoiceId,
                    referencedTable:
                        $$InvoiceItemsTableReferences._invoiceIdTable(db),
                    referencedColumn:
                        $$InvoiceItemsTableReferences._invoiceIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$InvoiceItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InvoiceItemsTable,
    InvoiceItemRow,
    $$InvoiceItemsTableFilterComposer,
    $$InvoiceItemsTableOrderingComposer,
    $$InvoiceItemsTableAnnotationComposer,
    $$InvoiceItemsTableCreateCompanionBuilder,
    $$InvoiceItemsTableUpdateCompanionBuilder,
    (InvoiceItemRow, $$InvoiceItemsTableReferences),
    InvoiceItemRow,
    PrefetchHooks Function({bool invoiceId})>;
typedef $$BusinessProfileTableTableCreateCompanionBuilder
    = BusinessProfileTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> subtitle,
  Value<String> phone,
  Value<String> address,
  Value<String> logoBase64,
});
typedef $$BusinessProfileTableTableUpdateCompanionBuilder
    = BusinessProfileTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> subtitle,
  Value<String> phone,
  Value<String> address,
  Value<String> logoBase64,
});

class $$BusinessProfileTableTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessProfileTableTable> {
  $$BusinessProfileTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subtitle => $composableBuilder(
      column: $table.subtitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoBase64 => $composableBuilder(
      column: $table.logoBase64, builder: (column) => ColumnFilters(column));
}

class $$BusinessProfileTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessProfileTableTable> {
  $$BusinessProfileTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subtitle => $composableBuilder(
      column: $table.subtitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoBase64 => $composableBuilder(
      column: $table.logoBase64, builder: (column) => ColumnOrderings(column));
}

class $$BusinessProfileTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessProfileTableTable> {
  $$BusinessProfileTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get logoBase64 => $composableBuilder(
      column: $table.logoBase64, builder: (column) => column);
}

class $$BusinessProfileTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BusinessProfileTableTable,
    BusinessProfileRow,
    $$BusinessProfileTableTableFilterComposer,
    $$BusinessProfileTableTableOrderingComposer,
    $$BusinessProfileTableTableAnnotationComposer,
    $$BusinessProfileTableTableCreateCompanionBuilder,
    $$BusinessProfileTableTableUpdateCompanionBuilder,
    (
      BusinessProfileRow,
      BaseReferences<_$AppDatabase, $BusinessProfileTableTable,
          BusinessProfileRow>
    ),
    BusinessProfileRow,
    PrefetchHooks Function()> {
  $$BusinessProfileTableTableTableManager(
      _$AppDatabase db, $BusinessProfileTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessProfileTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessProfileTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessProfileTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> subtitle = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String> logoBase64 = const Value.absent(),
          }) =>
              BusinessProfileTableCompanion(
            id: id,
            name: name,
            subtitle: subtitle,
            phone: phone,
            address: address,
            logoBase64: logoBase64,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> subtitle = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String> logoBase64 = const Value.absent(),
          }) =>
              BusinessProfileTableCompanion.insert(
            id: id,
            name: name,
            subtitle: subtitle,
            phone: phone,
            address: address,
            logoBase64: logoBase64,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BusinessProfileTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $BusinessProfileTableTable,
        BusinessProfileRow,
        $$BusinessProfileTableTableFilterComposer,
        $$BusinessProfileTableTableOrderingComposer,
        $$BusinessProfileTableTableAnnotationComposer,
        $$BusinessProfileTableTableCreateCompanionBuilder,
        $$BusinessProfileTableTableUpdateCompanionBuilder,
        (
          BusinessProfileRow,
          BaseReferences<_$AppDatabase, $BusinessProfileTableTable,
              BusinessProfileRow>
        ),
        BusinessProfileRow,
        PrefetchHooks Function()>;
typedef $$DeviceMetaTableCreateCompanionBuilder = DeviceMetaCompanion Function({
  Value<int> id,
  required String installId,
});
typedef $$DeviceMetaTableUpdateCompanionBuilder = DeviceMetaCompanion Function({
  Value<int> id,
  Value<String> installId,
});

class $$DeviceMetaTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceMetaTable> {
  $$DeviceMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get installId => $composableBuilder(
      column: $table.installId, builder: (column) => ColumnFilters(column));
}

class $$DeviceMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceMetaTable> {
  $$DeviceMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get installId => $composableBuilder(
      column: $table.installId, builder: (column) => ColumnOrderings(column));
}

class $$DeviceMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceMetaTable> {
  $$DeviceMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get installId =>
      $composableBuilder(column: $table.installId, builder: (column) => column);
}

class $$DeviceMetaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DeviceMetaTable,
    DeviceMetaRow,
    $$DeviceMetaTableFilterComposer,
    $$DeviceMetaTableOrderingComposer,
    $$DeviceMetaTableAnnotationComposer,
    $$DeviceMetaTableCreateCompanionBuilder,
    $$DeviceMetaTableUpdateCompanionBuilder,
    (
      DeviceMetaRow,
      BaseReferences<_$AppDatabase, $DeviceMetaTable, DeviceMetaRow>
    ),
    DeviceMetaRow,
    PrefetchHooks Function()> {
  $$DeviceMetaTableTableManager(_$AppDatabase db, $DeviceMetaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> installId = const Value.absent(),
          }) =>
              DeviceMetaCompanion(
            id: id,
            installId: installId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String installId,
          }) =>
              DeviceMetaCompanion.insert(
            id: id,
            installId: installId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DeviceMetaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DeviceMetaTable,
    DeviceMetaRow,
    $$DeviceMetaTableFilterComposer,
    $$DeviceMetaTableOrderingComposer,
    $$DeviceMetaTableAnnotationComposer,
    $$DeviceMetaTableCreateCompanionBuilder,
    $$DeviceMetaTableUpdateCompanionBuilder,
    (
      DeviceMetaRow,
      BaseReferences<_$AppDatabase, $DeviceMetaTable, DeviceMetaRow>
    ),
    DeviceMetaRow,
    PrefetchHooks Function()>;
typedef $$MigrationStateTableCreateCompanionBuilder = MigrationStateCompanion
    Function({
  Value<int> id,
  Value<bool> hiveMigrated,
});
typedef $$MigrationStateTableUpdateCompanionBuilder = MigrationStateCompanion
    Function({
  Value<int> id,
  Value<bool> hiveMigrated,
});

class $$MigrationStateTableFilterComposer
    extends Composer<_$AppDatabase, $MigrationStateTable> {
  $$MigrationStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hiveMigrated => $composableBuilder(
      column: $table.hiveMigrated, builder: (column) => ColumnFilters(column));
}

class $$MigrationStateTableOrderingComposer
    extends Composer<_$AppDatabase, $MigrationStateTable> {
  $$MigrationStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hiveMigrated => $composableBuilder(
      column: $table.hiveMigrated,
      builder: (column) => ColumnOrderings(column));
}

class $$MigrationStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $MigrationStateTable> {
  $$MigrationStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get hiveMigrated => $composableBuilder(
      column: $table.hiveMigrated, builder: (column) => column);
}

class $$MigrationStateTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MigrationStateTable,
    MigrationStateRow,
    $$MigrationStateTableFilterComposer,
    $$MigrationStateTableOrderingComposer,
    $$MigrationStateTableAnnotationComposer,
    $$MigrationStateTableCreateCompanionBuilder,
    $$MigrationStateTableUpdateCompanionBuilder,
    (
      MigrationStateRow,
      BaseReferences<_$AppDatabase, $MigrationStateTable, MigrationStateRow>
    ),
    MigrationStateRow,
    PrefetchHooks Function()> {
  $$MigrationStateTableTableManager(
      _$AppDatabase db, $MigrationStateTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MigrationStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MigrationStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MigrationStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> hiveMigrated = const Value.absent(),
          }) =>
              MigrationStateCompanion(
            id: id,
            hiveMigrated: hiveMigrated,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<bool> hiveMigrated = const Value.absent(),
          }) =>
              MigrationStateCompanion.insert(
            id: id,
            hiveMigrated: hiveMigrated,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MigrationStateTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MigrationStateTable,
    MigrationStateRow,
    $$MigrationStateTableFilterComposer,
    $$MigrationStateTableOrderingComposer,
    $$MigrationStateTableAnnotationComposer,
    $$MigrationStateTableCreateCompanionBuilder,
    $$MigrationStateTableUpdateCompanionBuilder,
    (
      MigrationStateRow,
      BaseReferences<_$AppDatabase, $MigrationStateTable, MigrationStateRow>
    ),
    MigrationStateRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InvoiceItemsTableTableManager get invoiceItems =>
      $$InvoiceItemsTableTableManager(_db, _db.invoiceItems);
  $$BusinessProfileTableTableTableManager get businessProfileTable =>
      $$BusinessProfileTableTableTableManager(_db, _db.businessProfileTable);
  $$DeviceMetaTableTableManager get deviceMeta =>
      $$DeviceMetaTableTableManager(_db, _db.deviceMeta);
  $$MigrationStateTableTableManager get migrationState =>
      $$MigrationStateTableTableManager(_db, _db.migrationState);
}
