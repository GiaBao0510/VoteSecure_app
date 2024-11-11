import 'package:flutter/material.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';
import 'package:votesecure/src/domain/repositories/UserRepository.dart';
import 'dart:ui';

class EditProfilePage extends StatefulWidget {
  final ProfileModel user;
  static const routeName = 'profile';

  EditProfilePage({
    super.key,
    required this.user
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState(user: user);
}

class _EditProfilePageState extends State<EditProfilePage> {
  final WidgetlibraryState widgetlibraryState = WidgetlibraryState();
  final UserRepository userRepository = UserRepository();
  final Map<int, String> danTocMap = {
    1: 'Kinh', 2: 'Tày', 3: 'Thái', 4: 'Hoa', 5: 'Khơ-me',
    6: 'Mường', 7: 'Nùng', 8: 'HMông', 9: 'Dao', 10: 'Gia-rai',
    11: 'Ngái', 12: 'Ê-đê', 13: 'Ba na', 14: 'Xơ-Đăng', 15: 'Sán Chay',
    16: 'Cơ-ho', 17: 'Chăm', 18: 'Sán Dìu', 19: 'Hrê', 20: 'Mnông',
    21: 'Ra-glai', 22: 'Xtiêng', 23: 'Bru-Vân Kiều', 24: 'Thổ', 25: 'Giáy',
    26: 'Cơ-tu', 27: 'Gié Triêng', 28: 'Mạ', 29: 'Khơ-mú', 30: 'Co', 31: 'Tà-ôi',
    32: 'Chơ-ro', 33: 'Kháng', 34: 'Xinh-mun', 35: 'Hà Nhì', 36: 'Chu ru',
    37: 'Lào', 38: 'La Chí', 39: 'La Ha', 40: 'Phù Lá', 41: 'La Hủ',
    42: 'Lự', 43: 'Lô Lô', 44: 'Chứt', 45: 'Mảng', 46: 'Pà Thẻn Pà Hư',
    47: 'Co Lao', 48: 'Cống', 49: 'Bố Y', 50: 'Si La', 51: 'Pu Péo', 52: 'Brâu',
    53: 'Ơ Đu', 54: 'Rơ măm',
  };
  final ProfileModel user;
  late String GioiTinh,
              Old_SDT;
  // Biến lưu trữ key của dân tộc được chọn
  int? ID_DanToc;
  String? TenDanToc;
  // Biến lưu trữ ngày tháng năm được chọn
  DateTime? _selectedDate;
  _EditProfilePageState({
    required this.user,
  });

  // Các biến để lưu trữ thông tin người dùng\

  // Biến để kiểm soát chế độ chỉnh sửa
  bool isEditing = false;

  // Các bộ điều khiển cho TextFormField
  late TextEditingController fullNameController;
  late TextEditingController AddressController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  //Hàm hởi tạo
  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: user.HoTen);
    AddressController = TextEditingController(text: user.DiaChi);
    phoneController = TextEditingController(text: user.SDT);
    emailController = TextEditingController(text: user.Email);
    danTocMap.forEach((key,value) {
      if(value == user.TenDanToc){
        ID_DanToc = key;
        TenDanToc = value;
      }
    });
    GioiTinh = user.GioiTinh ?? 'null';
    Old_SDT =  user.SDT ?? 'null';
    _selectedDate = user.NgaySinh;
  }

  //hàm hủy
  @override
  void dispose() {
    super.dispose();
  }

  // Hàm hiển thị DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      //locale: const Locale("vi"), // Sử dụng ngôn ngữ tiếng Việt

    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  //Hàm khoi phục giá trị ban dầu
  void toggleEditing() {
    setState(() {
      if (isEditing) {
        // Nếu hủy chỉnh sửa, khôi phục lại giá trị ban đầu
        fullNameController.text = user.HoTen ?? 'null';
        AddressController.text = user.DiaChi?? 'null';
        phoneController.text = user.SDT?? 'null';
        emailController.text = user.Email?? 'null';
      }
      isEditing = !isEditing;
    });
  }

