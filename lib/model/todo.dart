// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';

// // // class SearchResult {
// // //   final String title;
// // //   final String description;
// // //   final String imageUrl;
// // //   final String webUrl;
// // //   SearchResult({
// // //     required this.title,
// // //     required this.description,
// // //     required this.imageUrl,
// // //     required this.webUrl,
// // //   });
// // // }

// // // class SearchResultsModel extends ChangeNotifier {
// // //   List<SearchResult> _results = [];

// // //   List<SearchResult> get results => _results;

// // //   Future<void> fetchResults(String query) async {

    
// // //     var baseUrl = 'https://en.wikipedia.org'; 
// // //    // https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=Sachin+T&gpslimit=10
    
// // //     final response = await http.get(
// // //       Uri.parse('$baseUrl//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=$query&gpslimit=10'),
// // //     );

// // //     if (response.statusCode == 200) {
// // //       final Map<String, dynamic> data = json.decode(response.body);
// // //      // final List<dynamic> pages = data['query']['search'];
// // //       final List<dynamic> pages = data['query']['pages'];

// // //       _results = pages
// // //           .map((page) => SearchResult(
// // //                 title: page['title'],
// // //                 description: page['terms']!= null ? page['terms']['description'][0] : "hello",
// // //                 imageUrl: page['thumbnail']!= null ?page['thumbnail']['source']:"hi",
// // //                 webUrl: ''
// // //               ))
// // //           .toList();

// // //       notifyListeners();
// // //     } else {
// // //       throw Exception('Failed to load results');
// // //     }
// // //   }
// // // }



// // // class SearchResultsModel extends ChangeNotifier {
// // //   List<SearchResult> _results = [];

// // //   List<SearchResult> get results => _results;

// // //   Future<List<SearchResult>> fetchResults(String query) async {
// // //     var baseUrl = 'https://en.wikipedia.org';
// // //     final response = await http.get(
// // //       Uri.parse('$baseUrl//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=$query&gpslimit=10'),
// // //     );

// // //     if (response.statusCode == 200) {
// // //       final Map<String, dynamic> data = json.decode(response.body);
// // //       final List<dynamic> pages = data['query']['pages'];

// // //       _results = pages
// // //           .map((page) {
// // //             String newVariable = page['title'];

// // //             return SearchResult(
// // //               title: page['title'],
// // //               description: page['terms'] != null
// // //                   ? page['terms']['description'][0]
// // //                   : "hello",
// // //               imageUrl: page['thumbnail'] != null
// // //                   ? page['thumbnail']['source']
// // //                   : "hi",
// // //               webUrl: 'https://en.wikipedia.org/wiki/$newVariable',
// // //             );
// // //           })
// // //           .toList();

// // //       notifyListeners();

// // //       return _results; // Return the list of search results
// // //     } else {
// // //       throw Exception('Failed to load results');
// // //     }
// // //   }
// // // }


// // import 'package:flutter/material.dart';
// // import 'package:freo/search_query_model.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'package:freo/search_results_model.dart';
// // import 'package:provider/provider.dart';

// // class SearchResultsScreen extends StatefulWidget {
// //   @override
// //   State<SearchResultsScreen> createState() => _SearchResultsScreenState();
// // }

// // class _SearchResultsScreenState extends State<SearchResultsScreen> {
// //   List<SearchResult> searchResults = [];
// //   bool isLaunchingUrl = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     final searchQueryModel = Provider.of<SearchQueryModel>(context);

// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.deepPurple,
// //         title: Text('Wikipedia Search'),
// //       ),
// //       body: Column(
// //         children: [
// //           SearchBarWidget(), 
// //           Expanded(
// //             child: FutureBuilder(
// //               future: Provider.of<SearchResultsModel>(context)
// //                   .fetchResults(searchQueryModel.query), 
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return Center(child: CircularProgressIndicator());
// //                 } else if (snapshot.hasError) {
// //                   return Center(child: Text('Error: ${snapshot.error}'));
// //                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //                   return Center(child: Text('No results found.'));
// //                 } else {
// //                   // Build your result list here
// //                   return ListView.builder(
// //                     itemCount: snapshot.data!.length,
// //                     itemBuilder: (context, index) {
// //                       final result = snapshot.data![index];
// //                       return ListTile(
// //                         leading: Image.network(result.imageUrl),
// //                         title: Text(result.title),
// //                         subtitle: Text(result.description),
// //                         onTap: () async {
// //                           if (!isLaunchingUrl) {
// //                             isLaunchingUrl = true;
// //                             String url = result.webUrl;
// //                             print(url);
// //                             if (await canLaunchUrl(Uri.parse(url))) {
// //                               await launchUrl(Uri.parse(url));
// //                             } else {
// //                               throw 'Could not launch $url';
// //                             }
// //                             isLaunchingUrl = false;
// //                           }
// //                         },
// //                       );
// //                     },
// //                   );
// //                 }
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class SearchBarWidget extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final searchQueryModel = Provider.of<SearchQueryModel>(context);

// //     return TextField(
// //       onChanged: (newQuery) {
// //         searchQueryModel.updateQuery(newQuery);
// //       },
// //       decoration: InputDecoration(
// //         hintText: 'Search...',
// //         prefixIcon: Icon(Icons.search),
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:freo/search_query_model.dart';
// import 'package:freo/search_results_model.dart';
// import 'package:freo/search_results_screen.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Wikipedia Search',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (context) => SearchResultsModel()),
//           ChangeNotifierProvider(create: (context) => SearchQueryModel()),
//         ],
//         child: SearchResultsScreen(),
//       ),
//     );
//   }
// }


