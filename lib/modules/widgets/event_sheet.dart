
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:manage_life_app/models/events_model.dart';
import 'package:manage_life_app/providers/event_provider.dart';
import 'package:manage_life_app/shared/styles/colors.dart';
import 'package:manage_life_app/shared/utiles/utils.dart';

class AddEventScreen extends StatefulWidget {
  final Event? event;

  const AddEventScreen({
    Key? key,
    this.event,
}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    super.initState();

    if(widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    } else {
      final event = widget.event!;

      titleController.text = event.title;
      descriptionController.text = event.description;
      fromDate = event.from;
      toDate = event.to;
      allDay = event.isAllDay;
    }
  }

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildAddingActions(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              const SizedBox(height: 10,),
              buildDateTimePicker(),
              const SizedBox(height: 10,),
              buildAllDayCheck(),
              const SizedBox(height: 10,),
              buildDescription(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildAddingActions() => [
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
          onPressed: saveForm,
          icon: Icon(
              Icons.done,
              color: mainColor,
          ),
          label: Text(
            "Save",
            style: TextStyle(
              color: mainColor
            ),
          )
      ),
  ];

  Widget buildTitle () => TextFormField(
    style: TextStyle(fontSize: 20),
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      hintText: "Add Event",
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
      labelText: "Add Event",
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
      fillColor: Colors.grey,
      prefixIcon: Icon(Icons.event, color: mainColor,),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    ),
    onFieldSubmitted: (_) => saveForm(),
    controller: titleController,
    validator: (title) =>
      title != null && title.isEmpty ? "Title can't be empty" : null,
  );

  Widget buildDescription () => TextFormField(
    minLines: 7,
    maxLines: 10,
    controller: descriptionController,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      hintText: "Description",
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
      labelText: "Description",
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
      fillColor: Colors.grey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    ),
    onFieldSubmitted: (_) => saveForm(),
  );

  Widget buildDateTimePicker () => Column(
    children: [
      buildFrom(),
      buildTo(),
    ],
  );

  Widget buildFrom() => buildHeader(
    header: 'FROM',
    child: Row(
      children: [
        Expanded(
          flex: 2,
            child: buildDropdownField(
              text: Utils.toDate(fromDate),
              onClicked: () {
                pickFromDateTime(pickDate: true);
              }
            )
        ),

        Expanded(
            child: buildDropdownField(
                text: Utils.toTime(fromDate),
                onClicked: () {
                  pickFromDateTime(pickDate: false);
                }
            )
        ),
      ],
    ),
  );

  Future pickFromDateTime({
  required bool pickDate
}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);

    if(date == null) return;

    if(date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() {
      fromDate = date;
    });
  }

  Future pickToDateTime({
    required bool pickDate,
  }) async {
    final date = await pickDateTime(
        toDate,
        pickDate: pickDate,
        firstDate: pickDate ? fromDate : null,
    );

    if(date == null) return;

    if(date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() {
      toDate = date;
    });
  }

  Future<DateTime?> pickDateTime(
      DateTime initialDate, {
        required bool pickDate,
        DateTime? firstDate,
      }) async {

    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2015, 8),
          lastDate: DateTime(2101)
      );

      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialDate));

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);

      final time =
      Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }


  Widget buildTo() => buildHeader(
    header: 'To',
    child: Row(
      children: [
        Expanded(
            flex: 2,
            child: buildDropdownField(
                text: Utils.toDate(toDate),
                onClicked: () => pickToDateTime(pickDate: true),
            )
        ),

        Expanded(
            child: buildDropdownField(
                text: Utils.toTime(toDate),
                onClicked: () => pickToDateTime(pickDate: false),
            )
        ),
      ],
    ),
  );

  bool allDay = false;

  void _onAllDayChanged(bool? newValue) => setState(() {
    allDay = newValue!;
  });

  Widget buildAllDayCheck () => Row(
    children: [
      Checkbox(
          value: allDay,
          onChanged: _onAllDayChanged,
      ),
      SizedBox(width: 5,),
      Text(
          "All Day?"
      ),
    ],
  );

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
}) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: TextStyle(fontWeight: FontWeight.bold),),
          child,
        ],
      );

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if(isValid) {
      final event = Event(
          title: titleController.text,
          description: descriptionController.text != null ? descriptionController.text : "No Description",
          from: fromDate,
          to: toDate,
        isAllDay: allDay,
      );

      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      if(isEditing) {
        provider.editEvent(event, widget.event!);
        Navigator.of(context).pop();
      } else {
        provider.addEvent(event);
        Navigator.of(context).pop();
      }

    }
  }
}

