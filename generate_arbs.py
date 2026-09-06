import json
import os

ko_arb = {
    "appTitle": "Focus Pact",
    "myAsset": "내 자산",
    "todayFocus": "오늘 집중",
    "streakDaysTitle": "연속 일수",
    "tapForHistory": "탭하여 상세 히스토리 보기",
    "streakDaysPlural": "{count}일 연속 수확",
    "@streakDaysPlural": {
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "streakZero": "새로운 씨앗을 심으세요",
    "tomatoFarm": "토마토 농장",
    "currentMultiplier": "현재 {multiplier}배속",
    "@currentMultiplier": {
        "placeholders": {
            "multiplier": {"type": "String"}
        }
    },
    "growthStage": "성장단계",
    "waterButton": "물주기\\n({count})",
    "@waterButton": {
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "harvestButton": "수확하기!",
    "ownedTomatoes": "보유 토마토: {count}개",
    "@ownedTomatoes": {
        "placeholders": {
            "count": {"type": "int"}
        }
    },
    "sellTomatoes": "수확물 팔기\\n(+1,000원)",
    "historyTitle": "📅 상태 히스토리",
    "tabDaily": "일별",
    "tabWeekday": "요일별",
    "tabMonthly": "월별",
    "noRecords": "기록이 없습니다.",
    "statsTitle": "📊 주간 집중 시간",
    "close": "닫기",
    "weekdayMon": "월",
    "weekdayTue": "화",
    "weekdayWed": "수",
    "weekdayThu": "목",
    "weekdayFri": "금",
    "weekdaySat": "토",
    "weekdaySun": "일",
    "tapForWeeklyStats": "터치하여 주간 통계 보기",
    "timerNotStarted": "오늘 아직 집중을 시작하지 않았어요!",
    "todayFocusMins": "오늘 {minutes}분 집중!",
    "@todayFocusMins": {
        "placeholders": {
            "minutes": {"type": "int"}
        }
    },
    "shopTitle": "🛒 상점",
    "myMoney": "내 자산: {money}원",
    "@myMoney": {
        "placeholders": {
            "money": {"type": "String"}
        }
    },
    "owned": "보유중",
    "buy": "구매",
    "giveUpButton": "포기하기",
    "pomodoroTitle": "🍅 뽀모도로 타이머 시작하기",
    "timerRunning": "집중 중...",
    "timerPaused": "일시 정지됨",
    "timerCompleted": "타이머 완료! 수확하세요!",
    "waterEarned": "물을 획득했습니다!",
    "tomatoEarned": "토마토를 획득했습니다!",
    "confirm": "확인",
    "warningTitle1": "잠깐! 정말 포기하시겠습니까?",
    "warningTitle2": "🚨 한 번 더 생각해 보세요!",
    "warningTitle3": "💀 마지막 기회입니다",
    "warningContent1": "지금까지 집중한 시간이 모두 사라집니다.\\n계속하시겠습니까?",
    "warningContent2": "포기하면 물을 얻을 수 없습니다.\\n정말 이대로 끝내시겠습니까?",
    "warningContent3": "아래 문장을 입력창에 정확히 입력하면 포기할 수 있습니다.",
    "cancel": "취소",
    "giveUp": "포기",
    "giveUpFinal": "진짜 포기",
    "exactMatchRequired": "문장을 정확히 입력해야 합니다.",
    "placeholderTripleWarning": "위 문장을 그대로 입력하세요",
    "timeFormatDaily": "{year}년 {month}월 {day}일",
    "@timeFormatDaily": {
        "placeholders": {
            "year": {"type": "String"},
            "month": {"type": "String"},
            "day": {"type": "String"}
        }
    },
    "timeFormatMonthly": "{year}년 {month}월",
    "@timeFormatMonthly": {
        "placeholders": {
            "year": {"type": "String"},
            "month": {"type": "String"}
        }
    },
    "minuteUnit": "분",
    "dayUnit": "일",
    "countUnit": "개"
}

en_arb = {
    "appTitle": "Focus Pact",
    "myAsset": "My Asset",
    "todayFocus": "Today's Focus",
    "streakDaysTitle": "Streak",
    "tapForHistory": "Tap for detailed history",
    "streakDaysPlural": "{count} day streak",
    "streakZero": "Plant a new seed",
    "tomatoFarm": "Tomato Farm",
    "currentMultiplier": "Current {multiplier}x",
    "growthStage": "Growth Stage",
    "waterButton": "Water\\n({count})",
    "harvestButton": "Harvest!",
    "ownedTomatoes": "Tomatoes: {count}",
    "sellTomatoes": "Sell Tomatoes\\n(+1,000G)",
    "historyTitle": "📅 Status History",
    "tabDaily": "Daily",
    "tabWeekday": "Weekday",
    "tabMonthly": "Monthly",
    "noRecords": "No records found.",
    "statsTitle": "📊 Weekly Focus Time",
    "close": "Close",
    "weekdayMon": "Mon",
    "weekdayTue": "Tue",
    "weekdayWed": "Wed",
    "weekdayThu": "Thu",
    "weekdayFri": "Fri",
    "weekdaySat": "Sat",
    "weekdaySun": "Sun",
    "tapForWeeklyStats": "Tap for weekly stats",
    "timerNotStarted": "You haven't started focusing today!",
    "todayFocusMins": "Focused for {minutes} min today!",
    "shopTitle": "🛒 Shop",
    "myMoney": "My Asset: {money}G",
    "owned": "Owned",
    "buy": "Buy",
    "giveUpButton": "Give Up",
    "pomodoroTitle": "🍅 Start Pomodoro Timer",
    "timerRunning": "Focusing...",
    "timerPaused": "Paused",
    "timerCompleted": "Timer completed! Harvest now!",
    "waterEarned": "Earned water!",
    "tomatoEarned": "Earned a tomato!",
    "confirm": "OK",
    "warningTitle1": "Wait! Do you really want to give up?",
    "warningTitle2": "🚨 Think one more time!",
    "warningTitle3": "💀 Last chance",
    "warningContent1": "The time you focused so far will be lost.\\nContinue?",
    "warningContent2": "You won't get any water if you give up.\\nReally end it here?",
    "warningContent3": "Enter the exact sentence below to give up.",
    "cancel": "Cancel",
    "giveUp": "Give Up",
    "giveUpFinal": "Give up completely",
    "exactMatchRequired": "You must enter the sentence exactly.",
    "placeholderTripleWarning": "Type the sentence exactly as above",
    "timeFormatDaily": "{month}/{day}/{year}",
    "timeFormatMonthly": "{month}/{year}",
    "minuteUnit": "min",
    "dayUnit": "days",
    "countUnit": "ea"
}

# Add pledges
ko_pledges = [
    "나는 지금 유혹에 굴복하여 나의 소중한 시간을 버립니다",
    "나와의 약속을 깨고 순간의 즐거움을 선택하겠습니다",
    "오늘도 핑계를 대며 내일의 나에게 책임을 떠넘깁니다",
    "성장의 기회를 포기하고 편안함에 안주하겠습니다",
    "나의 미래보다 지금 당장의 도파민이 더 중요합니다",
    "이 작은 인내심조차 발휘하지 못하는 나를 인정합니다",
    "스마트폰의 노예가 되어 주체적인 시간을 포기합니다",
    "결심은 쉽지만 실천은 어렵다는 것을 다시금 증명합니다",
    "목표를 향한 발걸음을 멈추고 제자리에 머물겠습니다",
    "소중한 사람들과의 약속보다 화면 속 가짜 세상이 더 좋습니다",
    "잠깐의 유혹을 이기지 못해 그동안 쌓아온 공든 탑을 무너뜨립니다",
    "스스로 정한 규칙조차 지키지 못하는 얄팍한 의지력을 받아들입니다",
    "집중의 고통을 피하고 산만함이 주는 쾌락을 좇겠습니다",
    "나를 성장시킬 소중한 자산을 한순간에 낭비해 버리겠습니다",
    "나쁜 습관의 사슬을 끊지 못하고 다시 굴레로 들어갑니다",
    "변화하겠다는 나의 다짐은 그저 공허한 메아리였습니다",
    "현재의 나태함을 위해 미래의 보상을 기꺼이 희생하겠습니다",
    "아주 작은 난관 앞에서도 쉽게 포기하는 사람이 되겠습니다",
    "진짜 내 삶의 주인이 되기를 포기하고 스마트폰에 끌려다니겠습니다",
    "결국 나는 나와의 싸움에서 또 다시 패배했습니다"
]

en_pledges = [
    "I now succumb to temptation and throw away my precious time",
    "I break the promise to myself and choose momentary pleasure",
    "I make excuses again today and shift responsibility to tomorrow's me",
    "I give up the opportunity to grow and settle for comfort",
    "Immediate dopamine is more important to me than my future",
    "I admit that I cannot exercise even this small amount of patience",
    "I become a slave to my smartphone and give up my independent time",
    "I prove once again that resolving is easy but doing is hard",
    "I stop stepping toward my goal and stay where I am",
    "I prefer the fake world on the screen over promises with loved ones",
    "I tear down the tower I built because I couldn't resist a brief temptation",
    "I accept my weak willpower that cannot even keep my own rules",
    "I avoid the pain of focus and chase the pleasure of distraction",
    "I will waste the precious asset that would have made me grow",
    "I fail to break the chain of bad habits and enter the loop again",
    "My pledge to change was just an empty echo",
    "I will willingly sacrifice future rewards for present laziness",
    "I will be a person who gives up easily in the face of very small hurdles",
    "I give up being the true master of my life and let my smartphone drag me around",
    "In the end, I lost the battle against myself once again"
]

for i in range(len(ko_pledges)):
    ko_arb[f"pledge_{i}"] = ko_pledges[i]
    en_arb[f"pledge_{i}"] = en_pledges[i]

with open("/Users/akm/focus_pact/lib/l10n/app_ko.arb", "w") as f:
    json.dump(ko_arb, f, ensure_ascii=False, indent=2)

with open("/Users/akm/focus_pact/lib/l10n/app_en.arb", "w") as f:
    json.dump(en_arb, f, ensure_ascii=False, indent=2)
