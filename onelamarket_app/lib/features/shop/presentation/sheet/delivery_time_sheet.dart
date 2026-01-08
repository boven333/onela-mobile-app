import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeliveryTimeSheet extends StatefulWidget {
  const DeliveryTimeSheet({
    super.key,
    required this.initialDate,
    required this.initialSlot,
    required this.onSelect,
  });

  final DateTime initialDate;
  final String initialSlot;

  // ✅ ส่งกลับ 3 ค่า ให้ตรงกับ CheckoutPage + Controller
  final void Function(DateTime date, String dateLabel, String slot) onSelect;

  @override
  State<DeliveryTimeSheet> createState() => _DeliveryTimeSheetState();
}

class _DeliveryTimeSheetState extends State<DeliveryTimeSheet> {
  late DateTime selectedDate;
  late String selectedSlot;

  late final List<DateTime> days;

  // mock สถานะ slot (รอ API มาเปลี่ยน)
  final Map<String, bool> slotAvailability = const {
    '08.00 - 10.00': true, // เต็มแล้ว
    '10.00 - 12.00': true,
    '12.00 - 14.00': true,
    '14.00 - 16.00': true,
    '16.00 - 18.00': true,
  };

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    );
    selectedSlot = widget.initialSlot;

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);

    // 5 วันถัดไป (เหมือนในรูป)
    days = List.generate(30, (i) => start.add(Duration(days: i + 1)));
  }

  String _dayLabel(DateTime d) {
    // ต้อง import intl
    final weekday = DateFormat.E('th').format(d); // อ., พ., ศ.
    return '$weekday ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.black.withOpacity(0.35), // overlay เทา
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: h * 0.78,
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + MediaQuery.of(context).padding.bottom),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(999),
                    child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.close)),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'วันที่และเวลา',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // แถบวัน (ตามรูป)
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final d = days[i];
                    final isSelected = DateUtils.isSameDay(d, selectedDate);
                    final isDisabled = (i == 0); // mock: วันแรกเต็ม

                    return InkWell(
                      onTap: isDisabled ? null : () => setState(() => selectedDate = d),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 64,
                        decoration: BoxDecoration(
                          color: isDisabled
                              ? const Color(0xFFF3F4F6)
                              : isSelected
                              ? const Color(0xFFE9B949)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? Colors.transparent : const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _dayLabel(d),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: isDisabled ? Colors.black38 : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              // slot list
              Expanded(
                child: ListView.separated(
                  itemCount: slotAvailability.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final entry = slotAvailability.entries.elementAt(i);
                    final slot = entry.key;
                    final canBook = entry.value;
                    final isSelected = slot == selectedSlot;

                    return InkWell(
                      onTap: canBook ? () => setState(() => selectedSlot = slot) : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: canBook ? Colors.white : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFE9B949) : const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                slot,
                                style: const TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                            Text(
                              canBook ? 'จองได้' : 'เต็มแล้ว',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: canBook ? Colors.black54 : Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              // confirm
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE9B949),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  ),
                  onPressed: () {
                    final label = _dayLabel(selectedDate);
                    widget.onSelect(selectedDate, label, selectedSlot);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'เลือกช่วงเวลา',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
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
