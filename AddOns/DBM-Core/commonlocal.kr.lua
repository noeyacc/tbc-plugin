if GetLocale() ~= "koKR" then return end
if not DBM_COMMON_L then DBM_COMMON_L = {} end

local CL = DBM_COMMON_L

CL.NONE						= "없음"
CL.RANDOM					= "무작위"
CL.NEXT						= "다음 %s"
CL.COOLDOWN					= "%s 쿨타임"
CL.UNKNOWN					= "알 수 없음"--UNKNOWN
CL.LEFT						= "왼쪽"
CL.RIGHT						= "오른쪽"
CL.BOTH						= "양쪽"
CL.BEHIND					= "뒤쪽"
CL.BACK						= "뒤쪽"--Back as in back of the room, not back as in body part
CL.SIDE						= "옆쪽"--Side as in move to the side
CL.TOP						= "위쪽"--Top as in up top, not BDSM
CL.BOTTOM					= "아래쪽"--Bottom as in at the bottom, not BDSM
CL.MIDDLE					= "가운데"
CL.FRONT						= "앞쪽"
CL.EAST						= "동쪽"
CL.WEST						= "서쪽"
CL.NORTH						= "북쪽"
CL.SOUTH						= "남쪽"
CL.INTERMISSION				= "사잇 단계"
CL.ORB						= "구슬"
CL.ORBS						= "구슬"
CL.RING						= "고리"
CL.RINGS						= "고리"
CL.CHEST						= "상자"--As in Treasure 'Chest'. Not Chest as in body part.
CL.NO_DEBUFF					= "%s 없음"--For use in places like info frame where you put "Not Spellname"
CL.ALLY						= "공대원"--Such as "Move to Ally"
CL.ALLIES					= "공대원"--Such as "Move to Allies"
CL.ADD						= "쫄"--A fight Add as in "boss spawned extra adds"
CL.ADDS						= "쫄"
CL.BIG_ADD					= "큰 쫄"
CL.BOSS						= "보스"
CL.EDGE						= "구석"
CL.FAR_AWAY					= "먼 곳"
CL.BREAK_LOS					= "시야 안나오는 곳"
CL.RESTORE_LOS				= "시야 확보되는 곳"
CL.SAFE						= "안전함"
CL.NOTSAFE					= "위험함"
CL.SHIELD					= "보호막"
CL.PILLAR					= "기둥"
CL.INCOMING					= "%s 등장"
CL.BOSSTOGETHER				= "보스 붙이세요"
CL.BOSSAPART					= "보스 떨어트리세요"
CL.TANKCOMBO					= "탱커 연속 공격"