import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:freo/search_results_model.dart';

class SearchResultsScreen extends StatefulWidget {
  final List<SearchResult> searchResults;

  SearchResultsScreen(this.searchResults, {super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool isLaunchingUrl = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff447FF5),
        title: const Text(
          'Searched Results',
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.searchResults.length,
        itemBuilder: (context, index) {
          final result = widget.searchResults[index];
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
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(result.title),
                  subtitle: Text(result.description),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
