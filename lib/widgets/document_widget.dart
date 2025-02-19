import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phytosvit/database/doc_type_dao.dart';
import 'package:phytosvit/database/document_dao.dart';
import 'package:phytosvit/database/subdivision_dao.dart';
import 'package:phytosvit/database/unit_dao.dart';
import 'package:phytosvit/models/doc_type.dart';
import 'package:phytosvit/models/subdivision.dart';
import 'package:phytosvit/screens/barcode_scanner_screen.dart';
import 'package:phytosvit/style/colors.dart';
import 'package:phytosvit/widgets/date_picker_widget.dart';

import '../generated/l10n.dart';
import '../models/document.dart';
import '../models/scan_item.dart';

class DocumentWidget extends StatefulWidget {
  final List<Map<String, int>> barcodes;

  const DocumentWidget({super.key, List<Map<String, int>>? barcodes})
      : barcodes = barcodes ?? const [];

  @override
  _DocumentWidgetState createState() => _DocumentWidgetState();
}

class _DocumentWidgetState extends State<DocumentWidget> {
  SubdivisionDao subdivisionDao = SubdivisionDao();
  DocTypeDao docTypeDao = DocTypeDao();
  DateTime? selectedDate;
  String selectedDivision = '';
  String selectedDocumentType = '';
  String selectedUnit = 'шт';

