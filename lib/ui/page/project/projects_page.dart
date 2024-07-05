import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/project/project_bloc.dart';
import 'package:hoora/common/alert.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/model/project_model.dart';
import 'package:hoora/ui/widget/organization/project_card.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> with AutomaticKeepAliveClientMixin {
  late ProjectBloc projectBloc;

  @override
  void initState() {
    super.initState();
    projectBloc = context.read<ProjectBloc>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<ProjectBloc, ProjectState>(
      listener: (context, state) {
        if (state is InitFailed) {
          Alert.showError(context, state.exception.message);
        }
      },
      builder: (context, state) {
        if (state is InitLoading || state is InitFailed) {
          return const Center(child: CircularProgressIndicator(color: kPrimary));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
          child: ListView.builder(
              itemCount: projectBloc.projects.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                Project project = projectBloc.projects[index];
                EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 10);

                if (index == projectBloc.projects.length - 1 && projectBloc.projects.length > 1) {
                  padding = const EdgeInsets.only(bottom: 20);
                }

                return Padding(
                  padding: padding,
                  child: ProjectCard(project: project),
                );
              }),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
