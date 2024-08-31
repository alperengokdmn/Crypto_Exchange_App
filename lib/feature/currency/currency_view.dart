import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';
import '../../core/init/theme/app_theme/app_theme_dark.dart';

class Currency {
  final String name;
  final String code;
  final double buyingRate;
  final double sellingRate;
  final Widget flagWidget; // Bayrak widget'ını temsil eden bir özellik

  Currency({required this.name, required this.code, required this.buyingRate, required this.sellingRate, required this.flagWidget});
}

class CurrencyView extends StatefulWidget {
  @override
  _CurrencyViewState createState() => _CurrencyViewState();
}

class _CurrencyViewState extends State<CurrencyView> {
  List<Currency> currencies = [];
  List<Currency> filteredCurrencies = [];
  bool _isFetchingData = false;
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  double height=40;
  double width=70;
  @override
  void initState() {
    super.initState();
    fetchCurrencyData();
  }

  Future<void> fetchCurrencyData() async {
    setState(() {
      _isFetchingData = true;
    });

    final response = await http.get(Uri.parse('https://www.tcmb.gov.tr/kurlar/today.xml'),
        headers: {'Accept-Charset': 'utf-8'});
    final document = xml.XmlDocument.parse(utf8.decode(response.bodyBytes));
    final elements = document.findAllElements('Currency');

    List<Currency> tempCurrencies = [];

    elements.forEach((node) {
      final name = node.findElements('Isim').single.text.trim();
      final code = node.getAttribute('Kod')!;

      double buyingRate = 0.0;
      double sellingRate = 0.0;

      try {
        buyingRate = double.parse(node.findElements('ForexBuying').single.text);
        sellingRate = double.parse(node.findElements('ForexSelling').single.text);
      } catch (e) {
        print('Error parsing exchange rates: $e');
      }

      Widget flagWidget;
      if (code == 'USD') {
        flagWidget = Flag.fromCode(
          FlagsCode.US,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'AUD') {
        flagWidget = Flag.fromCode(
          FlagsCode.AU,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'DKK') {
        flagWidget = Flag.fromCode(
          FlagsCode.DK,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'EUR') {
        flagWidget = Flag.fromCode(
          FlagsCode.EU,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      }
      else if (code == 'GBP') {
        flagWidget = Flag.fromCode(
          FlagsCode.GB,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'CHF') {
        flagWidget = Flag.fromCode(
          FlagsCode.CH,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'SEK') {
        flagWidget = Flag.fromCode(
          FlagsCode.SE,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'CAD') {
        flagWidget = Flag.fromCode(
          FlagsCode.CA,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'KWD') {
        flagWidget = Flag.fromCode(
          FlagsCode.KW,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'NOK') {
        flagWidget = Flag.fromCode(
          FlagsCode.NO,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'SAR') {
        flagWidget = Flag.fromCode(
          FlagsCode.SA,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'JPY') {
        flagWidget = Flag.fromCode(
          FlagsCode.JP,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'BGN') {
        flagWidget = Flag.fromCode(
          FlagsCode.BG,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'RON') {
        flagWidget = Flag.fromCode(
          FlagsCode.RO,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'RUB') {
        flagWidget = Flag.fromCode(
          FlagsCode.RU,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'IRR') {
        flagWidget = Flag.fromCode(
          FlagsCode.IR,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'CNY') {
        flagWidget = Flag.fromCode(
          FlagsCode.CN,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'PKR') {
        flagWidget = Flag.fromCode(
          FlagsCode.PK,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'QAR') {
        flagWidget = Flag.fromCode(
          FlagsCode.QA,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'KRW') {
        flagWidget = Flag.fromCode(
          FlagsCode.KR,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'AZN') {
        flagWidget = Flag.fromCode(
          FlagsCode.AZ,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else if (code == 'AED') {
        flagWidget = Flag.fromCode(
          FlagsCode.AE,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      } else {
        flagWidget = Icon(Icons.flag);
      }

      final currency = Currency(
          name: name, code: code, buyingRate: buyingRate, sellingRate: sellingRate, flagWidget: flagWidget);
      tempCurrencies.add(currency);
    });

    setState(() {
      currencies = tempCurrencies;
      filteredCurrencies = currencies;
      _isFetchingData = false;
    });
  }

  void _filterCurrencies(String searchText) {
    setState(() {
      filteredCurrencies = currencies
          .where((currency) => currency.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Future<void> _refreshData() async {
    await fetchCurrencyData();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _filterCurrencies('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
                onChanged: _filterCurrencies,
              ),
            ),
          )
              : Text(
            'MB Döviz Kurları',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            _isSearching
                ? IconButton(
              icon: Icon(Icons.clear, color: Colors.white),
              onPressed: _stopSearch,
            )
                : IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: _startSearch,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: currencies.isEmpty
              ? Center(
            child: _isFetchingData
                ? CircularProgressIndicator()
                : Text('No data available'),
          )
              : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCurrencies.length,
                  itemBuilder: (context, index) {
                    final currency = filteredCurrencies[index];
                    return ListTile(
                      leading: currency.flagWidget, // Bayrak widget'ını kullanın
                      title: Text(currency.name, style: TextStyle(color: Colors.white)),
                      subtitle: Text(currency.code, style: TextStyle(color: Colors.white)),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Alış: ${currency.buyingRate.toStringAsFixed(4)}',
                            style: TextStyle(color: Colors.green, fontSize: 15),
                          ),
                          Text(
                            'Satış: ${currency.sellingRate.toStringAsFixed(4)}',
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
}