  List<Subdivision> divisions = List<Subdivision>.empty(growable: true);
  List<DocType> docTypes = List<DocType>.empty(growable: true);
  late List<Map<String, int>> barcodes =
      List<Map<String, int>>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    divisions = await subdivisionDao.getAllSubdivisions();
    docTypes = await docTypeDao.getDocTypes();
    barcodes = List.from(widget.barcodes);
    selectedDate = DateTime.now();
    selectedDivision = divisions[0].subdivisionName;
    selectedDocumentType = docTypes[0].typeName;
    // Обновляем состояние после загрузки данных
    setState(() {});
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}.'
        '${dateTime.month.toString().padLeft(2, '0')}.'
        '${dateTime.year}  '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _addOrUpdateBarcode(String barcode) {
    // Проверка на наличие штрихкода в списке
    final existingBarcode = barcodes.firstWhere(
      (item) => item.keys.first == barcode,
      orElse: () => {},
    );

    setState(() {
      if (existingBarcode.isEmpty) {
        // Если штрихкода нет, добавляем его
        barcodes.add({barcode: 1});
      } else {
        // Если штрихкод уже существует, увеличиваем количество
        existingBarcode[barcode] = existingBarcode[barcode]! + 1;
      }
    });
  }

  void _saveDocument() async {
    if (selectedDate == null || barcodes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заповніть всі необхідні поля')),
      );
      return;
    }

    final List<ScanItem> items = [];
    final unitDao = UnitDao();
    final documentDao = DocumentDao();

    try {
      // Асинхронно загружаем все единицы измерения и кэшируем их
      final allUnits = await unitDao.getAllUnits();

      for (var barcodeMap in barcodes) {
        final barcode = barcodeMap.keys.first;
        final count = barcodeMap.values.first;

        // Находим единицу измерения по имени
        final unit = allUnits.firstWhere(
          (unit) => unit.unitName == selectedUnit,
          orElse: () => throw Exception(
              'Одиниця вимірювання "$selectedUnit" не знайдена.'),
        );

        items.add(ScanItem(text: barcode, count: count, unitId: unit.id ?? 0));
      }

      // Формируем данные документа
      final documentData = {
        'id': 0,
        'date': selectedDate!.toIso8601String(),
        'type_id': docTypes
            .firstWhere((type) => type.typeName == selectedDocumentType)
            .id,
        'subdivision_id': divisions
            .firstWhere(
                (division) => division.subdivisionName == selectedDivision)
            .id,
        'items': items,
      };

      // Асинхронно сохраняем документ и связанные элементы
      await documentDao.insertDocumentWithItems(Document.fromMap(documentData));

      // Показываем сообщение об успешном сохранении
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Документ успішно збережено')),
        );

        Navigator.of(context).pop(true);
        // Navigator.of(context).pop();
      }
    } catch (error, stackTrace) {
      // Логируем ошибку и стек-трейс в консоль
      debugPrint('Помилка збереження документа: $error');
      debugPrint('StackTrace: $stackTrace');

      // Обработка ошибок с уведомлением
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка збереження документа: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).document_title,
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.5),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/svg/ico_save_doc.svg'),
            onPressed: () {
              _saveDocument();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDateAndTypeSelection(),
            const SizedBox(height: 16),
            buildDivisionSelection(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: barcodes.length,
                itemBuilder: (context, index) {
                  final barcode = barcodes[index].keys.first;
                  final quantity = barcodes[index].values.first;
                  return buildBarcodeTile(barcode, quantity);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QRScannerScreen(),
                  settings:
                      const RouteSettings(arguments: 'fromDocumentWidget'),
                ),
              );

              if (result != null && result is String) {
                _addOrUpdateBarcode(result);
              }
            },
            backgroundColor: AppColors.greenTeeColor,
            child: const Icon(Icons.qr_code_scanner,
                color: Colors.white, size: 36),
          ),
        ),
      ),
    );
  }

  Widget buildBarcodeTile(String barcode, int quantity) {
    return GestureDetector(
      onTap: () => _openEditDialog(barcode, quantity),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  barcode,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Text(
                  '$quantity $selectedUnit',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openEditDialog(String barcode, int currentQuantity) async {
    TextEditingController quantityController =
        TextEditingController(text: currentQuantity.toString());

    // Получаем единицы измерения из UserDao
    final unitDao = UnitDao();
    final unitsData = await unitDao.getAllUnits();

    // Преобразуем список карт в список строк (единиц измерения)
    final units = unitsData.map((unit) => unit.unitName).toList();

    selectedUnit = units.firstWhere(
      (unit) => unit == 'шт',
      orElse: () => '',
    );

    // Если список пуст, добавим 'шт.' как стандартное значение
    if (units.isEmpty) {
      units.add('шт');
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Редагування: $barcode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Кількість',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedUnit,
                items: units.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Одиниця вимірювання',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedUnit = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () {
                final newQuantity = int.tryParse(quantityController.text);
                if (newQuantity != null && newQuantity > 0) {
                  setState(() {
                    final existingBarcode = barcodes.firstWhere(
                      (item) => item.keys.first == barcode,
                      orElse: () => {},
                    );
                    if (existingBarcode.isNotEmpty) {
                      barcodes.remove(existingBarcode);
                      barcodes.add({barcode: newQuantity});
                    }
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Зберегти'),
            ),
          ],
        );
      },
    );
  }

  Widget buildDateAndTypeSelection() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Дата:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDialog<DateTime>(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        child: CustomDatePicker(
                          initialDate: selectedDate ?? DateTime.now(),
                          onDateSelected: (date) {
                            setState(() {
                              selectedDate = date;
                            });
                          },
                        ),
                      );
                    },
                  );

                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    selectedDate != null
                        ? _formatDateTime(selectedDate!)
                        : 'Виберіть дату',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Тип документа:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedDocumentType,
                items: docTypes.map((docType) {
                  return DropdownMenuItem<String>(
                    value: docType.typeName,
                    child: Text(docType.typeName,
                        overflow: TextOverflow.ellipsis, maxLines: 1),
                  );
                }).toList(),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                ),
                onChanged: (value) {
                  setState(() {
                    selectedDocumentType = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDivisionSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Підрозділ:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedDivision,
          items: divisions.map((division) {
            return DropdownMenuItem(
              value: division.subdivisionName,
              child: Text(division.subdivisionName),
            );
          }).toList(),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (value) {
            setState(() {
              selectedDivision = value!;
            });
          },
        ),
      ],
    );
  }
}
