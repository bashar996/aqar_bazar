import 'package:aqar_bazar/providers/search_params_provider.dart';
import 'package:aqar_bazar/providers/search_result_provider.dart';
import 'package:aqar_bazar/screens/filter/price_range_slider.dart';
import 'package:aqar_bazar/screens/filter/property_params_model.dart';
import 'package:aqar_bazar/screens/filter/property_type_model.dart';
import 'package:aqar_bazar/screens/filter/search_result_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int _rentTypeSelectedIndex = 0;
  int _furnishedTypeSelectedIndex = 0;
  int _propertyTypeSelectedIndex = 0;
  int roomValue = 1;
  String cityValue;

  String priceRangeValue;

  String roomCountValue;

  String furnishedValue;

  List<SellingTypes> _rentType = [];

  List<Furnished> _furnishedType = [];

  List<City> _cityList = [];

  List<PriceRanges> _pricesList = [];

  List<Capacity> _roomCountList = [];

  List<Furnished> _furnishedList = [];

  String _chosenValue;

  RangeValues _values = const RangeValues(100, 600);

  List<PropertyTypeModel> propertyList = [
    PropertyTypeModel(name: "villa", iconData: Icons.home),
    PropertyTypeModel(name: "House", iconData: Icons.hotel),
    PropertyTypeModel(name: "apartment", iconData: Icons.local_post_office),
    PropertyTypeModel(name: "Office", iconData: Icons.hot_tub),
    PropertyTypeModel(name: "Hotel Room", iconData: Icons.home),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _rentType = Provider.of<SearchParamsProvider>(context, listen: false)
        .sellingTypesList;

    _furnishedType =
        Provider.of<SearchParamsProvider>(context, listen: false).furnishedList;

    _cityList =
        Provider.of<SearchParamsProvider>(context, listen: false).cityList;

    _pricesList =
        Provider.of<SearchParamsProvider>(context, listen: false).pricesList;

    _roomCountList =
        Provider.of<SearchParamsProvider>(context, listen: false).capacityList;

    _furnishedList =
        Provider.of<SearchParamsProvider>(context, listen: false).furnishedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider.of<SearchParamsProvider>(context).isLoading()
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Filter",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: Offset(0, 4),
                              color: Color.fromRGBO(226, 229, 235, 1))
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _rentType
                            .asMap()
                            .entries
                            .map((MapEntry map) => _iconRow(map.key, _rentType))
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'property type',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width > 360
                                  ? 18
                                  : 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: propertyList
                          .asMap()
                          .entries
                          .map((MapEntry map) => _propertyType(map.key))
                          .toList(),
                    ),
                    Divider(
                      color: Colors.grey,
                      indent: 20,
                      endIndent: 20,
                    ),
                    dropDownFurnished(),
                    dropDownSelectCity(),
                    dropDownSelectPrice(),
                    dropDownRoomCount(),
                    RaisedButton.icon(
                        onPressed: () async {
                          SearchResultModel searchResultModel =
                              await Provider.of<SearchResultProvider>(context,
                                      listen: false)
                                  .search();
                          print("//////////////////**********/////////" +
                              searchResultModel.toString());
                          print(
                              "****************////////////////*************");
                        },
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 3,
                            vertical: 10),
                        icon: Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Apply",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _iconRow(int index, List<SellingTypes> list) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _rentTypeSelectedIndex = index;
        });
      },
      child: Container(
        height: 60.0,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, 4),
                color: Color.fromRGBO(226, 229, 235, 1))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: _rentTypeSelectedIndex == index
              ? _selectedContainer(index, list)
              : _unSelectedContainer(index, list),
        ),
      ),
    );
  }

  Widget _selectedContainer(int index, List<SellingTypes> list) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              blurRadius: 1,
              spreadRadius: 1,
              offset: Offset(0, 4),
              color: Colors.white)
        ],
      ),
      child: Center(
          child: Text(
        list[index].name,
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget _furnishedSelectedContainer(int index, List<Furnished> list) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              blurRadius: 1,
              spreadRadius: 1,
              offset: Offset(0, 4),
              color: Colors.white)
        ],
      ),
      child: Center(
          child: Text(
        list[index].name,
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget _unSelectedContainer(int index, List<SellingTypes> list) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 1,
              spreadRadius: 1,
              offset: Offset(0, 4),
              color: Color.fromRGBO(226, 229, 235, 1))
        ],
      ),
      child: Center(
          child: Text(
        list[index].name,
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget _furnishedUnSelectedContainer(int index, List<Furnished> list) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 1,
              spreadRadius: 1,
              offset: Offset(0, 4),
              color: Color.fromRGBO(226, 229, 235, 1))
        ],
      ),
      child: Center(
          child: Text(
        list[index].name,
        style: TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget _locationContainer(String text, IconData icon) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.symmetric(
        horizontal: 40,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(226, 229, 235, 1),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 25,
          ),
          SizedBox(
            width: 50,
          ),
          Text(text,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              )),
          Spacer(),
        ],
      ),
    );
  }

  Widget _propertyType(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _propertyTypeSelectedIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            height: _propertyTypeSelectedIndex == index ? 60.0 : 50.0,
            width: _propertyTypeSelectedIndex == index ? 60.0 : 50.0,
            decoration: BoxDecoration(
              color: _propertyTypeSelectedIndex == index
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: Offset(0, 4),
                    color: Colors.grey[400])
              ],
            ),
            child: Icon(
              propertyList[index].iconData,
              size: _propertyTypeSelectedIndex == index ? 25.0 : 20,
              color: _propertyTypeSelectedIndex == index
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              propertyList[index].name,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget priceBarFilter() {
    return Container(
      width: MediaQuery.of(context).copyWith().size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Price Range',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize:
                          MediaQuery.of(context).size.width > 360 ? 18 : 16,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          RangeSliderView(
            values: _values,
            onChangeRangeValues: (RangeValues values) {
              _values = values;
            },
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget dropDownSelectCity() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, 4),
                color: Color.fromRGBO(226, 229, 235, 1))
          ],
        ),
        child: DropdownButton(
            hint: Text("City"),
            dropdownColor: Color.fromRGBO(226, 229, 235, 1),
            isExpanded: true,
            underline: Container(),
            value: cityValue,
            items: _cityList.map<DropdownMenuItem<String>>((City value) {
              return DropdownMenuItem<String>(
                value: value.id.toString(),
                child: Center(child: Text(value.name)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                cityValue = value;
              });
            }),
      ),
    );
  }

  Widget dropDownSelectPrice() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, 4),
                color: Color.fromRGBO(226, 229, 235, 1))
          ],
        ),
        child: DropdownButton(
            hint: Text("Price"),
            dropdownColor: Color.fromRGBO(226, 229, 235, 1),
            isExpanded: true,
            underline: Container(),
            value: priceRangeValue,
            items:
                _pricesList.map<DropdownMenuItem<String>>((PriceRanges value) {
              return DropdownMenuItem<String>(
                value: value.range,
                child: Center(child: Text(value.range)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                priceRangeValue = value;
              });
            }),
      ),
    );
  }

  Widget dropDownRoomCount() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, 4),
                color: Color.fromRGBO(226, 229, 235, 1))
          ],
        ),
        child: DropdownButton(
            hint: Text("Capacity"),
            dropdownColor: Color.fromRGBO(226, 229, 235, 1),
            isExpanded: true,
            underline: Container(),
            value: roomCountValue,
            items:
                _roomCountList.map<DropdownMenuItem<String>>((Capacity value) {
              return DropdownMenuItem<String>(
                value: value.value.toString(),
                child: Center(child: Text(value.value.toString())),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                roomCountValue = value.toString();
              });
            }),
      ),
    );
  }

  Widget dropDownFurnished() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(0, 4),
                color: Color.fromRGBO(226, 229, 235, 1))
          ],
        ),
        child: DropdownButton(
            hint: Text("Furnished"),
            dropdownColor: Color.fromRGBO(226, 229, 235, 1),
            isExpanded: true,
            underline: Container(),
            value: furnishedValue,
            items:
                _furnishedList.map<DropdownMenuItem<String>>((Furnished value) {
              return DropdownMenuItem<String>(
                value: value.id,
                child: Center(child: Text(value.name)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                furnishedValue = value.toString();
              });
            }),
      ),
    );
  }
}
