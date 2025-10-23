import 'package:clothify_app/components/additional_confirm.dart';
import 'package:clothify_app/controllers/db_service.dart';
import 'package:clothify_app/models/orders_model.dart';
import 'package:clothify_app/views/view_product.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  totalQuantityCalculator(List<OrderProductModel> products) {
    int qty = 0;
    products.map((e) => qty += e.quantity).toList();
    return qty;
  }

  Widget statusIcon(String status) {
    if (status == "PAID") {
      return statusContainer(
        text: "PAID",
        bgColor: Colors.lightGreen,
        textColor: Colors.white,
      );
    }
    if (status == "ON_THE_WAY") {
      return statusContainer(
        text: "ON THE WAY",
        bgColor: Colors.yellow,
        textColor: Colors.black,
      );
    } else if (status == "DELIVERED") {
      return statusContainer(
        text: "DELIVERED",
        bgColor: Colors.green.shade700,
        textColor: Colors.white,
      );
    } else {
      return statusContainer(
        text: "CANCELED",
        bgColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Widget statusContainer({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      color: bgColor,
      padding: EdgeInsets.all(8),
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: DbService().readOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OrdersModel> orders = OrdersModel.fromJsonList(
              snapshot.data!.docs,
            );
            if (orders.isEmpty) {
              return Center(child: Text("No orders found"));
            } else {
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/view_order",
                        arguments: orders[index],
                      );
                    },
                    title: Text(
                      "${totalQuantityCalculator(orders[index].products)} Items - Rs. ${formatPrice(orders[index].total)}",
                    ),
                    subtitle: Text(
                      "Order on ${DateTime.fromMillisecondsSinceEpoch(orders[index].created_at).toString()}",
                    ),
                    trailing: statusIcon(orders[index].status),
                  );
                },
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ViewOrder extends StatefulWidget {
  const ViewOrder({super.key});

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrdersModel;
    return Scaffold(
      appBar: AppBar(title: Text("Order Summary")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Delivery Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                color: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order ID : ${args.id}"),
                    Text(
                      "Ordered on : ${DateTime.fromMillisecondsSinceEpoch(args.created_at).toString()}",
                    ),
                    Text("Order by : ${args.name}"),
                    Text("Phone : ${args.phone}"),
                    Text("Delivery Address : ${args.address}"),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: args.products
                    .map(
                      (e) => Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(e.image),
                                ),
                                SizedBox(width: 10),
                                Expanded(child: Text(e.name)),
                              ],
                            ),
                            Text(
                              "Rs. ${formatPrice(e.single_price).toString()} x ${e.quantity.toString()} Quantity",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Rs. ${formatPrice(e.total_price).toString()}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total : Rs. ${formatPrice(args.total)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Status : ${args.status}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              args.status == "PAID"
                  ? SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width * .9,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ModifyOrder(order: args),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.shade400,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Modify Order"),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class ModifyOrder extends StatefulWidget {
  final OrdersModel order;
  const ModifyOrder({super.key, required this.order});

  @override
  State<ModifyOrder> createState() => _ModifyOrderState();
}

class _ModifyOrderState extends State<ModifyOrder> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Modify Order"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Chosse what you want to do"),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AdditionalConfirm(
                  contentText: "Are you sure you want to cancel this order?",
                  onYes: () async {
                    await DbService().updateOrderStatus(
                      docId: widget.order.id,
                      data: {"status": "CANCELLED"},
                    );
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Order Updated")));
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  onNo: () {
                    Navigator.pop(context);
                  },
                ),
              );
            },
            child: Text("Cancel Order"),
          ),
        ],
      ),
    );
  }
}
