import json
import os

ko_path = "/Users/akm/focus_pact/lib/l10n/app_ko.arb"
en_path = "/Users/akm/focus_pact/lib/l10n/app_en.arb"

with open(ko_path, "r") as f:
    ko_arb = json.load(f)

with open(en_path, "r") as f:
    en_arb = json.load(f)

ko_arb.update({
    "warningDialogTitle": "정말 포기하시겠습니까?",
    "warningDialogPenaltyMsg": "지금 포기하면 다음과 같은 페널티가 발생합니다:",
    "warningDialogStreakReset": "애써 키운 연속 수확 기록이 초기화됩니다.",
    "warningDialogAssetDeduction": "집중 실패 벌금으로 {penalty}분의 자산이 차감됩니다.",
    "@warningDialogAssetDeduction": {
      "placeholders": {
        "penalty": {
          "type": "int"
        }
      }
    },
    "warningDialogPartnerNotification": "파트너에게 실패 알림이 전송됩니다.",
    "warningDialogTypeToGiveUp": "그래도 포기하시려면, 아래 문장을 정확히 입력하세요.",
    "warningDialogInputHint": "위 문장을 그대로 입력하세요",
    "warningDialogContinueFocus": "계속 집중하기",
    "warningDialogGiveUpAsset": "포기하고 자산 잃기"
})

en_arb.update({
    "warningDialogTitle": "Are you sure you want to give up?",
    "warningDialogPenaltyMsg": "If you give up now, the following penalties will occur:",
    "warningDialogStreakReset": "Your hard-earned consecutive harvest streak will be reset.",
    "warningDialogAssetDeduction": "You will lose {penalty} minutes of assets as a penalty.",
    "warningDialogPartnerNotification": "A failure notification will be sent to your partner.",
    "warningDialogTypeToGiveUp": "If you still want to give up, type the sentence below exactly.",
    "warningDialogInputHint": "Type the sentence above exactly",
    "warningDialogContinueFocus": "Continue Focusing",
    "warningDialogGiveUpAsset": "Give Up & Lose Assets"
})

with open(ko_path, "w") as f:
    json.dump(ko_arb, f, ensure_ascii=False, indent=2)

with open(en_path, "w") as f:
    json.dump(en_arb, f, ensure_ascii=False, indent=2)

print("ARB files updated")
