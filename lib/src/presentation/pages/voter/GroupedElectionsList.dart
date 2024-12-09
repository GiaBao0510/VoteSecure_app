import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:votesecure/src/data/models/ElectionsUsersHavePaticipated_Model.dart';
import 'package:votesecure/src/domain/repositories/VoterRepository.dart';
import 'package:votesecure/src/presentation/pages/voter/BallotForm.dart';

class GroupedElectionsList extends StatelessWidget {
  final List<ElectionUserHavePaticipanted_Model> elections;
  final String ID_object;
  final VoterRepository voterRepository;

  const GroupedElectionsList({
    Key? key,
    required this.elections,
    required this.ID_object,
    required this.voterRepository,
  }) : super(key: key);

  Map<String, List<ElectionUserHavePaticipanted_Model>> _groupElectionsByMonth() {
    final groupedElections = <String, List<ElectionUserHavePaticipanted_Model>>{};

    for (var election in elections) {
      final date = DateTime.parse(election.ngayBD!);
      final monthYear = DateFormat('MMMM yyyy', 'vi_VN').format(date);

      if (!groupedElections.containsKey(monthYear)) {
        groupedElections[monthYear] = [];
      }
      groupedElections[monthYear]!.add(election);
    }

    // Sắp xếp các tháng theo thứ tự giảm dần
    final sortedKeys = groupedElections.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MMMM yyyy', 'vi_VN').parse(a);
        final dateB = DateFormat('MMMM yyyy', 'vi_VN').parse(b);
        return dateB.compareTo(dateA);
      });

    return Map.fromEntries(
        sortedKeys.map((key) => MapEntry(key, groupedElections[key]!))
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedElections = _groupElectionsByMonth();

    return ListView.builder(
      itemCount: groupedElections.length,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final monthYear = groupedElections.keys.elementAt(index);
        final monthElections = groupedElections[monthYear]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  monthYear,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: monthElections.length,
              itemBuilder: (context, idx) {
                final election = monthElections[idx];
                final hasVoted = election.ghiNhan != '0';
                final textColor = hasVoted ? Colors.white : Colors.black87;
                final iconColor = hasVoted ? Colors.white : Colors.black87;
                final containerColor = hasVoted
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black.withOpacity(0.1);

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      if (!hasVoted) {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BallotForm(
                              ngayBD: election.ngayBD,
                              electionDetails: election,
                              ID_object: ID_object,
                            ),
                          ),
                        );

                        if (result == true) {
                          // Refresh the list
                          if (context.mounted) {
                            await Provider.of<VoterRepository>(context, listen: false)
                                .ElectionsInWhichVoterAreAlloweddToParticipate(context);
                          }
                        }
                      } else {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: "Đã bỏ phiếu",
                          text: "Bạn đã bỏ phiếu ở kỳ này rồi",
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: hasVoted
                              ? [Color(0xFF1E88E5), Color(0xFF1565C0)]
                              : [Color(0xFFFFC107), Color(0xFFFFB300)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    hasVoted ? Icons.how_to_vote : Icons.ballot_outlined,
                                    color: iconColor,
                                    size: 28,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        election.tenKyBauCu ?? '',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        election.tenDonViBauCu ?? '',
                                        style: TextStyle(
                                          color: textColor.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: containerColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: iconColor,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(DateTime.parse(election.ngayBD!)),
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: hasVoted
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    hasVoted ? Icons.check_circle : Icons.pending,
                                    color: iconColor,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    hasVoted ? 'Đã bỏ phiếu' : 'Chưa bỏ phiếu',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}