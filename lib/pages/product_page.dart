import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productosapp/providers/providers.dart';
import 'package:productosapp/services/services.dart';
import 'package:productosapp/ui/input_decorations.dart';
import 'package:productosapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productsService.selectedProduct),
      child: _ProductPageBody(productsService: productsService),
    );
  }
}

class _ProductPageBody extends StatelessWidget {
  const _ProductPageBody({
    Key? key,
    required this.productsService,
  }) : super(key: key);

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                  picture: productsService.selectedProduct.picture,
                ),
                Positioned(
                    top: 50,
                    left: 10,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    )),
                Positioned(
                    top: 50,
                    right: 10,
                    child: ImageButton(
                      icon: Icons.camera_alt_outlined,
                      cameraOrGallery: true,
                    )),
                Positioned(
                    bottom: 20,
                    right: 10,
                    child: ImageButton(
                      icon: Icons.image_search,
                      cameraOrGallery: false,
                    )),
              ],
            ),
            _ProductForm(),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: productsService.isSaving
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Icon(Icons.save_outlined),
        onPressed: productsService.isSaving
            ? null
            : () async {
                if (!productForm.isValidForm()) return;
                final String? imageUrl = await productsService.uploadImage();
                if (imageUrl != null) productForm.product.picture = imageUrl;
                await productsService.saveOrCreateProduct(productForm.product);
                Navigator.pop(context);
              },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El nombre es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre del producto', labelText: 'Nombre'),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: product.price.toString(),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) => {
                  if (double.tryParse(value) == null)
                    product.price = 0
                  else
                    product.price = double.parse(value)
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '\$150.00', labelText: 'Precio'),
              ),
              SizedBox(
                height: 20,
              ),
              SwitchListTile(
                  value: product.available,
                  title: Text('Disponibilidad'),
                  activeColor: Colors.indigo,
                  onChanged: productForm.updateAvailability),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 5),
                blurRadius: 5)
          ]);
}
