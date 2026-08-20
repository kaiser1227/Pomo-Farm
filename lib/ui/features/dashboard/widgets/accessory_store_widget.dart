import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/app_theme.dart';
import '../view_models/pact_dashboard_view_model.dart';

class AccessoryStoreWidget extends StatelessWidget {
  final PactDashboardViewModel viewModel;

  const AccessoryStoreWidget({Key? key, required this.viewModel}) : super(key: key);

  static const List<Map<String, dynamic>> accessories = [
    {'id': 'sleeping', 'name': '쿨쿨', 'emoji': '💤', 'cost': 1000, 'scale': 0.8, 'offsetX': -30.0, 'offsetY': -40.0},
    {'id': 'sweat', 'name': '삐질 땀방울', 'emoji': '💧', 'cost': 2000, 'scale': 0.6, 'offsetX': 70.0, 'offsetY': -25.0},
    {'id': 'bandaid', 'name': '반창고', 'emoji': '🩹', 'cost': 3000, 'scale': 0.7, 'offsetX': 70.0, 'offsetY': -5.0},
    {'id': 'sparkles', 'name': '반짝반짝 볼', 'emoji': '✨', 'cost': 5000, 'scale': 0.8, 'offsetX': 70.0, 'offsetY': 10.0},
    {'id': 'tongue', 'name': '메롱', 'emoji': '👅', 'cost': 6000, 'scale': 0.8, 'offsetX': 0.0, 'offsetY': 40.0},
    {'id': 'glasses', 'name': '범생이 안경', 'emoji': '👓', 'cost': 7500, 'scale': 1.2, 'offsetX': 0.0, 'offsetY': -15.0},
    {'id': 'goggles', 'name': '수영 고글', 'emoji': '🥽', 'cost': 8500, 'scale': 1.2, 'offsetX': 0.0, 'offsetY': -15.0},
    {'id': 'sunglasses', 'name': '멋쟁이 선글라스', 'emoji': '🕶️', 'cost': 9900, 'scale': 1.2, 'offsetX': 0.0, 'offsetY': -15.0},
    {'id': 'headband', 'name': '열공 머리띠', 'emoji': '🔥열공🔥', 'cost': 10000, 'scale': 1.0, 'offsetX': 0.0, 'offsetY': -45.0},
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
            const Text(
              '✨ 나만의 토마토 꾸미기 상점',
              style: TextStyle(color: AppTheme.textLight, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '획득한 자산 💰(원)을 지불하여 타이머 화면의 토마토를 꾸며보세요!',
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
                              const SnackBar(content: Text('자산이 부족합니다! 💰')),
                            );
                          }
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(acc['emoji'], style: const TextStyle(
                            fontSize: 32, 
                            color: Colors.white,
                            fontFamilyFallback: ['Noto Color Emoji', 'Apple Color Emoji', 'Segoe UI Emoji'],
                          )),
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
                                const Text('💰 ', style: TextStyle(fontSize: 10)),
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
        title: Text('${acc['emoji']} ${acc['name']} 구매', style: const TextStyle(color: AppTheme.textLight)),
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
