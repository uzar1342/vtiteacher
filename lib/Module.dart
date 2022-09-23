import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'configs/globals.dart';

class Module extends StatefulWidget {
  final String id;
  const Module({Key? key, required this.id})
      : super(key: key);

  @override
  _ModuleState createState() => _ModuleState();
}

class _ModuleState extends State<Module> {
  final TextEditingController _searchController = TextEditingController();
  bool showSearch = false;
 Future<dynamic> fetchCourseList() async {
    Dio dio=Dio();
    var formData = FormData.fromMap({
      'sub_course_id': widget.id
    });
    print(formData.fields);
    var response = await dio.post('http://training.virash.in/showModulesAndDetails', data: formData);
    if (response.statusCode == 200) {
        print(response.data);
      return response.data;
    } else {
      Fluttertoast.showToast(msg: "Please try again later");
      return response.data;
    }
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: SafeArea(
          child:Container(
            padding: const EdgeInsets.all(15.0),
            child: FutureBuilder<dynamic>(
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: TextStyle(fontSize: 18),
                      ),
                    );

                    // if we got our data
                  } else if (snapshot.hasData) {
                    return Column(
                      children: [
                        showSearch
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: w * 0.7,
                              child: Card(
                                //margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                                elevation: 4,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                                child: TextFormField(
                                  controller: _searchController,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Colors.orange.shade200,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.black38,
                                          size: 20.0,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                          });
                                        },
                                      ),
                                      hintText: "Search",
                                      hintStyle:
                                      const TextStyle(color: Colors.black26),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18.0)),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 16.0)),
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    showSearch = false;
                                    _searchController.clear();
                                  });
                                },
                                child: Text("Close",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      decoration: TextDecoration.underline,
                                    ))),
                          ],
                        )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  // top: 10.0,
                                  // left: 15.0,
                                ),
                                //padding: const EdgeInsets.only(left: 5.0),
                                height: h * 0.05,
                                width: h * 0.05,
                                decoration: BoxDecoration(
                                  // color: primaryColor,
                                    border: Border.all(
                                        color: Colors.black26, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.black87,
                                  size: 18.0,
                                ),
                              ),
                            ),
                            Text(
                              "ModulesAndDetails",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showSearch = true;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.search,
                                      color: primaryColor,
                                    )),

                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            primary: false,
                            shrinkWrap: true,
                            itemCount: snapshot.data["data"].length,
                            itemBuilder: (context, index) {
                              if (snapshot.data["data"][index]["module_name"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(_searchController.text.toLowerCase())) {
                                return ExpandableNotifier(
                                    child: ScrollOnExpand(
                                      child: Card(
                                        clipBehavior: Clip.antiAlias,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(14.0))),
                                        child: Column(
                                          children: <Widget>[
                                            ExpandablePanel(
                                              theme: const ExpandableThemeData(
                                                headerAlignment:
                                                ExpandablePanelHeaderAlignment.center,
                                                tapBodyToExpand: true,
                                                tapBodyToCollapse: true,
                                                hasIcon: false,
                                              ),
                                              header: Container(
                                                // color: Colors.indigoAccent,
                                                margin: const EdgeInsets.all(5.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "Section ${index + 1} - ${snapshot.data["data"][index]["module_name"]} ",
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight.w500),
                                                        ),
                                                      ),
                                                      snapshot.data["data"][index]["details"]
                                                          .isEmpty
                                                          ? Container()
                                                          : ExpandableIcon(
                                                        theme:
                                                        const ExpandableThemeData(
                                                          expandIcon: Icons.add,
                                                          collapseIcon:
                                                          Icons.remove,
                                                          iconColor: Colors.black,
                                                          iconSize: 22.0,
                                                          //iconRotationAngle: math.pi / 2,
                                                          iconPadding:
                                                          EdgeInsets.only(
                                                              right: 5),
                                                          hasIcon: false,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              collapsed: Container(),
                                              expanded: buildList(
                                                  snapshot.data["data"][index]["details"]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              } else {
                                return Container();
                              }
                            }),
                      ],
                    );
                  }
                }
                // Displaying LoadingSpinner to indicate waiting state
                return Center(
                child: CircularProgressIndicator(),
                );
              },
              future: fetchCourseList(),
            ),
          )),
        ),
      );
  }

  buildItem(var i, int index) {
    return InkWell(
      onTap: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => const VideoDetailsPage()));
      },
      child: Card(
        elevation: 0.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${index + 1}. ${i['module_description_name']}",
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),

                ],
              ),
              Icon(
                Icons.play_circle,
                color: primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  buildList(List videoLectures) {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: <Widget>[
          for (int i = 0; i < videoLectures.length; i++)
            buildItem(videoLectures[i], i),
        ],
      ),
    );
  }
}