  //Lưu dữ liệu
  void saveChanges() async{
    ProfileModel userSave = ProfileModel(
      ID_User: user.ID_User,
      ID_Object: 'null',
      Email: emailController.text,
      SDT: phoneController.text,
      GioiTinh: GioiTinh,
      DiaChi: AddressController.text,
      HinhAnh: 'null',
      NgaySinh: _selectedDate,
      TenDanToc: 'null',
      HoTen: fullNameController.text,
    );
    await userRepository.UserUpdateInfo(context, userSave, Old_SDT, ID_DanToc ?? 1);
    setState(() {
      isEditing = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Background gradient
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6B8EFF),
                  Color(0xFF0039CB),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom AppBar
                buildAppBar(),

                // Scrollable content
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    child: Container(
                      color: Colors.grey[100],
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Profile Image Section
                            Transform.translate(
                              offset: Offset(0, -50),
                              child: buildProfileImageSection(),
                            ),

                            // Profile Content
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: buildProfileContent(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'Chỉnh sửa thông tin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isEditing)
            IconButton(
              icon: Icon(Icons.check, color: Colors.white),
              onPressed: saveChanges,
            )
          else
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: toggleEditing,
            ),
        ],
      ),
    );
  }

  Widget buildProfileImageSection() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                margin:  const EdgeInsets.only(top: 60.0),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(user.HinhAnh ?? ''),
                ),
              ),
              if (isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Text(
          user.HoTen ?? '',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildProfileContent() {
    return Column(
      children: [
        buildInfoCard(
          title: 'Thông tin cá nhân',
          children: [
            buildTextField(
              controller: fullNameController,
              label: 'Họ tên',
              icon: Icons.person_outline,
              enabled: isEditing,
            ),
            SizedBox(height: 16),
            buildTextField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              enabled: isEditing,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),

        SizedBox(height: 16),

        buildInfoCard(
          title: 'Thông tin liên hệ',
          children: [
            buildTextField(
              controller: phoneController,
              label: 'Số điện thoại',
              icon: Icons.phone_outlined,
              enabled: isEditing,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            buildTextField(
              controller: AddressController,
              label: 'Địa chỉ',
              icon: Icons.location_on_outlined,
              enabled: isEditing,
            ),
          ],
        ),

        SizedBox(height: 16),

        buildInfoCard(
          title: 'Thông tin bổ sung',
          children: [
            buildDropdownField(
              value: GioiTinh == '1' ? 'Nam' : 'Nữ',
              label: 'Giới tính',
              icon: Icons.person_outline,
              items: ['Nam', 'Nữ', 'Khác'],
              onChanged: isEditing ? (value) => setState(() => GioiTinh = value!) : null,
            ),
            SizedBox(height: 16),
            buildTextField(
              controller: TextEditingController(text: TenDanToc ?? 'Chọn dân tộc'),
              label: 'Dân tộc',
              icon: Icons.people_outline,
              enabled: isEditing,
              readOnly: true,
              onTap: () => _showDanTocPicker(context),
            ),
            SizedBox(height: 16),
            buildTextField(
              controller: TextEditingController(
                text: _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Chọn ngày sinh',
              ),
              label: 'Ngày sinh',
              icon: Icons.calendar_today_outlined,
              enabled: isEditing,
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
          ],
        ),

        if (isEditing) ...[
          SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: toggleEditing,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],

        SizedBox(height: 32),
      ],
    );
  }

  Widget buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade100,
      ),
    );
  }

  Widget buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((label) => DropdownMenuItem(
        value: label,
        child: Text(label),
      ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        filled: true,
        fillColor: onChanged != null ? Colors.white : Colors.grey.shade100,
      ),
    );
  }

  // Keep the original _showDanTocPicker implementation but update its style
  void _showDanTocPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Ethnicity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: danTocMap.length,
                itemBuilder: (context, index) {
                  int key = danTocMap.keys.elementAt(index);
                  return ListTile(
                    title: Text(danTocMap[key]!),
                    trailing: ID_DanToc == key
                        ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                        : null,
                    onTap: () {
                      setState(() {
                        ID_DanToc = key;
                        TenDanToc = danTocMap[key];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}