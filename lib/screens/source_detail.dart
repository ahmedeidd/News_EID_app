import 'package:flutter/material.dart';
import 'package:flutter_news_json/bloc/get_source_news_bloc.dart';
import 'package:flutter_news_json/elements/error_element.dart';
import 'package:flutter_news_json/elements/load_element.dart';
import 'package:flutter_news_json/models/article_response.dart';
import 'package:flutter_news_json/models/atricle.dart';
import 'package:flutter_news_json/screens/detail_news.dart';
import 'package:flutter_news_json/style/theme.dart' as Style;
import 'package:flutter_news_json/models/source.dart';
import 'package:timeago/timeago.dart' as timeago;
class SourceDetail extends StatefulWidget
{
  final SourceModel source;
  SourceDetail({Key key, @required this.source}) : super(key: key);
  @override
  _SourceDetailState createState() => _SourceDetailState(source);
}

class _SourceDetailState extends State<SourceDetail>
{
  final SourceModel source;
  _SourceDetailState(this.source);
  @override
  void initState()
  {
    super.initState();
    getSourceNewsBloc..getSourceNews(source.id);
  }
  @override
  void dispose()
  {
    getSourceNewsBloc.drainStream();
    super.dispose();
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: false,
          elevation: 0.0,
          backgroundColor: Style.Colors.mainColor,
          title: Text("",),
        ),
      ),
      body: Column(
        children:
        [
          Container(
            padding: EdgeInsets.only(right: 15.0,left: 15.0,bottom: 15.0),
            width: MediaQuery.of(context).size.width,
            color: Style.Colors.mainColor,
            child: Column(
              children:
              [
                Hero(
                  tag: source.id,
                  child: SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2.0,color:Colors.white),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/logos/${source.id}.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.0,),
                Text(
                  source.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5.0,),
                Text(
                  source.description,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<ArticleResponse>(
              stream: getSourceNewsBloc.subject.stream,
              builder: (context,AsyncSnapshot<ArticleResponse> snapshot)
              {
                if(snapshot.hasData)
                {
                  if(snapshot.data.error != null && snapshot.data.error.length > 0)
                  {
                    return buildErrorWidget(snapshot.data.error);
                  }
                  return _buildSourceNewsWidget(snapshot.data);
                }
                else if(snapshot.hasError)
                {
                  return buildErrorWidget(snapshot.error);
                }
                else {
                  return buildLoadingWidget();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  //****************************************************************************
  // start build Source News Widget
  Widget _buildSourceNewsWidget(ArticleResponse data)
  {
    List<ArticleModel> articles = data.articles;
    if(articles.length == 0)
    {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "No more news",
              style: TextStyle(
                color: Colors.black45
              ),
            ),
          ],
        ),
      );
    }
    else
    {
      return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context,index)
        {
          return GestureDetector(
            onTap: ()
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:(context) => DetailNews(article: articles[index]),
                ),
              );
            },
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200],width: 1.0),),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 10.0,right: 10.0),
                    width: MediaQuery.of(context).size.width * 3/5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Text(
                          articles[index].title,
                          maxLines: 3,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:
                              [
                                Row(
                                  children:
                                  [
                                    Text(
                                      timeUntil(DateTime.parse(articles[index].date)),
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    width: MediaQuery.of(context).size.width * 2 / 5,
                    height: 130,
                    child: FadeInImage.assetNetwork(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 1/3,
                      alignment: Alignment.topCenter,
                      placeholder: 'assets/img/placeholder.jpg',
                      image: articles[index].img == null
                          ? "http://to-let.com.bd/operator/images/noimage.png"
                          : articles[index].img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
  //*****************************
   String timeUntil(DateTime date)
   {
     return timeago.format(date, allowFromNow: true, locale: 'en');
   }
  //*****************************
  // end build Source News Widget
  //****************************************************************************
}
