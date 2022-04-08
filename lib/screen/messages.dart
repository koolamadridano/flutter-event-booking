import 'package:app/const/colors.dart';
import 'package:app/controllers/messagesController.dart';
import 'package:app/screen/messages_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final _messages = Get.put(MessagesController());
  late Future _futureMessages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureMessages = _messages.getMesages();
  }

  void refresh() {
    setState(() {
      _futureMessages = _messages.getMesages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.white,
        // shape: Border(
        //   bottom: BorderSide(color: secondary.withOpacity(0.2), width: 0.5),
        // ),
        leading: IconButton(
          splashRadius: 20.0,
          icon: const Icon(AntDesign.arrowleft),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "My Messages",
          style: GoogleFonts.fredokaOne(
            color: secondary.withOpacity(0.8),
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _futureMessages,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const LinearProgressIndicator(
              minHeight: 2,
              color: secondary,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(
              minHeight: 2,
              color: secondary,
            );
          }
          if (snapshot.data == null) {
            return const LinearProgressIndicator(
              minHeight: 2,
              color: secondary,
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.length == 0) {
              return const Center(
                child: Icon(
                  MaterialIcons.inbox,
                  color: Colors.black26,
                  size: 82.0,
                ),
              );
            }
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              final _isOpened = snapshot.data[index]["opened"] as bool;
              final _date = snapshot.data[index]["createdAt"];
              return Container(
                color: _isOpened
                    ? Colors.white
                    : const Color.fromARGB(
                        255,
                        252,
                        252,
                        252,
                      ),
                child: ListTile(
                  onTap: () {
                    if (!_isOpened) {
                      _messages.openMessage(snapshot.data[index]["_id"]);
                    }
                    _messages.selectedMessage = snapshot.data[index];
                    Get.to(() => const MessagesPreview());
                  },
                  contentPadding: const EdgeInsets.all(25.0),
                  title: Text(
                    "ADMIN",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      fontSize: 17.0,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data[index]["message"],
                        style: GoogleFonts.roboto(
                          fontWeight:
                              _isOpened ? FontWeight.w300 : FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 14.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        Jiffy(_date).fromNow(),
                        style: GoogleFonts.roboto(
                          fontWeight:
                              _isOpened ? FontWeight.w300 : FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
