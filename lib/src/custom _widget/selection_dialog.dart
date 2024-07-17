import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class OptionItem {
  const OptionItem({required this.label, this.isSelected = false});

  final String label;
  final bool isSelected;
}

class _MultiSelectionState {
  _MultiSelectionState(this.options);

  final List<OptionItem> options;

  List<String> get selectedOptions =>
      options.where((option) => option.isSelected).map((option) => option.label).toList();
}

class _MultiSelectionStateManager extends Cubit<_MultiSelectionState> {
  _MultiSelectionStateManager(super.initialState);

  void toggleSelection(int index) {
    final List<OptionItem> updatedList = List.of(state.options);
    updatedList[index] = OptionItem (
      label: updatedList[index].label,
      isSelected: !updatedList[index].isSelected,
    );
    emit(_MultiSelectionState(updatedList));
  }

  void clear() {
    final List<OptionItem> updatedList = state.options.map((option) {
      return OptionItem(label: option.label, isSelected: false);
    }).toList();
    emit(_MultiSelectionState(updatedList));
  }
}

class MultiSelectionDialog extends StatelessWidget {
  MultiSelectionDialog({
    super.key,
    required this.actionLabel,
    required this.onSelect,
    required options,
    required this.title,
  }) : _stateManager = _MultiSelectionStateManager(_MultiSelectionState(options)) {
    _totalOptions = options.length;
    _optimalHeight = _totalOptions  >= 4 ?  4 * 60.0 : _totalOptions * 60.0;
  }

  final String actionLabel;
  final Function(List<String>) onSelect;
  final _MultiSelectionStateManager _stateManager;
  final String title;

  late final int _totalOptions;
  late final double _optimalHeight;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_MultiSelectionStateManager, _MultiSelectionState>(
        bloc: _stateManager,
        builder: (context, state) => AlertDialog(
            title: Align(alignment: Alignment.center, child: Text(title)),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: _optimalHeight,
              child: ListView.builder(
                  itemCount: _totalOptions,
                  itemBuilder: (context, index) {
                    final option = state.options[index];
                    return CheckboxListTile(
                        title: Text(option.label),
                        value: option.isSelected,
                        onChanged: (value) {
                          _stateManager.toggleSelection(index);
                        });
                  }),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _stateManager.clear();
                  },
                  child: const Text("CLEAR")),
              TextButton(
                  onPressed: () {
                    onSelect(state.selectedOptions);
                    Navigator.of(context).pop();
                  },
                  child: Text(actionLabel))
            ],
            scrollable:  _totalOptions  >= 4 ?  true : false
        ));
  }
}

class _SingleSelectionStateManagement extends Cubit<String> {
  _SingleSelectionStateManagement(super.initialState);

  void toggleSelection(String? selectedOption) => emit(selectedOption ?? state);
}

class SingleSelectionDialog extends StatelessWidget {
  SingleSelectionDialog({
    super.key,
    required this.onSelect,
    required this.options,
    required this.title,
    required this.actionLabel,
    selectedOption,
  }) : _stateManager = _SingleSelectionStateManagement(selectedOption){
    _totalOptions = options.length;
    _optimalHeight = _totalOptions  >= 4 ?  4 * 60.0 : _totalOptions * 60.0;
  }

  final String actionLabel;
  final List<String> options;
  final String title;
  final Function(String selectedOption) onSelect;

  final _SingleSelectionStateManagement _stateManager;

  late final int _totalOptions;
  late final double _optimalHeight;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_SingleSelectionStateManagement, String>(
      bloc: _stateManager,
      builder: (context, state) => AlertDialog(
          title: Align(alignment: Alignment.center, child: Text(title)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: _optimalHeight,
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                final item = options[index];
                return RadioListTile(
                  title: Text(item),
                  value: item,
                  groupValue: state,
                  onChanged: (value) {
                    _stateManager.toggleSelection(value);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onSelect(state);
                Navigator.of(context).pop();
              },
              child: Text(actionLabel),
            ),
          ],
          scrollable:  _totalOptions  >= 4 ?  true : false),
    );
  }
}
