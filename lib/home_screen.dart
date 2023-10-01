import 'package:flutter/material.dart';
import 'package:freo/searched_results_screen.dart';
import 'package:freo/search_results_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  final String text = '';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SearchResult> searchResults = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      final query = searchController.text;
      Provider.of<SearchResultsModel>(context, listen: false)
          .fetchResults(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: "Search",
              labelStyle: TextStyle(color: Color(0xff447FF5)),
            ),
          ),
        ),
        actions: [
          Container(
            color: const Color(0xff447FF5),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                final query = searchController.text;
                final searchResults = await Provider.of<SearchResultsModel>(
                  context,
                  listen: false,
                ).fetchResults(query);

                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return SearchResultsScreen(searchResults);
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Center(child: Image.asset('assets/images/wiki.png')),
    );
  }
}
