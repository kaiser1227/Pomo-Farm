import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/app_theme.dart';
import '../view_models/pact_dashboard_view_model.dart';

class AccessoryStoreWidget extends StatelessWidget {
  final PactDashboardViewModel viewModel;

  const AccessoryStoreWidget({Key? key, required this.viewModel}) : super(key: key);

  static const List<Map<String, dynamic>> accessories = [
    {'id': 'sleeping', 'name': '쿨쿨', 'imagePath': 'assets/images/accessories/sleeping.png', 'color': Colors.indigoAccent, 'cost': 1000, 'width': 60.0, 'height': 60.0, 'offsetX': 70.0, 'offsetY': -70.0},
    {'id': 'sweat', 'name': '삐질 땀방울', 'imagePath': 'assets/images/accessories/sweat.png', 'color': Colors.lightBlueAccent, 'cost': 2000, 'width': 50.0, 'height': 50.0, 'offsetX': 70.0, 'offsetY': -70.0},
    {'id': 'bandaid', 'name': '반창고', 'imagePath': 'assets/images/accessories/bandaid.png', 'color': Colors.orangeAccent, 'cost': 3000, 'width': 60.0, 'height': 60.0, 'offsetX': 60.0, 'offsetY': -60.0},
    {'id': 'sparkles', 'name': '반짝반짝 볼', 'imagePath': 'assets/images/accessories/sparkles.png', 'color': Colors.amber, 'cost': 5000, 'width': 60.0, 'height': 60.0, 'offsetX': 70.0, 'offsetY': -70.0},
    {'id': 'tongue', 'name': '메롱', 'imagePath': 'assets/images/accessories/tongue.png', 'color': Colors.pinkAccent, 'cost': 6000, 'width': 55.0, 'height': 55.0, 'offsetX': 0.0, 'offsetY': 38.0},
    {'id': 'glasses', 'name': '범생이 안경', 'imagePath': 'assets/images/accessories/glasses.png', 'color': Colors.grey, 'cost': 7500, 'width': 300.0, 'height': 300.0, 'offsetX': 0.0, 'offsetY': -10.0},
    {'id': 'goggles', 'name': '수영 고글', 'imagePath': 'assets/images/accessories/goggles.png', 'color': Colors.blue, 'cost': 8500, 'width': 300.0, 'height': 300.0, 'offsetX': 0.0, 'offsetY': -40.0},
    {'id': 'sunglasses', 'name': '멋쟁이 선글라스', 'imagePath': 'assets/images/accessories/sunglasses.png', 'color': Colors.black87, 'cost': 9900, 'width': 300.0, 'height': 300.0, 'offsetX': 0.0, 'offsetY': -10.0},
    {'id': 'headband', 'name': '왕관', 'imagePath': 'assets/images/accessories/headband.png', 'color': Colors.redAccent, 'cost': 10000, 'width': 120.0, 'height': 120.0, 'offsetX': 0.0, 'offsetY': -85.0},
  ];

  @override
  Widget build(BuildContext context) {
    final owned = viewModel.tomatoFarm.ownedAccessories;
    final equipped = viewModel.tomatoFarm.equippedAccessory;
    final money = viewModel.timeBank.money;

    return Card(
      color: AppTheme.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.white10, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: AppTheme.textLight, size: 18),
                SizedBox(width: 6),
                Text(
                  '나만의 토마토 꾸미기 상점',
                  style: TextStyle(color: AppTheme.textLight, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '획득한 자산 '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(Icons.monetization_on, size: 14, color: AppTheme.textGrey),
                  ),
                  TextSpan(text: '(원)을 지불하여 타이머 화면의 토마토를 꾸며보세요!'),
                ],
              ),
              style: TextStyle(color: AppTheme.textGrey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: accessories.length,
                itemBuilder: (context, index) {
                  final acc = accessories[index];
                  final isOwned = owned.contains(acc['id']);
                  final isEquipped = equipped == acc['id'];
                  final canAfford = money >= (acc['cost'] as int);

                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isEquipped ? AppTheme.primaryGreen.withOpacity(0.2) : Colors.black12,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isEquipped ? AppTheme.primaryGreen : Colors.white10,
                        width: isEquipped ? 2 : 1,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (isEquipped) {
                          viewModel.equipAccessory(null);
                        } else if (isOwned) {
                          viewModel.equipAccessory(acc['id']);
                        } else {
                          if (canAfford) {
                            _showPurchaseConfirm(context, acc);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Text('자산이 부족합니다! '),
                                    Icon(Icons.monetization_on, color: Colors.white, size: 16),
                                  ],
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            acc['imagePath'] as String,
                            width: 36,
                            height: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            acc['name'],
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (isOwned)
                            Text(
                              isEquipped ? '장착 중' : '보유 중',
                              style: TextStyle(
                                color: isEquipped ? AppTheme.lightGreen : AppTheme.textGrey,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.monetization_on, size: 12, color: AppTheme.textGrey),
                                const SizedBox(width: 4),
                                Text(
                                  '${acc['cost']}원',
                                  style: TextStyle(
                                    color: canAfford ? AppTheme.tomatoRed : Colors.redAccent.withOpacity(0.5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseConfirm(BuildContext context, Map<String, dynamic> acc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: Row(
          children: [
            Image.asset(acc['imagePath'] as String, width: 24, height: 24),
            const SizedBox(width: 8),
            Text('${acc['name']} 구매', style: const TextStyle(color: AppTheme.textLight)),
          ],
        ),
        content: Text('내 자산 ${acc['cost']}원을 사용하여 구매하시겠습니까?', style: const TextStyle(color: AppTheme.textGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소', style: TextStyle(color: AppTheme.textGrey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              viewModel.buyAccessory(acc['id'], acc['cost']);
              
              try {
                final player = AudioPlayer();
                await player.play(AssetSource('sounds/buy_sound.wav'));
              } catch (e) {
                debugPrint('Failed to play buy sound: $e');
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${acc['name']}을(를) 구매하고 장착했습니다!')),
              );
            },
            child: const Text('구매', style: TextStyle(color: AppTheme.tomatoRed, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
