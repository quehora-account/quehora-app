import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoora/bloc/offer/offer_bloc.dart' as offer_bloc;
import 'package:hoora/bloc/project/project_bloc.dart' as project_bloc;
import 'package:hoora/common/decoration.dart';
import 'package:hoora/ui/page/offer/offers_page.dart';
import 'package:hoora/ui/page/project/projects_page.dart';
import 'package:hoora/ui/widget/gem_button.dart';

class GiftPage extends StatefulWidget {
  const GiftPage({super.key});

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  PageController controller = PageController(initialPage: 0);
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + kPadding20),
        const Padding(
          padding: EdgeInsets.only(right: kPadding20),
          child: Align(alignment: Alignment.topRight, child: GemButton()),
        ),
        const SizedBox(height: kPadding20),

        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: kPadding20),
            child: Text(
              "Dépenser mes\nDiamz",
              style: kBoldARPDisplay18,
            ),
          ),
        ),
        const SizedBox(height: kPadding40),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
          child: buildButtons(),
        ),
        const SizedBox(height: kPadding20),

        /// Sub pages
        Expanded(
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: const [
              OffersPage(),
              ProjectsPage(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildButtons() {
    return LayoutBuilder(builder: (context, constraint) {
      return SizedBox(
        height: 30,
        child: Row(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (pageIndex != 0) {
                  context.read<offer_bloc.OfferBloc>().add(offer_bloc.Init());
                  controller.jumpToPage(0);
                  setState(() {
                    pageIndex = 0;
                  });
                }
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/svg/offer_gift.svg"),
                      const SizedBox(width: kPadding10),
                      const Text("Cadeaux", style: kRBoldNunito18),
                    ],
                  ),
                  const Spacer(),

                  /// Indictor
                  Container(
                    height: pageIndex == 0 ? 4 : 1,
                    width: constraint.maxWidth / 2,
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: pageIndex == 0 ? BorderRadius.circular(kRadius100) : null,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (pageIndex != 1) {
                  context.read<project_bloc.ProjectBloc>().add(project_bloc.Init());
                  controller.jumpToPage(1);
                  setState(() {
                    pageIndex = 1;
                  });
                }
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/svg/tree.svg"),
                      const SizedBox(width: kPadding10),
                      const Text("Associations", style: kRBoldNunito18),
                    ],
                  ),
                  const Spacer(),

                  /// Indictor
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: pageIndex == 1 ? BorderRadius.circular(kRadius100) : null,
                    ),
                    height: pageIndex == 1 ? 4 : 1,
                    width: constraint.maxWidth / 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
