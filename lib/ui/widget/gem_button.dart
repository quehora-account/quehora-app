import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/user_model.dart';

class GemButton extends StatelessWidget {
  final bool isLight;
  final bool bigGem;
  bool isExplore = false;
   GemButton({super.key,this.bigGem=false, this.isLight = false,this.isExplore = false});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is InitLoading || state is InitFailed) {
          return SizedBox(height: bigGem?30:25);
        }

        User user = context.read<UserBloc>().user;
        if(isExplore){
          return Container(
            margin: const EdgeInsets.fromLTRB(0,0,0,0),
            decoration:  BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(kRadius20)),
              color: isLight ? Colors.white : kPrimary,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x29000000),
                  offset: Offset(0,4),
                  blurRadius: 4,
                ),
              ],
            ),
            height: bigGem?30:25,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.gem.toString(),
                    style: kBoldARPDisplay13.copyWith(color: isLight ? kPrimary : Colors.white),
                  ),
                  const SizedBox(width: kPadding5),
                  SvgPicture.asset("assets/svg/gem.svg"),
                ],
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () async {
            if (isLight) {
              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
            }
            await Navigator.pushNamed(context, "/home/earnings");
            if (!isLight) {
              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
            }
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(0,0,0,0),
            decoration:  BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(kRadius20)),
              color: isLight ? Colors.white : kPrimary,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x29000000),
                  offset: Offset(0,4),
                  blurRadius: 4,
                ),
              ],
            ),
            height: bigGem?30:25,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.gem.toString(),
                    style: kBoldARPDisplay13.copyWith(color: isLight ? kPrimary : Colors.white),
                  ),
                  const SizedBox(width: kPadding5),
                  SvgPicture.asset("assets/svg/gem.svg"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
