import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poche/constants/app_theme.dart';
import 'package:poche/controllers/category_controller.dart';
import 'package:poche/models/category.dart';
import 'package:poche/screens/category/dialog_add_cateory.dart';
import 'package:poche/util.dart';
import 'package:poche/widgets/empty_view.dart';
import 'package:poche/widgets/menu_widget.dart';

class ScreenCategories extends StatefulWidget {
  const ScreenCategories({super.key});

  @override
  State<ScreenCategories> createState() => _ScreenCategoriesState();
}

class _ScreenCategoriesState extends State<ScreenCategories>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currType = 0;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currType = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        leading: const MenuWidget(),
        title: const Text(
          'Catégories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: FloatingActionButton(
          onPressed: () async {
            showDialog(
                context: context,
                builder: (context) => AddCateoryDialog(
                      type: currType,
                    ));
          },
          tooltip: 'Nouvelle Catégorie',
          child: const Icon(Icons.add),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Container(
                height: 35,
                width: size.width * .8,
                margin: const EdgeInsets.only(top: 25, bottom: 15),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      gradient: LinearGradient(colors: [
                        Colors.white,
                        _tabController.index == 0 ? Colors.green : Colors.red
                      ])),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Revenus'),
                    Tab(text: 'Dépenses'),
                  ],
                ),
              ),
              const Divider(thickness: 1),
              Expanded(
                  child:
                      TabBarView(controller: _tabController, children: const [
                CategoryList(type: CategoryType.income),
                CategoryList(type: CategoryType.expense)
              ]))
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final int type;
  const CategoryList({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    /* return GetBuilder<CategoryController>(builder: (controller) {
      List<Category> categoriesList = controller.getActiveCategories(type);
      return ListView.separated(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          itemCount: categoriesList.length,
          itemBuilder: (context, index) {
            Category currCat = categoriesList[index];
            return Card(
              child: ListTile(
                leading: Util.getCatIcon(type),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
                title: Text(
                  currCat.categoryName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AddCateoryDialog(
                                  type: type, category: currCat));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: AppTheme.darkGray,
                        )),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: const Text(
                                      'Are you sure to delete this Category? ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('No')),
                                      TextButton(
                                          onPressed: () {
                                            CategoryController()
                                                .deleteCategory(currCat);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Yes'))
                                    ],
                                  ));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: AppTheme.darkGray,
                        ))
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox());
    });*/
    return ValueListenableBuilder(
        valueListenable: Hive.box<Category>('categories').listenable(),
        builder: (context, Box<Category> box, index) {
          List<Category> categoriesList =
              box.values.where((element) => element.type == type).toList();
          if (categoriesList.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: const EmptyView(
                icon: Icons.category,
                label: 'Aucune catégorie',
                color: Color.fromARGB(249, 26, 93, 148),
              ),
            );
          }
          return ListView.separated(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                Category currCat = categoriesList[index];
                return ListTile(
                  leading: Util.getCatIcon(type),
                  title: Text(
                    currCat.categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AddCateoryDialog(
                                    type: type, category: currCat));
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: AppTheme.darkGray,
                          )),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: const Text(
                                  'Etes vous sure de vouloir supprimer cette catégorie ? ',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Non',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      CategoryController()
                                          .deleteCategory(currCat);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Oui',
                                        style: TextStyle(color: Colors.black)),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: AppTheme.darkGray,
                          ))
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider());
        });
  }
}
