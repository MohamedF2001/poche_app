import 'package:flutter/material.dart';
import 'package:poche/controllers/category_controller.dart';
import 'package:poche/models/category.dart';
import 'package:poche/util.dart';

class AddCateoryDialog extends StatefulWidget {
  const AddCateoryDialog({Key? key, this.category, required this.type})
      : super(key: key);
  final int type;
  final Category? category;

  @override
  State<AddCateoryDialog> createState() => _AddCateoryDialogState();
}

class _AddCateoryDialogState extends State<AddCateoryDialog> {
  final controller = TextEditingController();
  IconData? icon;
  final CategoryController _categoryManager = CategoryController();
  bool isEdit = false;

  String? errorText;
  @override
  void initState() {
    isEdit = widget.category != null;
    if (isEdit) {
      controller.text = widget.category!.categoryName;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '${isEdit ? 'Editer' : 'Nouvelle Categorie ( ${_typeString()}'} )',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(fontWeight: FontWeight.bold),
      elevation: 1,
      content: TextFormField(
        controller: controller,
        onChanged: (name) {
          if (errorText != null) showError(null);
        },
        autofocus: true,
        maxLength: 15,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (name) {
          save();
        },
        decoration: InputDecoration(
            icon: Util.getCatIcon(widget.type),
            hintText: 'Nom de la catégorie',
            counterText: '',
            errorText: errorText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8)),
      ),
      actions: [_cancelButton(context), _okButton(context)],
    );
  }

  _okButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        save();
      },
      child: const Text(
        'OK',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  _cancelButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Retour',style: TextStyle(color: Colors.black),),);
  }

  save() {
    final String catName = controller.text;
    if (catName.isEmpty) {
      showError("Le nom ne peut pas etre vide");
      return;
    }
    if (!isEdit && _categoryManager.isCateoryExist(catName)) {
      showError('Cette catégorie existe déja');
      return;
    }
    Category category = Category(categoryName: catName, type: widget.type);
    if (isEdit) {
      _categoryManager.updateCategory(widget.category!.key, category);
    } else {
      _categoryManager.addCategory(category);
    }
    Navigator.of(context).pop(category);
  }

  showError(String? string) {
    setState(() {
      errorText = string;
    });
  }

  String _typeString() => widget.type == 0 ? 'Revenus' : 'Dépenses';
}
