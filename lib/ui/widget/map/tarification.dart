import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/tarification_model.dart';

class Tarification extends StatelessWidget {
  final String svgPath;
  final TarificationModel data;
  const Tarification({super.key, required this.svgPath, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SvgPicture.asset(svgPath),
      const SizedBox(height: kPadding5),
      Text(data.price, style: kBoldNunito12),
      Text(data.condition, style: kRegularNunito12),
    ]);
  }
}
