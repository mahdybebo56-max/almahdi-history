import 'package:flutter/material.dart';

void main() => runApp(const AlmahdiApp());

const gold = Color(0xFFD6B45B);
const ink = Color(0xFF101010);
const panel = Color(0xFF1D1D1D);

class AlmahdiApp extends StatelessWidget {
  const AlmahdiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'المهدي في التاريخ',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ink,
        colorScheme: const ColorScheme.dark(
          primary: gold,
          secondary: gold,
          surface: panel,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ink,
          foregroundColor: gold,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: panel,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: gold),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF555044)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: gold,
            foregroundColor: ink,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const RolePage(),
    );
  }
}

class Group {
  Group({required this.name, required this.grade, required this.code});
  final String name;
  final String grade;
  final String code;
  final List<String> students = [];
}

class AppState extends ChangeNotifier {
  String role = 'teacher';
  final List<Group> groups = [
    Group(name: 'الثاني بكالوريا - تاريخ', grade: 'الثاني بكالوريا', code: 'MAHDI2026'),
  ];
  final List<String> joinedCodes = [];

  void setRole(String value) {
    role = value;
    notifyListeners();
  }

  void addGroup(String name, String grade, String code) {
    groups.add(Group(name: name, grade: grade, code: code));
    notifyListeners();
  }

  bool joinGroup(String code) {
    final normalized = code.trim().toUpperCase();
    final found = groups.where((g) => g.code.toUpperCase() == normalized).toList();
    if (found.isEmpty || joinedCodes.contains(normalized)) return false;
    joinedCodes.add(normalized);
    found.first.students.add('طالب تجريبي');
    notifyListeners();
    return true;
  }
}

final appState = AppState();

