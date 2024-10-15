import 'package:flutter/material.dart';
import 'package:votesecure/src/core/utils/WidgetLibrary.dart';
import 'package:votesecure/src/data/models/ProfileModel.dart';
import 'package:votesecure/src/domain/repositories/UserRepository.dart';

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
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff7777ee), Color(0xff348ac7)],
              stops: [0, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text('Chỉnh sửa hồ sơ', style: TextStyle(color: Colors.white,fontSize: 25),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isEditing)
            IconButton(
              icon: Icon(Icons.check, color: Colors.white, size: 25,),
              onPressed: saveChanges,
            ),
          if (!isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: toggleEditing,
            ),
        ],
      ),
      body: Stack(children: [
        widgetlibraryState.buildPageBackgroundGradient2Color(context, '0xfff5f5f5', '0xffd6d6d6'),
        buildUserInformationForm(context),
      ],)
    );
  }

  // Xây dựng phần biểu mẫu thông tin cá nhân
  Widget buildUserInformationForm(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.HinhAnh ?? ''),
                  ),
                  if (isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Icon(Icons.camera_alt, color: Colors.black),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Thông tin cá nhân',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: fullNameController,
              decoration: InputDecoration(
                  labelText: 'Họ tên',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              enabled: isEditing,
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: AddressController,
              decoration: InputDecoration(
                labelText: 'Địa chỉ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              enabled: isEditing,
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              enabled: isEditing,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              enabled: isEditing,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: GioiTinh == '1' ? 'Nam': 'Nữ',
              items: ['Nam', 'Nữ', 'Khác']
                  .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
                  .toList(),
              onChanged: isEditing ? (value) => setState(() => GioiTinh = value!) : null,
              decoration: InputDecoration(
                  labelText: 'Giới tính',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              disabledHint: Text(GioiTinh),
            ),
            SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              enabled: isEditing,
              controller: TextEditingController(
                  text: TenDanToc ?? 'Chọn dân tộc'),
              onTap: () => _showDanTocPicker(context),
              decoration: InputDecoration(
                labelText: 'Dân tộc',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              enabled: isEditing,
              readOnly: true,
              controller: TextEditingController(
                text: _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Chọn ngày sinh',
              ),
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelText: 'Ngày sinh',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 25),
            if (isEditing)
              SizedBox(height: 16),
            if (isEditing)
              ElevatedButton(
                onPressed: toggleEditing,
                child: Text('Cancel'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  // Hiển thị modal bottom sheet với danh sách dân tộc
  void _showDanTocPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: danTocMap.length,
          itemBuilder: (context, index) {
            int key = danTocMap.keys.elementAt(index);
            return ListTile(
              title: Text(danTocMap[key]!),
              onTap: () {
                setState(() {
                  ID_DanToc = key;
                  TenDanToc = danTocMap[key];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
