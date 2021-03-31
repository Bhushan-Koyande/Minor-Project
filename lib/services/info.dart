import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:minor_project/models/article.dart';

class News{

  List<Article> news = [];

  Future<void> getNews() async {

    String url = 'https://newsapi.org/v2/top-headlines?q=covid&language=en&sortBy=publishedAt&apiKey=daa3218f2a32449fa3ef50e69dd423d5';

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == 'ok'){
      jsonData['articles'].forEach((element){
        if(element['urlToImage'] != null && element['description'] != null){
          Article article = Article(
              title: element['title'],
              author: element['author'],
              description: element['description'],
              url: element['url'],
              urlToImage: element['urlToImage'],
              content: element['context']
          );
          news.add(article);
        }
      });
    }
  }

}