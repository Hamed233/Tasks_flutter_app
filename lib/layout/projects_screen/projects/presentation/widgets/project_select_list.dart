import 'package:flutter/material.dart';
import 'package:manage_life_app/models/project_model.dart';
import 'package:manage_life_app/modules/widgets/bordered_container.dart';
import 'package:manage_life_app/shared/components/constants.dart';

import 'project_list_item.dart';

class ProjectSelectList extends StatefulWidget {
  final List<Project> projects;
  final Project? selectedProject;
  final Function(Project) onTap;

  const ProjectSelectList(
      {Key? key,
      required this.projects,
      this.selectedProject,
      required this.onTap})
      : super(key: key);
  @override
  _ProjectSelectListState createState() => _ProjectSelectListState();
}

class _ProjectSelectListState extends State<ProjectSelectList> {
  Project? _selectedProject;

  @override
  void initState() {
    super.initState();
    _selectedProject = widget.selectedProject;
  }

  @override
  Widget build(BuildContext context) {
    List<Project> projects = widget.projects
        .where((project) => project.status == ProjectStatus.ONGOING)
        .toList();
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        Project project = projects[index];
        return BorderedContainer(
          padding: const EdgeInsets.all(0),
          child: ProjectListItem(
            project: project,
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
    );
  }
}
