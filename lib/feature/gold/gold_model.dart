class AltinModel {
  final String alis;
  final String satis;
  final String degisim;
  final String dOran;
  final String dYon;


  AltinModel({
    required this.alis,
    required this.satis,
    required this.degisim,
    required this.dOran,
    required this.dYon,


  });

  factory AltinModel.fromJson(Map<String, dynamic> json) {
    return AltinModel(
      alis: json['alis'],
      satis: json['satis'],
      degisim: json['degisim'],
      dOran: json['d_oran'],
      dYon: json['d_yon']
    );
  }
}