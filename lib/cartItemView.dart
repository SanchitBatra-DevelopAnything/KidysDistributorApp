import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kidys_distributor/providers/cart.dart';
import 'package:provider/provider.dart';

import 'itemCounterButton.dart';

class CartItemView extends StatefulWidget {
  final CartItem cartItem;
  const CartItemView({Key? key, required this.cartItem}) : super(key: key);

  @override
  _CartItemViewState createState() => _CartItemViewState();
}

class _CartItemViewState extends State<CartItemView> {
  @override
  Widget build(BuildContext context) {
    final cartProviderObject = Provider.of<CartProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Flexible(
          flex: 5,
          child: CachedNetworkImage(
            imageUrl: widget.cartItem.imageUrl,
            fit: BoxFit.cover,
            height: 80,
            width: 80,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                SpinKitPulse(
              color: Color(0xffdd0e1c),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          flex: 7,
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cartItem.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Rs.${widget.cartItem.totalPrice}',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        Flexible(
          flex: 6,
          fit: FlexFit.tight,
          child: Container(
            height: 35,
            child: CountButtonView(
                itemId: widget.cartItem.id,
                parentCategory: widget.cartItem.parentCategoryType,
                onChange: (count) => {
                      if (count == 0)
                        {
                          cartProviderObject.removeItem(widget.cartItem.id),
                        }
                      else if (count > 0)
                        {
                          cartProviderObject.addItem(
                            widget.cartItem.id,
                            widget.cartItem.price,
                            count,
                            widget.cartItem.title,
                            widget.cartItem.imageUrl,
                            widget.cartItem.parentCategoryType,
                          )
                        }
                    }),
          ),
        )
      ]),
    );
  }
}
