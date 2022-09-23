// import 'package:flutter/material.dart';
// import 'package:manage_life_app/models/project_model.dart';

// class ProjectDetailsPage extends StatelessWidget {
//   final Project? project;

//   const ProjectDetailsPage({Key? key, this.project}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(project.title),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: DateChooserWrapper(
//           builder: (context, from, to, chartTimeType) {
//             return FutureBuilder(
//               future: logDBS.getListFromTo('date', from, to,
//                   args: [QueryArgs('project_id', project.id)]),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (snapshot.hasError) {
//                   print(snapshot.error);
//                   return Container(
//                     child: Text("Error"),
//                   );
//                 }
//                 if (!snapshot.hasData) return CircularProgressIndicator();
//                 return StatsFromLogs(
//                   logs: snapshot.data,
//                   chartTimeType: chartTimeType,
//                   showProjects: false,
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
