import 'package:ai_story_maker/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  FAQScreenState createState() => FAQScreenState();
}

class FAQScreenState extends State<FAQScreen> {
  // Sample data

  final List<FAQItem> _faqItems = [
    FAQItem(
      question: "1 . What is Newton's First Law of Motion?",
      answer:
          "Ans: Newton's First Law of Motion states that an object will remain at rest or move in a straight line at a constant velocity unless acted upon by an external force.",
    ),
    FAQItem(
      question: "2 . What is the formula for calculating kinetic energy?",
      answer:
          "Ans: The formula for kinetic energy is KE = (1/2)mv^2, where \"m\" is the mass of the object and \"v\" is its velocity.",
    ),
    FAQItem(
      question: "3 . How do you find the derivative of a function?",
      answer:
          "Ans: To find the derivative of a function f(x) with respect to \"x,\" you use the rules of differentiation like the power rule, product rule, quotient rule, and chain rule.",
    ),
    FAQItem(
      question: "4 . What are the properties of a logarithm?",
      answer:
          "Ans: The properties of logarithms include the product rule (log(ab) = log(a) + log(b)), the quotient rule (log(a/b) = log(a) - log(b)), and the power rule (log(a^b) = b * log(a)).",
    ),
    FAQItem(
      question: "5 . What is the difference between an acid and a base?",
      answer:
          "Ans: Acids are substances that release hydrogen ions (H+) in a solution, while bases are substances that release hydroxide ions (OH-) in a solution. Acids have a pH less than 7, while bases have a pH greater than 7.",
    ),
    FAQItem(
      question: "6 . Define the Law of Conservation of Mass.",
      answer:
          "Ans: The Law of Conservation of Mass states that in a chemical reaction, the total mass of the reactants is equal to the total mass of the products, and mass is neither created nor destroyed.",
    ),
    FAQItem(
      question: "7 . What is the difference between weather and climate?",
      answer:
          "Ans: Weather refers to the short-term atmospheric conditions of a specific area, including temperature, humidity, precipitation, etc. Climate, on the other hand, represents the long-term average weather patterns of a region.",
    ),
    FAQItem(
      question:
          "8 . What are the major factors influencing the climate of a region?",
      answer:
          "Ans: The major factors influencing climate include latitude, altitude, proximity to water bodies, ocean currents, prevailing winds, and topography.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "FAQ",
          style: sfBold,
        ),
      ),
      body: ListView.builder(
        itemCount: _faqItems.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 5)
                ]),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ExpansionTile(
              title: Text(
                _faqItems[index].question,
                style: sfBold,
              ),
              childrenPadding: const EdgeInsets.all(18),
              expandedCrossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${_faqItems[index].answer} \n\nDisclaimer:\n\nThe Answers are powered by ChatGPT and might be inaccurate. Please refer to your official textbook for confirmation of the answer.",
                  style: sfSemiBold,
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                      text:
                          "${_faqItems[index].answer} \n\nDisclaimer:\n\nThe Answers are powered by ChatGPT and might be inaccurate. Please refer to your official textbook for confirmation of the answer.",
                    )).then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Center(
                                    child: Text(
                          "Copied",
                          style: sfBold,
                        )))));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Icon(
                      Icons.copy,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
              // onTap: () {
              //   _showAnswerDialog(_faqItems[index].answer);
              // },
            ),
          );
        },
      ),
    );
  }

  void _showAnswerDialog(String answer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Answer"),
          content: Text(answer),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

class FAQItem {
  String question;
  String answer;

  FAQItem({required this.question, required this.answer});
}
