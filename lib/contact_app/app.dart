import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'app.g.dart';

// Constants for box names and relationships
const String contactsBoxName = "contacts";
const Map<Relationship, String> relationshipTypes = {
  Relationship.FAMILY: "Family",
  Relationship.FRIEND: "Friend",
};

// Enum for relationship types
@HiveType(typeId: 1)
enum Relationship {
  @HiveField(0)
  FAMILY,
  @HiveField(1)
  FRIEND,
}

// Contact class definition
@HiveType(typeId: 0)
class Contact {
  @HiveField(0)
  String name;
  @HiveField(1)
  int age;
  @HiveField(2)
  Relationship relationship;
  @HiveField(3)
  String phoneNumber;

  Contact(this.name, this.age, this.phoneNumber, this.relationship);
}

void main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters for Contact and Relationship classes
  Hive.registerAdapter(ContactAdapter());
  Hive.registerAdapter(RelationshipAdapter());

  // Open the Hive box for storing contacts
  await Hive.openBox<Contact>(contactsBoxName);

  // Run the Flutter application
  runApp(MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Widget for creating dividers between list items
    Widget buildDivider() => const SizedBox(height: 5);

    return MaterialApp(
      title: 'Contacts App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts App with Hive'),
        ),
        body: ValueListenableBuilder(
          // Listen for changes in the Hive box
          valueListenable: Hive.box<Contact>(contactsBoxName).listenable(),
          builder: (context, Box<Contact> box, _) {
            // Display a message if there are no contacts
            if (box.values.isEmpty) {
              return const Center(
                child: Text("No contacts"),
              );
            }

            // Build a list view to display contacts
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                // Get the contact at the current index
                Contact? contact = box.getAt(index);

                // Get the relationship string for the contact
                String? relationship = relationshipTypes[contact?.relationship];

                // Create a list tile for the contact
                return InkWell(
                  // Show a dialog to confirm deletion on long press
                  onLongPress: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => AlertDialog(
                        content: Text(
                          "Do you want to delete ${contact?.name}?",
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("No"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text("Yes"),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await box.deleteAt(index); // Delete the contact
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          buildDivider(),
                          // Display contact name (handle null values)
                          Text(contact?.name ?? ""),
                          buildDivider(),
                          // Display contact phone number (handle null values)
                          Text(contact?.phoneNumber ?? ""),
                          buildDivider(),
                          // Display contact age (handle null values)
                          Text("Age: ${contact?.age ?? ""}"),
                          buildDivider(),
                          // Display contact relationship
                          Text("Relationship: $relationship"),
                          buildDivider(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        // Floating action button to add a new contact
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            // Navigate to the AddContact screen
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddContact()),
            );
          },
        ),
      ),
    );
  }
}

// Widget for adding a new contact
class AddContact extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  AddContact({super.key});

  @override
  _AddContactState createState() => _AddContactState();
}

// State for the AddContact widget
class _AddContactState extends State<AddContact> {
  String name = "";
  int age = 0;
  String phoneNumber = "";
  Relationship relationship = Relationship.FAMILY;

  // Handle form submission
  void onFormSubmit() {
    if (widget.formKey.currentState!.validate()) {
      // Get the Hive box for contacts
      Box<Contact> contactsBox = Hive.box<Contact>(contactsBoxName);

      // Add the new contact to the box
      contactsBox.add(Contact(name, age, phoneNumber, relationship));

      // Navigate back to the previous screen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Contact"),
      ),
      body: SafeArea(
        child: Form(
          key: widget.formKey,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: <Widget>[
              // Text field for entering the contact's name
              TextFormField(
                autofocus: true,
                initialValue: "",
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                // Validate that the name field is not empty
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              // Text field for entering the contact's age
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: "",
                maxLength: 3,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: const InputDecoration(
                  labelText: "Age",
                ),
                onChanged: (value) {
                  setState(() {
                    // Handle potential parsing errors
                    age = int.tryParse(value) ?? 0;
                  });
                },
                // Validate that the age is a valid number
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              // Text field for entering the contact's phone number
              TextFormField(
                keyboardType: TextInputType.phone,
                initialValue: "",
                decoration: const InputDecoration(
                  labelText: "Phone",
                ),
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
              ),
              // Dropdown for selecting the contact's relationship
              DropdownButtonFormField<Relationship>(
                items: relationshipTypes.entries.map((entry) {
                  return DropdownMenuItem<Relationship>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                value: relationship,
                hint: const Text("Relationship"),
                onChanged: (value) {
                  setState(() {
                    relationship = value!;
                  });
                },
              ),
              // Button to submit the form
              ElevatedButton(
                onPressed: onFormSubmit,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
