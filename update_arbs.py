import json
import os

ko_path = "/Users/akm/focus_pact/lib/l10n/app_ko.arb"
en_path = "/Users/akm/focus_pact/lib/l10n/app_en.arb"

with open(ko_path, "r") as f:
    ko_arb = json.load(f)

with open(en_path, "r") as f:
    en_arb = json.load(f)

ko_arb.update({
    "timerCompleteNotifTitle": "집중 완료! 🍅",
    "timerCompleteNotifDesc": "약속한 시간이 지났습니다. 앱으로 돌아와서 보상을 획득하세요!",
    "harvestSuccessReward": "토마토 수확을 성공적으로 마쳤습니다\\n보상: 물 {waterAmount}개",
    "@harvestSuccessReward": {
      "placeholders": {
        "waterAmount": {
          "type": "int"
        }
      }
    },
    "harvestFailedNoPin": "타이머를 완료했지만 화면 잠금을 허용하지 않아\\n보상을 받을 수 없습니다.",
    "harvestCompleteTitle": "수확 완료!",
    "harvestSuccessMessage": "토마토 수확 성공! 물이 추가되었습니다.",
    "harvestFailedMessage": "시간은 채웠지만 화면 잠금 거부로 보상 획득 실패",
    "focusFailedRotten": "몰입 실패. 토마토가 상해버렸어요",
    "promiseBrokenTitle": "약속 위반",
    "expectedWaterDrops": "예상 획득 물방울: {count}개 ",
    "@expectedWaterDrops": {
      "placeholders": {
        "count": {
          "type": "int"
        }
      }
    },
    "setupTimePrompt": "시간을 설정해주세요",
    "breakPromiseWarning": "앱을 벗어나면 약속이 깨집니다",
    "giveUp": "포기하기",
    "start": "시작"
})

en_arb.update({
    "timerCompleteNotifTitle": "Focus Complete! 🍅",
    "timerCompleteNotifDesc": "Your promised time is up. Return to the app and claim your reward!",
    "harvestSuccessReward": "Tomato harvested successfully\\nReward: {waterAmount} Water",
    "harvestFailedNoPin": "Timer completed but screen pinning was denied.\\nNo reward can be claimed.",
    "harvestCompleteTitle": "Harvest Complete!",
    "harvestSuccessMessage": "Tomato harvest success! Water added.",
    "harvestFailedMessage": "Time completed but reward failed due to denied screen pinning",
    "focusFailedRotten": "Focus failed. The tomato rotted.",
    "promiseBrokenTitle": "Promise Broken",
    "expectedWaterDrops": "Expected Water Drops: {count} ",
    "setupTimePrompt": "Please set the time",
    "breakPromiseWarning": "Leaving the app will break your promise",
    "giveUp": "Give Up",
    "start": "Start"
})

with open(ko_path, "w") as f:
    json.dump(ko_arb, f, ensure_ascii=False, indent=2)

with open(en_path, "w") as f:
    json.dump(en_arb, f, ensure_ascii=False, indent=2)

print("ARB files updated")
