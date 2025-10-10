export interface ClothesItem {
  id: number
}

export interface UserInfo {
  userID: number
  nick: string
  vip: number
  vipLevel: number
  isExtremeNono: boolean
  status: number
  regTime: number
  loginTime: number
  lastOfflineTime: number
  teamID: number
  clothes: ClothesItem[]
  petAllNum: number
  petMaxLev: number
  totalAchieve: number
  achieShine: number
  achieRank: number
  curTitle: string
  bossAchievement: boolean[]
  maxFreshStage: number
  maxStage: number
  maxLadderState: number
  maxKingStage: number
  maxKingHeroStage: number
  maxFortuneState: number
  highFightWin: number
  extremeLawLevel: number
  battleLabInfo: number
  totalClassWins: number
  monKingWin: number
  teamBoss: number
  messWin: number
  luckyFightWin: number
  fightArenaWin: number
  royaleWin: number
  darkFightWin: number
  maxArenaWins: number
  maxSpaceArenaWins: number
  zheguangWinTimes: number
  dreamMessWins: number
  aresUnionTeam: string
  curTopHonour: number
  deltaTopHonour: number
  deltaTopLv: number
  topWinCount: number
  topLossCount: number
  maxTopWinSucc: number
  curTopWinSucc: number
  trainerDoor_num: number
  carnival_total_score: number
  hurdles_win_num: number
  tug_win_num: number
  jump_num: number
}

export interface QueryResponse {
  success: boolean
  data: {
    account: string
    userinfo: UserInfo
  }
  message?: string
}

export interface HealthResponse {
  status: string
  service_connected: boolean
  timestamp: number
}
