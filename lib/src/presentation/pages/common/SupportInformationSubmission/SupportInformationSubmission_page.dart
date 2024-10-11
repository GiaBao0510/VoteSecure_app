import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ContactUsModel.dart';
import 'package:votesecure/src/domain/repositories/UserRepository.dart';

class FeedbackPage extends StatefulWidget {
  static const routeName = 'send-comments';
  final String IDSender;
  const FeedbackPage({
    super.key,
    required this.IDSender
  });

  @override
  _FeedbackPageState createState() => _FeedbackPageState(IDSender: IDSender);
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final UserRepository userRepository = UserRepository();
  WidgetlibraryState widgetlibraryState = WidgetlibraryState();
  final TextEditingController _messageController = TextEditingController();
  final String IDSender;
  _FeedbackPageState({required this.IDSender});
  ContactUsModel contactUsModel = ContactUsModel('', '');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: FittedBox(
          fit: BoxFit.fitWidth,
            child: Text(
                'Gửi ý kiến hỗ trợ',
              style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.indigo
              ),
            )
        ),
        centerTitle: true,
      ),
      body:  Stack(
        children: [
          widgetlibraryState.buildPageBackgroundGradient3Color(context, '0xff3466a8', '0xff2f80ed','0xff60b5e6'),
          _BuildFeedbackForm(context)
        ],
      ),
    );
  }

  Widget _BuildFeedbackForm(BuildContext context){
    return
      // Form card
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FractionallySizedBox(
                          child: Lottie.asset(
                          'assets/animations/ContactUs.json',
                          repeat: true,
                          fit: BoxFit.contain,
                          height: 250,
                          width: double.infinity
                          ),
                        ),
                        const Text(
                          'Nếu bạn có ý kiến, thắc mắc hoặc đề xuất, hãy điền '
                          'nội dung tin nhắn của bạn. Chúng tôi sẽ tiếp nhận '
                          'và xử lý nhanh chóng. Mọi góp ý đều giúp chúng tôi '
                          'nâng cao chất lượng dịch vụ và hỗ trợ bạn tốt hơn',
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Divider(),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _messageController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Message',
                          ),
                          validator: (value) {
                            if (value == null || value.length < 10) {
                              return 'Please enter at least 10 characters';
                            }
                            contactUsModel.YKien = value;
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                contactUsModel.IDSender = IDSender;

                                await userRepository.SendComments(context, contactUsModel);

                                setState(() {
                                  _messageController.clear();
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Feedback sent!')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please fill all fields with at least 10 characters'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                              backgroundColor: Color(0xff2193b0), // Button color
                            ),
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
