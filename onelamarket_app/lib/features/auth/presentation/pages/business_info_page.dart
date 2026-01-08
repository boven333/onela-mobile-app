import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onelamarket_app/core/constants/app_colors.dart';

import '../../../../core/constants/app_sizes.dart';
import '../controllers/signup_flow_controller.dart';
import '../controllers/signup_flow_state.dart';

class BusinessInfoPage extends ConsumerStatefulWidget {
  const BusinessInfoPage({super.key});

  @override
  ConsumerState<BusinessInfoPage> createState() => _BusinessInfoPageState();
}

class _BusinessInfoPageState extends ConsumerState<BusinessInfoPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  final _restaurant = TextEditingController();
  final _contact = TextEditingController();
  final _phone = TextEditingController();

  // company
  final _companyName = TextEditingController();
  final _juristicId = TextEditingController();
  final _companyAddress = TextEditingController();

  // individual
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _nationalId = TextEditingController();
  final _idCardAddress = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _restaurant.dispose();
    _contact.dispose();
    _phone.dispose();
    _companyName.dispose();
    _juristicId.dispose();
    _companyAddress.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _nationalId.dispose();
    _idCardAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.read(signupFlowProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลร้านอาหารและการติดต่อ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tab,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            onTap: (i) {
              flow.setBusinessType(i == 0 ? BusinessType.company : BusinessType.individual);
            },
            tabs: const [
              Tab(text: 'บริษัท/นิติบุคคล'),
              Tab(text: 'บุคคลธรรมดา'),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.p20),
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tab,
                  children: [
                    _CompanyForm(
                      restaurant: _restaurant,
                      contact: _contact,
                      phone: _phone,
                      companyName: _companyName,
                      juristicId: _juristicId,
                      companyAddress: _companyAddress,
                    ),
                    _IndividualForm(
                      restaurant: _restaurant,
                      contact: _contact,
                      phone: _phone,
                      firstName: _firstName,
                      lastName: _lastName,
                      nationalId: _nationalId,
                      idCardAddress: _idCardAddress,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: AppSizes.buttonH,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  ),
                  onPressed: () {
                    final isCompany = _tab.index == 0;

                    if (isCompany) {
                      flow.setBusinessInfo(
                        restaurantName: _restaurant.text.trim(),
                        contactName: _contact.text.trim(),
                        phone: _phone.text.trim(),
                        companyName: _companyName.text.trim(),
                        juristicId: _juristicId.text.trim(),
                        companyAddress: _companyAddress.text.trim(),
                      );
                    } else {
                      flow.setBusinessInfo(
                        restaurantName: _restaurant.text.trim(),
                        contactName: _contact.text.trim(),
                        phone: _phone.text.trim(),
                        firstName: _firstName.text.trim(),
                        lastName: _lastName.text.trim(),
                        nationalId: _nationalId.text.trim(),
                        idCardAddress: _idCardAddress.text.trim(),
                      );
                    }

                    Navigator.pushNamed(context, flow.nextAfterBusinessInfo());
                  },
                  child: const Text(
                    'ดำเนินการต่อ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanyForm extends StatelessWidget {
  const _CompanyForm({
    required this.restaurant,
    required this.contact,
    required this.phone,
    required this.companyName,
    required this.juristicId,
    required this.companyAddress,
  });

  final TextEditingController restaurant;
  final TextEditingController contact;
  final TextEditingController phone;
  final TextEditingController companyName;
  final TextEditingController juristicId;
  final TextEditingController companyAddress;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextFormField(
          controller: restaurant,
          decoration: const InputDecoration(hintText: 'ชื่อร้านอาหาร'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: contact,
          decoration: const InputDecoration(hintText: 'ชื่อผู้ติดต่อ'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: phone,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: 'โทรศัพท์'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: companyName,
          decoration: const InputDecoration(hintText: 'ชื่อบริษัท'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: juristicId,
          decoration: const InputDecoration(hintText: 'เลขทะเบียนนิติบุคคล'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: companyAddress,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'ที่อยู่ตามหนังสือรับรองบริษัท'),
        ),
      ],
    );
  }
}

class _IndividualForm extends StatelessWidget {
  const _IndividualForm({
    required this.restaurant,
    required this.contact,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.nationalId,
    required this.idCardAddress,
  });

  final TextEditingController restaurant;
  final TextEditingController contact;
  final TextEditingController phone;
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController nationalId;
  final TextEditingController idCardAddress;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextFormField(
          controller: restaurant,
          decoration: const InputDecoration(hintText: 'ชื่อร้านอาหาร'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: contact,
          decoration: const InputDecoration(hintText: 'ชื่อผู้ติดต่อ'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: phone,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: 'โทรศัพท์'),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: firstName,
                decoration: const InputDecoration(hintText: 'ชื่อ'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: lastName,
                decoration: const InputDecoration(hintText: 'นามสกุล'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: nationalId,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'เลขบัตรประชาชน'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: idCardAddress,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'ที่อยู่ตามบัตรประชาชน'),
        ),
      ],
    );
  }
}
