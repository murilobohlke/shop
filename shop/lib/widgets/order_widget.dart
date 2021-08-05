import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/providers/orders.dart';

class OrderWidget extends StatelessWidget {
  final Order order;

  const OrderWidget(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text('R\$ ${order.total}'),
        subtitle: Text(
          DateFormat('dd/MM/yyyy  hh:mm').format(order.date)
        ),
        trailing: IconButton(
          icon: Icon(Icons.expand_more),
          onPressed: () {},
        ),
      ),
    );
  }
}