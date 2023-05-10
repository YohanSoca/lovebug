import 'package:flutter/material.dart';
import 'package:lovebug/models/settings_categories.dart';
import 'package:lovebug/presentation/screens/bilges_screen.dart';
import 'package:lovebug/presentation/screens/shore_screen.dart';
import 'package:lovebug/presentation/screens/tanks_screen.dart';
import 'package:lovebug/presentation/screens/thruster_screen.dart';
import 'package:lovebug/utils/utils.dart';
import 'package:lovebug/presentation/screens/pms_screen.dart';
import 'package:lovebug/presentation/screens/ventilation.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final List<SettingCategory> _categories = const [
    SettingCategory(1, "Ventilation", "#FFCCE3"),
    SettingCategory(2, "PMS", "#C5F0B3"),
    SettingCategory(3, "Tanks", "#A9CCE3"),
    SettingCategory(4, "Thruster", "#C5F0B3"),
    SettingCategory(5, "Bilges", "#A9CCE3"),
    SettingCategory(6, "Shore", "#C5F0B3")
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: _categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 2
        ),
        itemBuilder: (context, index) {
          return TileCategory(_categories[index]);
        },
      ),
    );
  }
}

class TileCategory extends StatelessWidget {
  final SettingCategory _category;
  const TileCategory(this._category, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: () {
            _navigateToBooksWithCategory(context, _category);
          },
          child: Container(
              alignment: AlignmentDirectional.center ,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: hexToColor(_category.colorBg)
              ),
              child: Text(
                _category.name,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,)),
        ));
  }

  void _navigateToBooksWithCategory(BuildContext context, SettingCategory category) {
    if(category.name == 'Ventilation') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => VentilationScreen()));
    }
        if(category.name == 'PMS') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PMSScreen()));
    }
      if(category.name == 'Tanks') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TanksScreen()));
    }
      if(category.name == 'Thruster') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ThrusterScreen()));
    }
          if(category.name == 'Bilges') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => BilgesScreen()));
    }
           if(category.name == 'Shore') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ShoreScreen()));
    }
  }
}

