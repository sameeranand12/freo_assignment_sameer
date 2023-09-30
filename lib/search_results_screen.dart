import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:freo/search_results_model.dart';
import 'package:provider/provider.dart';

class SearchResultsScreen extends StatefulWidget {
  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<SearchResult> searchResults = [];
  bool isLaunchingUrl = false;
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
    searchResults = Provider.of<SearchResultsModel>(context).results;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff447FF5),
          title: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: "Search",
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                final query = searchController.text;
                Provider.of<SearchResultsModel>(context, listen: false)
                    .fetchResults(query);
              },
            ),
          ],
        ),
        body: searchResults.isNotEmpty
            ? ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  return InkWell(
                    onTap: () async {
                      if (!isLaunchingUrl) {
                        isLaunchingUrl = true;
                        String url = result.webUrl;
                        print(url);
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          throw 'Could not launch $url';
                        }
                        isLaunchingUrl = false;
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 3,
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: result.imageUrl,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          title: Text(result.title),
                          subtitle: Text(result.description),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Container(
                  child: Image.asset('assets/images/wiki.png'),
                ),
              ));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