class RolePage extends StatelessWidget {
  const RolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_balance, color: gold, size: 76),
                const SizedBox(height: 18),
                const Text('المهدي في التاريخ',
                    style: TextStyle(color: gold, fontSize: 29, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('منصة التعليم الذكي', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 42),
                const Text('اختر طريقة الدخول', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () {
                    appState.setRole('teacher');
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
                  },
                  icon: const Icon(Icons.school),
                  label: const Text('الدخول كمدرس'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: gold,
                    side: const BorderSide(color: gold),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () {
                    appState.setRole('student');
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('الدخول كطالب'),
                ),
                const SizedBox(height: 24),
                const Text('نسخة تجريبية: لا يوجد تسجيل دخول حقيقي بعد',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final isTeacher = appState.role == 'teacher';
    final titles = isTeacher
        ? ['الرئيسية', 'المجموعات', 'الامتحانات', 'المساعد الذكي']
        : ['الرئيسية', 'مجموعاتي', 'الامتحانات', 'المذكرات'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('المهدي في التاريخ', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'تغيير نوع الحساب',
            onPressed: () => Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (_) => const RolePage()), (_) => false),
            icon: const Icon(Icons.swap_horiz),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: selected,
          children: [
            DashboardPage(isTeacher: isTeacher),
            isTeacher ? const GroupsPage() : const MyGroupsPage(),
            const PlaceholderPage(title: 'الامتحانات', subtitle: 'سيتم إضافة إنشاء الامتحانات وحلها في المرحلة التالية.', icon: Icons.quiz),
            isTeacher
                ? const PlaceholderPage(title: 'المساعد الذكي', subtitle: 'سيتم ربط الذكاء الاصطناعي لإعداد أسئلة ومراجعات التاريخ.', icon: Icons.auto_awesome)
                : const PlaceholderPage(title: 'المذكرات', subtitle: 'ستظهر هنا المذكرات والملفات التي يشاركها المدرس.', icon: Icons.menu_book),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: panel,
        indicatorColor: gold.withOpacity(.18),
        selectedIndex: selected,
        onDestinationSelected: (v) => setState(() => selected = v),
        destinations: [
          for (var i = 0; i < titles.length; i++)
            NavigationDestination(
              icon: Icon([Icons.home_outlined, Icons.groups_outlined, Icons.assignment_outlined, Icons.auto_awesome_outlined][i]),
              selectedIcon: Icon([Icons.home, Icons.groups, Icons.assignment, Icons.auto_awesome][i], color: gold),
              label: titles[i],
            ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.isTeacher});
  final bool isTeacher;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(colors: [Color(0xFF302719), Color(0xFF171717)]),
            border: Border.all(color: gold.withOpacity(.55)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('أهلاً بك في', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 5),
            const Text('المهدي في التاريخ', style: TextStyle(color: gold, fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(isTeacher ? 'إدارة مجموعاتك وطلابك من مكان واحد.' : 'تابع دروسك وامتحاناتك ونتائجك من مكان واحد.'),
          ]),
        ),
        const SizedBox(height: 20),
        Text(isTeacher ? 'أدوات المدرس' : 'مساحة الطالب',
            style: const TextStyle(color: gold, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.25,
          children: (isTeacher
              ? [
                  [Icons.groups, 'إدارة الطلاب'],
                  [Icons.event_available, 'الحضور والغياب'],
                  [Icons.account_balance_wallet, 'الاشتراكات'],
                  [Icons.quiz, 'الامتحانات'],
                  [Icons.bar_chart, 'النتائج والتقارير'],
                  [Icons.auto_awesome, 'المساعد الذكي'],
                ]
              : [
                  [Icons.play_circle_outline, 'المحاضرات'],
                  [Icons.quiz, 'الامتحانات'],
                  [Icons.emoji_events, 'درجاتي'],
                  [Icons.menu_book, 'المذكرات'],
                  [Icons.notifications, 'الإعلانات'],
                  [Icons.auto_awesome, 'المساعد الذكي'],
                ]).map((item) => Container(
                decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF494133))),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(item[0] as IconData, color: gold, size: 30),
                  const SizedBox(height: 8),
                  Text(item[1] as String, textAlign: TextAlign.center),
                ]),
              )).toList(),
        ),
      ],
    );
  }
}

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});
  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  Future<void> createGroup() async {
    final name = TextEditingController();
    final grade = TextEditingController(text: 'الثاني بكالوريا');
    final code = TextEditingController(text: 'MAHDI${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}');
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: panel,
        title: const Text('إنشاء مجموعة جديدة', style: TextStyle(color: gold)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم المجموعة')),
          const SizedBox(height: 10),
          TextField(controller: grade, decoration: const InputDecoration(labelText: 'الصف الدراسي')),
          const SizedBox(height: 10),
          TextField(controller: code, decoration: const InputDecoration(labelText: 'كود الانضمام')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('حفظ')),
        ],
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty && code.text.trim().isNotEmpty) {
      appState.addGroup(name.text.trim(), grade.text.trim(), code.text.trim());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      Row(children: [
        const Expanded(child: Text('مجموعاتي', style: TextStyle(color: gold, fontSize: 21, fontWeight: FontWeight.bold))),
        IconButton(onPressed: createGroup, icon: const Icon(Icons.add_circle, color: gold, size: 30)),
      ]),
      for (final group in appState.groups)
        Card(
          color: panel,
          child: ListTile(
            leading: const Icon(Icons.groups, color: gold),
            title: Text(group.name),
            subtitle: Text('الصف: ${group.grade}\\nكود الانضمام: ${group.code}\\nعدد الطلاب: ${group.students.length}'),
            isThreeLine: true,
            trailing: IconButton(
              tooltip: 'نسخ الكود',
              icon: const Icon(Icons.copy, color: gold),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ميزة نسخ الكود ستضاف عند ربط الحافظة.')));
              },
            ),
          ),
        ),
    ]);
  }
}

class MyGroupsPage extends StatefulWidget {
  const MyGroupsPage({super.key});
  @override
  State<MyGroupsPage> createState() => _MyGroupsPageState();
}

class _MyGroupsPageState extends State<MyGroupsPage> {
  final code = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final groups = appState.groups.where((g) => appState.joinedCodes.contains(g.code.toUpperCase())).toList();
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('الانضمام إلى مجموعة', style: TextStyle(color: gold, fontSize: 21, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextField(controller: code, textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(labelText: 'أدخل كود المجموعة', hintText: 'مثال: MAHDI2026')),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          final success = appState.joinGroup(code.text);
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(success ? 'تم الانضمام للمجموعة في النسخة التجريبية.' : 'الكود غير صحيح أو سبق الانضمام إليه.'),
          ));
        },
        child: const Text('انضمام'),
      ),
      const SizedBox(height: 24),
      const Text('مجموعاتي', style: TextStyle(color: gold, fontSize: 18, fontWeight: FontWeight.bold)),
      if (groups.isEmpty) const Padding(
        padding: EdgeInsets.all(20),
        child: Text('لم تنضم إلى أي مجموعة بعد.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
      ),
      for (final g in groups)
        Card(color: panel, child: ListTile(
          leading: const Icon(Icons.menu_book, color: gold),
          title: Text(g.name),
          subtitle: Text(g.grade),
        )),
    ]);
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title, required this.subtitle, required this.icon});
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: gold, size: 58),
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(color: gold, fontSize: 23, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, height: 1.6)),
      ]),
    ),
  );
}
