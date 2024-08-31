import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/init/theme/app_theme/app_theme_dark.dart';
import 'gold_model.dart';

class AltinWidget extends StatefulWidget {
  @override
  _AltinWidgetState createState() => _AltinWidgetState();
}

class _AltinWidgetState extends State<AltinWidget> {
  late Map<String, AltinModel> altinData = {};
  bool _isFetchingData = false;

  Future<void> _fetchAltinData() async {
    setState(() {
      _isFetchingData = true;
    });
    final response = await http.get(Uri.parse('https://api.genelpara.com/embed/altin.json'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        altinData['GA'] = AltinModel.fromJson(jsonData['GA']);
        altinData['C'] = AltinModel.fromJson(jsonData['C']);
        altinData['GAG'] = AltinModel.fromJson(jsonData['GAG']);
        altinData['yarim'] = new AltinModel(alis: (double.parse(altinData['C']!.alis)*2).toString(), satis: (double.parse(altinData['C']!.satis)*2).toString(), degisim: altinData['C']!.degisim, dOran: altinData['C']!.dOran, dYon: altinData['C']!.dYon);
        altinData['tam'] = new AltinModel(alis: (double.parse(altinData['C']!.alis)*4).toString(), satis: (double.parse(altinData['C']!.satis)*4).toString(), degisim: altinData['C']!.degisim, dOran: altinData['C']!.dOran, dYon: altinData['C']!.dYon);
        altinData['cum'] = new AltinModel(alis: (double.parse(altinData['GA']!.alis)*6.57).toStringAsFixed(4), satis: (double.parse(altinData['GA']!.satis)*6.59).toStringAsFixed(4), degisim: altinData['GA']!.degisim, dOran: altinData['C']!.dOran, dYon: altinData['C']!.dYon);
        altinData['res'] = new AltinModel(alis: (double.parse(altinData['GA']!.alis)*6.59).toStringAsFixed(4), satis: (double.parse(altinData['GA']!.satis)*6.61).toStringAsFixed(4), degisim: altinData['GA']!.degisim, dOran: altinData['C']!.dOran, dYon: altinData['C']!.dYon);

        _isFetchingData = false;
      });
    } else {
      setState(() {
        _isFetchingData = false;
      });
      throw Exception('Failed to load altin data');
    }
  }

  Future<void> _refreshData() async {
    await _fetchAltinData();
  }

  @override
  void initState() {
    super.initState();
    _fetchAltinData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Altın Fiyatları'),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Expanded(
                child: altinData.isEmpty
                    ? Center(
                  child: _isFetchingData
                      ? CircularProgressIndicator()
                      : Text('No data available'),
                )
                    : ListView.builder(
                  itemCount: altinData.length,
                  itemBuilder: (context, index) {
                    final entry = altinData.entries.elementAt(index);
                    final model = entry.value;
                    String altinName = _getAltinName(entry.key);
                    return ListTile(
                      title: Text(altinName,style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Değişim Oranı %: ${model.degisim}',
                            style: TextStyle(
                              color: model.degisim.startsWith('-') ? Colors.red : Colors.green,fontSize: 14
                            ),
                          ),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Alış: ${model.alis}',
                            style: TextStyle(color: Colors.green, fontSize: 15),
                          ),
                          Text(
                            'Satış: ${model.satis}',
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      theme: AppThemeDark.instance!.appTheme,
    );
  }

  String _getAltinName(String altinCode) {
    switch (altinCode) {
      case 'GA':
        return 'Gram Altın';
      case 'C':
        return 'Çeyrek Altın';
      case 'GAG':
        return 'Gümüş';
      case 'yarim':
        return 'Yarım Altın';
      case 'tam':
        return 'Tam Altın';
      case 'cum':
        return 'Cumhuriyet Altını';
      case 'res':
        return 'Reşat Altını';
      default:
        return 'Bilinmeyen Altın Türü';
    }
  }
}
