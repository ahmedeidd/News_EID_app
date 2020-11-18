import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_json/bloc/search_bloc.dart';
import 'package:flutter_news_json/elements/error_element.dart';
import 'package:flutter_news_json/elements/load_element.dart';
import 'package:flutter_news_json/models/article_response.dart';
import 'package:flutter_news_json/models/atricle.dart';
import 'package:flutter_news_json/screens/detail_news.dart';
import 'package:flutter_news_json/style/theme.dart' as Style;
import 'package:timeago/timeago.dart' as timeago;
class SearchScreen extends StatefulWidget
{
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
{
  final _searchController = TextEditingController();
  @override
  void initState()
  {
    super.initState();
    searchBloc..search("");
  }
  @override
  Widget build(BuildContext context)
  {
    return Column(
      children:
      [
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
          child: TextFormField(
            controller: _searchController,
            style: TextStyle(fontSize: 14.0, color: Colors.black,),
            autocorrect: false,
            autovalidate: true,
            onChanged: (changed)
            {
              searchBloc..search(_searchController.text);
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: Colors.grey[200],
              suffixIcon: _searchController.text.length > 0
                  ? IconButton(
                icon: Icon(EvaIcons.backspaceOutline, color: Colors.grey[500], size: 16.0,),
                onPressed: ()
                {
                  setState(()
                  {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _searchController.clear();
                    searchBloc..search(_searchController.text);
                  });
                },
              ) : Icon(EvaIcons.searchOutline, color: Colors.grey[500], size: 16.0,),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200].withOpacity(0.3),),
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200].withOpacity(0.3)),
                borderRadius: BorderRadius.circular(30.0),
              ),
              contentPadding: EdgeInsets.only(left: 15.0, right: 10.0),
              labelText: "Search...",
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<ArticleResponse>(
            stream: searchBloc.subject.stream,
            builder: (context, AsyncSnapshot<ArticleResponse> snapshot)
            {
              if (snapshot.hasData)
              {
                if (snapshot.data.error != null && snapshot.data.error.length > 0)
                {
                  return Container();
                }
                return _buildSourceNewsWidget(snapshot.data);
              }
              else if (snapshot.hasError)
              {
                return Container();
              } else {
                return buildLoadingWidget();
              }
            },
          ),
        ),
      ],
    );
  }
  //****************************************************************************
  // start build source news widget
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
          children:
          [
            Text(
              "No more news",
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      );
    }
    else
    {
      return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context , index)
        {
          return GestureDetector(
            onTap: ()
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailNews(article: articles[index],)),
              );
            },
            child: Container(
              height: 150.0,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200], width: 1.0),
                ),
                color: Colors.white,
              ),
              child: Row(
                children:
                [
                  Container(
                    padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
                    width: MediaQuery.of(context).size.width * 3 / 5,
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
                                      timeUntil(
                                        DateTime.parse(articles[index].date),
                                      ),
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
                      height: MediaQuery.of(context).size.height * 1 / 3,
                      alignment: Alignment.topCenter,
                      placeholder: 'assets/img/placeholder.jpg',
                      image: articles[index].img == null
                          ? "http://to-let.com.bd/operator/images/noimage.png"
                          : articles[index].img,
                      fit: BoxFit.fitHeight,
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
  //****************************
  String timeUntil(DateTime date)
  {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
  //*****************************
  // end build source news widget
  //****************************************************************************
}
