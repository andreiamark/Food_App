
import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = './settings';

  final Function saveFilters;
  final Map<String, bool> currentFilters;

  FiltersScreen(this.currentFilters, this.saveFilters);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _glutenFree = false;
  bool _vegetarian = false;
  bool _vegan = false;
  bool _lactosefree = false;

  @override
  initState() {
    _glutenFree = widget.currentFilters['gluten'] ?? false;
    _lactosefree = widget.currentFilters['lactose-free'] ?? false;
    _vegan = widget.currentFilters['vegan'] ?? false;
    _vegetarian = widget.currentFilters['vegetarian'] ?? false;

    super.initState();
  }

  Widget _buildSwitchListTile(
      String title,
      String description,
      bool currentValue,
      final  updateValue,
      ) {
    return SwitchListTile(
      title: Text(title),
      value: currentValue,
      subtitle: Text(
          description,
      ),
      onChanged: updateValue,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Filters'),
        actions:<Widget>[
          IconButton(
              icon:Icon(Icons.save),
              onPressed: () {
                final selectedFilters = {
                'gluten': false,
                'lactose': false,
                'vegan': false,
                'vegetarian': false,
                };
                widget.saveFilters(selectedFilters);
              })
        ],
      ),
      drawer: MainDrawer(),
      body: Column(children: <Widget>[
        Container(padding: EdgeInsets.all(20),
          child: Text(
            'Adjust your meal selection.',
            style: Theme
                .of(context)
                .textTheme
                .subtitle1,
          ),
        ),
        Expanded(child: ListView(
          children: <Widget>[
            _buildSwitchListTile('Gluten-free',
              'Only include gluten-free',
              _glutenFree, (newValue) {
                setState(
                      () {
                  _glutenFree = newValue;
                },
                );
              },
            ),
            _buildSwitchListTile(
              'Vegetarian',
              'Only include vegetarian meals',
              _vegetarian,
              (newValue) {
                setState(
                      () {
                    _vegetarian = newValue;
                  },
                );
              },
            ),
            _buildSwitchListTile('lactose-free',
              'Only include lactose-free',
              _lactosefree, (newValue) {
                setState(
                      () {
                    _lactosefree = newValue;
                  },
                );
              },
            ),
            _buildSwitchListTile(
              'Vegan',
              'Only include vegan meals',
              _vegan,
                  (newValue) {
                setState(
                      () {
                    _vegan = newValue;
                  },
                );
              },
            ),
          ],
        ),
        ),
      ],
      ),
    );
  }
}
