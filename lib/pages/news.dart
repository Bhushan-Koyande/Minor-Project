import 'package:flutter/material.dart';
import 'package:minor_project/models/article.dart';
import 'package:minor_project/pages/article.dart';
import 'package:minor_project/services/info.dart';

//Flutter - version 2.0.3
//Dart - version 2.12.2

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  List<Article> articles =[];
  bool _loading = true;

  @override
  void initState(){
    super.initState();
    getNews();
  }

  getNews() async {
    News news = News();
    await news.getNews();
    articles = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Updates"),
        centerTitle: true,
      ),
      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ):
      Container(
        padding: EdgeInsets.only(top: 16),
        child: ListView.builder(
            itemCount: articles.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context,index){
              return BlogTile(
                imageUrl: articles[index].urlToImage,
                title: articles[index].title,
                desc: articles[index].description,
                url: articles[index].url,
              );
            }
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {

  final String imageUrl,title,desc,url;
  BlogTile({@required this.imageUrl,@required this.title,@required this.desc,@required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArticlePage(
          postUrl: url,
        )
        )
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl)
            ),
            SizedBox(height: 8,),
            Text(title,style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500,color: Colors.black87),),
            SizedBox(height: 8,),
            Text(desc,style: TextStyle(color: Colors.black54),),
          ],
        ),
      ),
    );
  }
}
