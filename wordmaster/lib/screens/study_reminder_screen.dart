import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/reminder_controller.dart';
import '../models/study_reminder.dart';
import '../utils/reminder_strings.dart';

class StudyReminderScreen extends StatefulWidget {
  const StudyReminderScreen({super.key});

  @override
  State<StudyReminderScreen> createState() => _StudyReminderScreenState();
}

class _StudyReminderScreenState extends State<StudyReminderScreen> {
  TimeOfDay? _selectedTime;
  bool _isRepeating = false;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ReminderStrings _strings = ReminderStrings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_strings.screenTitle)),
      body: Consumer<ReminderController>(
        builder: (context, reminderController, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildReminderList(reminderController),
              const SizedBox(height: 16),
              _buildAddReminderForm(reminderController),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReminderList(ReminderController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _strings.yourReminders,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...controller.reminders.map(
          (reminder) => Card(
            child: ListTile(
              title: Text(reminder.title),
              subtitle: Text(reminder.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${reminder.scheduledTime.hour}:${reminder.scheduledTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => controller.removeReminder(reminder.id),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddReminderForm(ReminderController controller) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _strings.addNewReminder,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: _strings.titleHint,
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return _strings.pleaseEnterTitle;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: _strings.titleHint,
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(
              _selectedTime == null
                  ? _strings.selectTime
                  : _strings.getTime(
                      '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                    ),
            ),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                setState(() {
                  _selectedTime = time;
                });
              }
            },
          ),
          SwitchListTile(
            title: Text(_strings.repeatDaily),
            value: _isRepeating,
            onChanged: (bool value) {
              setState(() {
                _isRepeating = value;
              });
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _selectedTime != null) {
                  final now = DateTime.now();
                  final scheduledTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    _selectedTime!.hour,
                    _selectedTime!.minute,
                  );

                  final reminder = StudyReminder(
                    id: DateTime.now().millisecondsSinceEpoch,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    scheduledTime: scheduledTime,
                    isRepeating: _isRepeating,
                    userId: 1, // TODO: Get actual user ID
                  );

                  controller.addReminder(reminder);

                  // Clear form
                  _titleController.clear();
                  _descriptionController.clear();
                  setState(() {
                    _selectedTime = null;
                    _isRepeating = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(_strings.reminderAddedSuccess)),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_strings.addReminder),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
