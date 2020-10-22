import 'package:contacs_app/data/dbHelper.dart';
import 'package:contacs_app/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'add_contact_page.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  DbHelper _dbHelper;
  @override
  void initState() {
    _dbHelper = DbHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kişiler"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddContactPage(contact: Contact())));
        },
        child: Icon(Icons.add),
      ),
      body: buildContactList(),
    );
  }

  buildContactList() {
    return FutureBuilder(
      future: _dbHelper.getContacts(),
      builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        if (snapshot.data.isEmpty) return Text("Your contact list empty");
        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Contact contact = snapshot.data[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddContactPage(contact: contact)));
                },
                child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onDismissed: (direction) async {
                    await _dbHelper.removeContact(contact.id);
                    setState(() {});
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${contact.name} has been saved"),
                        action: SnackBarAction(
                          label: "UNDO",
                          onPressed: () async {
                            await _dbHelper.insertContact(contact);
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                        contact.avatar == null
                            ? "assets/img/person.jpg"
                            : contact.avatar,
                      ),
                      child: Text(
                        contact.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(contact.name),
                    subtitle: Text(contact.phoneNumber),
                    trailing: IconButton(
                        icon: Icon(Icons.phone),
                        onPressed: () async =>
                            _callContact(contact.phoneNumber)),
                  ),
                ),
              );
            });
      },
    );
  }

  _callContact(String phoneNumber) async {
    String tel = "tel:$phoneNumber";
    if (await canLaunch(tel)) {
      await launch(tel);
    }
  }
}
