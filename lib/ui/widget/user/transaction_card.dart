import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: getColor(),
        borderRadius: BorderRadius.circular(
          kRadius10,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding20, vertical: kPadding10),
        child: Row(
          children: [
            /// Sizedbox used to center icons
            SizedBox(
              width: 25,
              child: SvgPicture.asset("assets/svg/${getSvgPath()}"),
            ),

            const SizedBox(width: kPadding20),

            /// Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // "tester le responsive avec un texte longtester le responsive avec un texte longtester le responsive avec un texte longtester le responsive avec un texte longtester le responsive avec un texte long",
                    transaction.name,
                    style: kBoldNunito14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    getDate(),
                    style: kRegularNunito14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            const SizedBox(width: kPadding20),
            Text(
              getGem(),
              style: kBoldARPDisplay13,
            )
          ],
        ),
      ),
    );
  }

  String getGem() {
    TransactionType type = transaction.type;

    if (type == TransactionType.offer || type == TransactionType.donation) {
      return "-${transaction.gem.toString()}";
    }

    return "+${transaction.gem.toString()}";
  }

  Color getColor() {
    TransactionType type = transaction.type;
    if (type == TransactionType.offer || type == TransactionType.donation) {
      return kPrimary3;
    }
    return kSecondary;
  }

  String getSvgPath() {
    TransactionType type = transaction.type;

    if (type == TransactionType.offer) {
      return "gift_transaction.svg";
    }

    if (type == TransactionType.challenge) {
      return "rocket_transaction.svg";
    }
    if (type == TransactionType.donation) {
      return "tree_transaction.svg";
    }
    if (type == TransactionType.launch_gift) {
      return "gem_transaction.svg";
    }
    if (type == TransactionType.crowd_report) {
      return "people_transaction.svg";
    }
    if (type == TransactionType.validation) {
      return "tower_transaction.svg";
    }
    return "";
  }

  String getDate() {
    DateTime createdAt = transaction.createdAt;
    return "${createdAt.day}/${createdAt.month}/${createdAt.year}";
  }
}
