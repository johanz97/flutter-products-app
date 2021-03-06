import 'package:flutter/material.dart';
import 'package:productosapp/models/models.dart';
import 'package:productosapp/pages/page.dart';
import 'package:provider/provider.dart';
import 'package:productosapp/services/services.dart';
import 'package:productosapp/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    if (productsService.isLoading) return LoadingPage();
    final products = productsService.products;
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authService.logoutUser();
              Navigator.pushReplacementNamed(context, 'login');
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          child: ProductCard(
            product: products[index],
          ),
          onTap: () {
            productsService.selectedProduct = products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          productsService.selectedProduct =
              new Product(name: '', available: false, price: 0);
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
