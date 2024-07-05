import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/user_model.dart';

class RankedCard extends StatelessWidget {
  final User user;
  final int position;
  const RankedCard({super.key, required this.user, required this.position});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = context.read<UserBloc>().user.id == user.id;
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: isLightTheme ? kPrimary3 : kPrimary,
        borderRadius: BorderRadius.circular(kRadius10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPadding10),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.circular(kRadius10),
              ),
              child: Center(
                child: Text(
                  position.toString(),
                  style: kBoldARPDisplay14,
                ),
              ),
            ),
            const SizedBox(width: kPadding10),
            Expanded(
              child: Text(
                user.nickname,
                style: kBoldARPDisplay16.copyWith(color: isLightTheme ? kPrimary : Colors.white),
                overflow: TextOverflow.clip,
              ),
            ),
            const SizedBox(width: kPadding10),
            Text(
              user.experience.toString(),
              style: kBoldARPDisplay13.copyWith(color: isLightTheme ? kPrimary : Colors.white),
            ),
            const SizedBox(width: kPadding10),
            SvgPicture.asset(
              "assets/svg/gem.svg",
            ),
            const SizedBox(width: kPadding10),
          ],
        ),
      ),
    );
  }
}
