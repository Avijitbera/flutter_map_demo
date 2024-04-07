import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map_demo/data.model.dart';
import 'package:flutter_map_demo/location.controller.dart';

class SearchDialog extends StatefulWidget {
  PlaceModel? from;
  PlaceModel? to;
  Function(PlaceModel, PlaceModel) onSubmit;
   SearchDialog({super.key, required this.onSubmit, this.from, this.to });

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();

  PlaceModel? _fromData;
  PlaceModel? _toData;

  List<String> _search_data = [];
  String? selectedFrom;
  String? selectedTo;
  bool fromCompleted = false;

  void onChanged(String value,)async{
    var result = await searchLocality(value);
    setState(() {
      _search_data = result;
    });
  }

  void _getPlace(String input, bool isFrom)async{
   var result = await findDetails(input);
   if(result != null){
    setState(() {
      if(isFrom){
        setState(() {
          _fromData = result;
        });
      }else{
        setState(() {
          _toData = result;
        });
      }
    });
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      floatingActionButton: _fromData != null && _toData != null ? FloatingActionButton(onPressed: (){
        widget.onSubmit(_fromData!, _toData!);
        Navigator.pop(context);
      },
      child: Icon(Icons.done),) : null,
      body: Column(
        children: [
          TextField(
            controller: _fromController,
            onChanged: (v) => onChanged(v),
            readOnly: selectedFrom == null ? false : true,
            decoration: InputDecoration(
              hintText: "Enter locality",
              suffixIcon: selectedFrom == null ? null : IconButton(icon: Icon(Icons.close),onPressed: (){
                setState(() {
                  _fromController.clear();
                  selectedFrom = null;
                  _fromData = null;
                });
              },)
            ),
          ),
           TextField(
            controller: _toController,
            onChanged: (v) => onChanged(v),
            readOnly: selectedTo == null ? false : true,
            decoration: InputDecoration(
              hintText: "Enter locality",
              suffixIcon: selectedTo == null ? null : IconButton(icon: Icon(Icons.close),onPressed: (){
                setState(() {
                  _toController.clear();
                  selectedTo = null;
                  _toData = null;
                });
              },)
            ),
          ),
          Expanded(child: ListView.separated(itemBuilder: (context, index) {
            return ListTile(
              title: Text(_search_data[index],),
              onTap: (){
                setState(() {
                  if(!fromCompleted){
selectedFrom = _search_data[index];
                  _fromController.text =  _search_data[index];
                  fromCompleted = true;
                  
                  _getPlace(_search_data[index], true);
                  }else{
                    _toController.text =  _search_data[index];
                    selectedTo = _search_data[index];
                    
                    _getPlace(_search_data[index], false);
                  }
                  
                  _search_data.clear();
                });
              },
            );
          }, separatorBuilder: (context, index) {
            return Divider();
          }, itemCount: _search_data.length))
        ],
      ),
    );
  }
}