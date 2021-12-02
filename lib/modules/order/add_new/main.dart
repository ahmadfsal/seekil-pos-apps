import 'package:flutter/material.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/order_add_new.model.dart';
import 'package:seekil_back_office/modules/order/add_new/views/customer_section.dart';
import 'package:seekil_back_office/modules/order/add_new/views/footer_section.dart';
import 'package:seekil_back_office/modules/order/add_new/views/form_items.dart';
import 'package:seekil_back_office/modules/order/add_new/views/payment_detail.dart';
import 'package:seekil_back_office/modules/order/add_new/views/payment_section.dart';
import 'package:seekil_back_office/utilities/helper/order_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class OrderAddNew extends StatefulWidget {
  const OrderAddNew({Key? key}) : super(key: key);

  @override
  _OrderAddNewState createState() => _OrderAddNewState();
}

class _OrderAddNewState extends State<OrderAddNew> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  OrderAddNewModel _orderAddNewModel = OrderAddNewModel();
  WordTransformation wt = WordTransformation();
  OrderUtils orderUtils = OrderUtils();
  bool isUsePoint = false;
  bool _showBannerRequiredField = true;

  TextEditingController whatsappController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetHelper.appBar('Pesanan Baru'),
        body: Column(children: [
          if (_showBannerRequiredField)
            MaterialBanner(
                content: Text(
                  '*) Wajib diisi',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                backgroundColor: ColorConstant.INFO,
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _showBannerRequiredField = false;
                        });
                      },
                      child: Text('Mengerti',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)))
                ]),
          Expanded(
            child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    OrderAddNewCustomerSection(_orderAddNewModel,
                        whatsappController: whatsappController,
                        customerNameController: customerNameController,
                        onChangeCustomerName: _onChangeCustomerName,
                        onSuggestionSelected: _onSuggestionSelected),
                    _separator,
                    OrderAddNewItemsSection(
                      _orderAddNewModel,
                      onSavedFormItems: () {
                        setState(() {});
                      },
                    ),
                    _separator,
                    OrderAddNewPaymentSection(
                      _orderAddNewModel,
                      isUsePoint: isUsePoint,
                      onChangeUsePoint: (bool value) {
                        setState(() {
                          isUsePoint = value;
                        });
                      },
                      onChangeOngkosKirim: (dynamic value) {
                        if (value != null) {
                          setState(() {
                            _orderAddNewModel.pickupDeliveryPrice =
                                int.parse(value);
                          });
                        }
                      },
                      onChangePromo: (dynamic item) {
                        List<dynamic>? items = _orderAddNewModel.items;
                        int discount = item['discount'];
                        double totalDiscount =
                            (orderUtils.getItemSubtotal(items) * discount) /
                                100;

                        setState(() {
                          _orderAddNewModel.promoId = item['id'] as int;
                          _orderAddNewModel.potongan = totalDiscount.toInt();
                        });
                      },
                    ),
                    _separator,
                    OrderAddNewPaymentDetal(
                      _orderAddNewModel,
                      isUsePoint: isUsePoint,
                    ),
                    Container(
                      height: 10.0,
                      margin: EdgeInsets.only(top: 16.0),
                      color: Colors.black12.withOpacity(0.05),
                    )
                  ],
                )),
          ),
          OrderAddNewFooterSection(_orderAddNewModel, _formKey)
        ]));
  }

  void _onChangeCustomerName(dynamic value) {
    _orderAddNewModel.customerName = value;

    setState(() {});
  }

  void _onSuggestionSelected(dynamic item) {
    _orderAddNewModel.customerId = item.id;
    _orderAddNewModel.customerName = item.name;
    _orderAddNewModel.whatsapp = item.whatsapp.replaceRange(0, 2, '');
    _orderAddNewModel.points = item.points;
    whatsappController.text = item.whatsapp;
    _orderAddNewModel.customerName = item.name;
    customerNameController.text = item.name;
    setState(() {});
  }

  Widget _separator = Container(
    height: 10.0,
    color: Colors.black12.withOpacity(0.05),
  );
}