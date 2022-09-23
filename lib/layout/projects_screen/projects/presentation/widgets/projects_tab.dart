import 'package:flutter/material.dart';
import 'package:manage_life_app/layout/projects_screen/projects/presentation/widgets/project_list.dart';

class ProjectsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ProjectList(typeOfProjects: "allProjects"),
    );
  }
}