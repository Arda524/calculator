// ignore_for_file: use_super_parameters, prefer_interpolation_to_compose_strings, avoid_print

import 'package:calculator/logic/calculator_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  final List<HistoryEntry> history;
  final Function(List<HistoryEntry>)? onHistoryChanged;
  final Function(HistoryEntry)? onRecalculate;

  const History({Key? key, required this.history, this.onHistoryChanged, this.onRecalculate}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool isDeleting = false;
  late List<bool> selectedItems;
  int selectedCount = 0;
  late List<HistoryEntry> currentHistory;

  @override
  void initState() {
    super.initState();
    currentHistory = List.from(widget.history);
    selectedItems = List<bool>.filled(currentHistory.length, false);
  }

  @override
  void didUpdateWidget(History oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.history.length != oldWidget.history.length) {
      selectedItems = List<bool>.filled(widget.history.length, false);
      selectedCount = 0;
      if (widget.history.isEmpty) {
        isDeleting = false;
      }
    }
  }

  void toggleSelectAll() {
    final allSelected = selectedCount == currentHistory.length;
    setState(() {
      for (int i = 0; i < selectedItems.length; i++) {
        selectedItems[i] = !allSelected;
      }
      selectedCount = allSelected ? 0 : currentHistory.length;
    });
  }

  void showDeleteConfirmation() {
    if (selectedCount == 0) return;
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Deleting items',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Delete $selectedCount ${selectedCount == 1 ? 'item' : 'items'} now?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await Future.delayed(const Duration(milliseconds: 100));
                      deleteSelectedItems();
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void copySelectedItem() async {
    if (selectedCount == 0) return;
    
    String selectedCalculations = '';
    for (int i = 0; i < currentHistory.length; i++) {
      if (selectedItems[i]) {
        selectedCalculations += currentHistory[i].calculation + '\n';
      }
    }
    
    if (selectedCalculations.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: selectedCalculations.trim()));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Text copied',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : null,
              ),
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : null,
            margin: const EdgeInsets.only(
              bottom: 80,
              left: 20,
              right: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      
      setState(() {
        isDeleting = false;
        selectedItems = List<bool>.filled(currentHistory.length, false);
        selectedCount = 0;
      });
    }
  }

  void deleteSelectedItems() {
    if (selectedCount == 0) return;
    
    List<HistoryEntry> updatedHistory = [];
    for (int i = 0; i < currentHistory.length; i++) {
      if (!selectedItems[i]) {
        updatedHistory.add(currentHistory[i]);
      }
    }
    
    setState(() {
      currentHistory = updatedHistory;
      isDeleting = false;
      selectedItems = List<bool>.filled(updatedHistory.length, false);
      selectedCount = 0;
    });
    
    if (widget.onHistoryChanged != null) {
      widget.onHistoryChanged!(updatedHistory);
    }
  }

  void recalculateSelectedItems() {
    if (selectedCount == 1) {
      final selectedEntryIndex = selectedItems.indexOf(true);
      if (selectedEntryIndex != -1) {
        final selectedEntry = currentHistory[selectedEntryIndex];
        if (widget.onRecalculate != null) {
          widget.onRecalculate!(selectedEntry);
        }
        Navigator.of(context).pop(); // Close the history screen
      }
    }
    setState(() {
      isDeleting = false;
      selectedItems = List<bool>.filled(currentHistory.length, false);
      selectedCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: isDeleting
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isDeleting = false;
                    selectedItems =
                        List<bool>.filled(currentHistory.length, false);
                    selectedCount = 0;
                  });
                },
                icon: const Icon(Icons.close),
              )
            : null,
        title: Text(
          isDeleting ? "Selected $selectedCount items" : "History",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (isDeleting)
            TextButton(
                onPressed: toggleSelectAll,
                child: const Icon(
                  Icons.task_alt_outlined,
                  size: 26,
                ))
          else if (currentHistory.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  isDeleting = true;
                });
              },
              icon: const Icon(Icons.delete_outline),
              iconSize: 26,
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: currentHistory.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'No items here yet',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: currentHistory.length,
                    itemBuilder: (context, index) {
                      final entry = currentHistory[index];
                      final previousEntry = index > 0 ? currentHistory[index - 1] : null;
                      final bool showDateHeader = previousEntry == null ||
                          !_isSameDay(entry.timestamp, previousEntry.timestamp);

                      return Column(
                        children: [
                          if (showDateHeader)
                            Column(
                              children: [
                                if (previousEntry != null)
                                  const Divider(thickness: 1, height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      DateFormat('dd/MM/yyyy').format(entry.timestamp),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ListTile(
                            title: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                entry.calculation,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            trailing: isDeleting
                                ? Checkbox(
                                    shape: const CircleBorder(),
                                    value: index < selectedItems.length ? selectedItems[index] : false,
                                    onChanged: (value) {
                                      if (index < selectedItems.length) {
                                        setState(() {
                                          selectedItems[index] = value!;
                                          if (value) {
                                            selectedCount++;
                                          } else {
                                            selectedCount--;
                                          }
                                        });
                                      }
                                    },
                                  )
                                : null,
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: isDeleting
          ? BottomAppBar(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: selectedCount == 1 ? recalculateSelectedItems : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.replay_outlined,
                          color: selectedCount == 1
                              ? (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              : Colors.grey,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Recalculate',
                          style: TextStyle(
                            fontSize: 10,
                            color: selectedCount == 1
                                ? (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: selectedCount > 0 ? copySelectedItem : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.copy_all_outlined,
                          color: selectedCount > 0
                              ? (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              : Colors.grey,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Copy',
                          style: TextStyle(
                            fontSize: 10,
                            color: selectedCount > 0
                                ? (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: selectedCount > 0 ? showDeleteConfirmation : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: selectedCount > 0
                              ? (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              : Colors.grey,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 10,
                            color: selectedCount > 0
                                ? (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
