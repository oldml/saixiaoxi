package com.robot.core.info
{
   import com.robot.core.config.xml.ClothXMLInfo;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.group.info.GroupIDInfo;
   import com.robot.core.group.info.GroupInfo;
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.info.team.TeamInfo;
   import com.robot.core.info.teamPK.TeamPKInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.SystemTimerManager;
   import com.robot.core.manager.TasksManager;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.debug.DebugTrace;
   import org.taomee.events.DynamicEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.BitUtil;
   import org.taomee.utils.StringUtil;
   
   public class UserInfo
   {
      
      public var blackCrystalPos:uint;
      
      public var priorLevel:uint;
      
      public var userID:uint;
      
      public var timePoke:uint;
      
      public var hasSimpleInfo:Boolean = false;
      
      public var hasMoreInfo:Boolean = false;
      
      public var nick:String = "";
      
      public var vip:uint;
      
      public var viped:uint;
      
      public var isExtremeNono:Boolean;
      
      public var cuteType:uint;
      
      public var color:uint;
      
      public var texture:uint;
      
      public var energy:uint;
      
      public var _coins:uint;
      
      public var fightBadge:uint;
      
      public var fightBadge1:uint;
      
      public var fightPkBadge:uint;
      
      public var fightRoyale:uint;
      
      public var status:uint;
      
      public var mapType:uint;
      
      public var mapID:uint;
      
      public var actionType:uint;
      
      public var pos:Point = new Point();
      
      public var spiritTime:uint;
      
      public var spiritID:uint;
      
      public var isBright:Boolean;
      
      public var specialBright:Boolean;
      
      public var clothes:Array = [];
      
      public var decorateList:Array = [];
      
      public var ore:uint;
      
      public var serverID:uint;
      
      public var action:uint;
      
      public var direction:uint;
      
      public var changeShape:uint;
      
      public var petNum:uint;
      
      public var timeToday:uint;
      
      public var loginCnt:uint;
      
      public var inviter:uint;
      
      public var teamID:uint;
      
      public var isCanBeTeacher:Boolean;
      
      public var teacherID:uint;
      
      public var studentID:uint;
      
      public var graduationCount:uint;
      
      public var isRecruitor:Boolean;
      
      public var maxPuniLv:uint;
      
      public var regTime:uint;
      
      public var petAllNum:uint;
      
      public var totalAchieve:uint;
      
      public var achieShine:uint;
      
      public var achieRank:uint;
      
      public var curTitle:uint;
      
      public var teamBoss:uint;
      
      public var petMaxLev:uint;
      
      public var bossAchievement:Array = [];
      
      public var fightFlag:uint;
      
      public var monKingWin:uint;
      
      public var messWin:uint;
      
      public var luckyFightWin:uint;
      
      public var fightArenaWin:uint;
      
      public var royaleWin:uint;
      
      public var darkFightWin:uint;
      
      public var highFightWin:uint;
      
      public var curStage:uint;
      
      public var maxStage:uint;
      
      public var curFreshStage:uint;
      
      public var maxFreshStage:uint;
      
      public var curKingStage:uint;
      
      public var maxKingStage:uint;
      
      public var maxKingHeroStage:uint;
      
      public var maxLadderState:uint;
      
      public var maxFortuneState:uint;
      
      public var maxHigherState:uint;
      
      public var extremeLawLevel:uint;
      
      public var battleLabInfo:uint;
      
      public var zheguangWinTimes:uint;
      
      public var dreamMessWins:uint;
      
      public var maxArenaWins:uint;
      
      public var maxSpaceArenaWins:uint;
      
      public var eFChampion:uint;
      
      public var totalClassWins:uint;
      
      public var reserved:ByteArray;
      
      public var superNono:Boolean;
      
      public var hasNono:Boolean;
      
      public var openTiger:Boolean;
      
      public var openDragon:Boolean;
      
      public var openYanMo:Boolean;
      
      public var openSaiBoSiTe:Boolean;
      
      public var openGreenDragon:Boolean;
      
      public var openJieensi:Boolean;
      
      public var openBaenna:Boolean;
      
      public var openShiZuLingShou:Boolean;
      
      public var openTuoLuKe:Boolean;
      
      public var openJixieTacoLyn:Boolean;
      
      public var openBasite:Boolean;
      
      public var openTaiGuLa:Boolean;
      
      public var openBaihu:Boolean;
      
      public var openSitanli:Boolean;
      
      public var openRuidehaosi:Boolean;
      
      public var openDierke:Boolean;
      
      public var openWhiteHorse:Boolean;
      
      public var openKubeisa:Boolean;
      
      public var openBaKeDi:Boolean;
      
      public var openSiweila:Boolean;
      
      public var openPailabi:Boolean;
      
      public var openKaimila:Boolean;
      
      public var openKuangyeheiniao:Boolean;
      
      public var openQilin:Boolean;
      
      public var openNaKaLuoHa:Boolean;
      
      public var openGeErBoKe:Boolean;
      
      public var openELingShou:Boolean;
      
      public var openGhostTiger:Boolean;
      
      public var openMegatronTiger:Boolean;
      
      public var openPeiluomu:Boolean;
      
      public var openYinLeiTianLong:Boolean;
      
      public var openHanDiJuLong:Boolean;
      
      public var openYikongzhanqi:Boolean;
      
      public var mountId:uint;
      
      public var nonoState:Array = [];
      
      public var nonoNick:String = "";
      
      public var nonoColor:uint;
      
      public var nonoChangeToPet:uint;
      
      public var timeLimit:uint;
      
      public var dsFlag:uint;
      
      public var newInviteeCnt:uint;
      
      public var freshManBonus:uint;
      
      public var dailyResArr:Array = [];
      
      public var summerHolidaysArr:Array = [];
      
      public var dailyTaskWeekHotArr:Array = [];
      
      public var bufferRecordArr:Array = [];
      
      public var nonoChipList:Array = [];
      
      public var teamInfo:TeamInfo;
      
      public var teamPKInfo:TeamPKInfo;
      
      public var transId:uint;
      
      public var transDuration:uint;
      
      public var isFamous:Boolean;
      
      public var vipTitle:uint;
      
      public var vipLevel:uint;
      
      public var vipValue:uint;
      
      public var vipStage:uint;
      
      public var autoCharge:uint;
      
      public var vipEndTime:uint;
      
      public var autoFight:uint;
      
      public var autoFightTimes:uint;
      
      public var twoTimes:uint;
      
      public var threeTimes:uint;
      
      public var monBtlMedal:uint;
      
      public var energyTimes:uint;
      
      public var learnTimes:uint;
      
      public var btlDetectTimes:uint;
      
      public var mobilizeTime:uint;
      
      public var recordCnt:uint;
      
      public var obtainTm:uint;
      
      public var soulBeadItemID:uint;
      
      public var expireTm:uint;
      
      public var fuseTimes:uint;
      
      public var vipScore:uint;
      
      public var canReadSchedule:Boolean;
      
      public var sysTime:uint;
      
      public var darkLight:uint;
      
      public var deltaTopLv:uint;
      
      public var deltaTopHonour:uint;
      
      public var curTopHonour:uint;
      
      public var topWinCount:uint;
      
      public var topLossCount:uint;
      
      public var maxTopWinSucc:uint;
      
      public var curTopWinSucc:uint;
      
      public var top_Two_Lvl:uint;
      
      public var top_Two_Win:uint;
      
      public var top_Two_Lose:uint;
      
      public var top_Two_Max_Win:uint;
      
      public var top_Two_Sur_Win:uint;
      
      public var top_Tree_Lvl:uint;
      
      public var top_Tree_Win:uint;
      
      public var top_Tree_Lose:uint;
      
      public var top_Tree_Max_Win:uint;
      
      public var top_Tree_Sur_Win:uint;
      
      public var top_Four_Lvl:uint;
      
      public var top_Four_Win:uint;
      
      public var top_Four_Lose:uint;
      
      public var top_Four_Max_Win:uint;
      
      public var top_Four_Sur_Win:uint;
      
      public var top_Five_Lvl:uint;
      
      public var top_Five_Win:uint;
      
      public var top_Five_Lose:uint;
      
      public var top_Five_Max_Win:uint;
      
      public var top_Five_Sur_Win:uint;
      
      public var top_Six_Lvl:uint;
      
      public var top_Six_Win:uint;
      
      public var top_Six_Lose:uint;
      
      public var top_Six_Max_Win:uint;
      
      public var top_Six_Sur_Win:uint;
      
      public var top_Seven_Lvl:uint;
      
      public var top_Seven_Win:uint;
      
      public var top_Seven_Lose:uint;
      
      public var top_Seven_Max_Win:uint;
      
      public var top_Seven_Sur_Win:uint;
      
      public var top_Eight_Lvl:uint;
      
      public var top_Eight_Win:uint;
      
      public var top_Eight_Lose:uint;
      
      public var top_Eight_Max_Win:uint;
      
      public var top_Eight_Sur_Win:uint;
      
      public var top_Nine_Lvl:uint;
      
      public var top_Nine_Win:uint;
      
      public var top_Nine_Lose:uint;
      
      public var top_Nine_Max_Win:uint;
      
      public var top_Nine_Sur_Win:uint;
      
      public var top_Ten_Lvl:uint;
      
      public var top_Ten_Win:uint;
      
      public var top_Ten_Lose:uint;
      
      public var top_Ten_Max_Win:uint;
      
      public var top_Ten_Sur_Win:uint;
      
      public var top_ELEVEN_Lvl:uint;
      
      public var top_ELEVEN_Win:uint;
      
      public var top_ELEVEN_Lose:uint;
      
      public var top_ELEVEN_Max_Win:uint;
      
      public var top_ELEVEN_Sur_Win:uint;
      
      public var top_TWELVE_Lvl:uint;
      
      public var top_TWELVE_Win:uint;
      
      public var top_TWELVE_Lose:uint;
      
      public var top_TWELVE_Max_Win:uint;
      
      public var top_TWELVE_Sur_Win:uint;
      
      public var hasN2Num:uint;
      
      public var trainerDoor_num:uint;
      
      public var carnival_total_score:uint;
      
      public var hurdles_win_num:uint;
      
      public var hurdles_lose_num:uint;
      
      public var tug_win_num:uint;
      
      public var tug_lose_num:uint;
      
      public var tug_draw_num:uint;
      
      public var jump_num:uint;
      
      public var groupInfo:GroupInfo;
      
      public var isActive:Boolean;
      
      public var oldSeerInvateCount:uint;
      
      public var blanketInvateCount:uint;
      
      public var toDayGetGiftCount:uint;
      
      public var totalGiftCount:uint;
      
      public var topStatus:uint;
      
      public var topStatus2:uint;
      
      public var topStatus3:uint;
      
      public var topStatus4:uint;
      
      public var topStatus5:uint;
      
      public var topStatus6:uint;
      
      public var topStatus7:uint;
      
      public var topStatus8:uint;
      
      public var topStatus9:uint;
      
      public var topStatus10:uint;
      
      public var topStatus11:uint;
      
      public var aresUnionTeam:uint;
      
      public var starPkWinNum:uint;
      
      public var luogeTeamId:uint;
      
      public var crackCupTeamId:uint;
      
      public var monthLoginDay:uint;
      
      public var isBeaten:uint;
      
      public var isBeaten_1:uint;
      
      public var topFightEffect:uint;
      
      public var fightArenaPoint:uint;
      
      public var fireBuff:uint;
      
      public var jobTitle:uint;
      
      public var dragonStatus:uint;
      
      public var luoboteStatus:uint;
      
      public var aiErFuAndMiYouLaStatus:uint;
      
      public var usersCamp:uint;
      
      public var lastLoginTime:uint;
      
      public var loginTime:uint;
      
      public var lastOfflineTime:int;
      
      public var isFriend:Boolean;
      
      public var isBlack:Boolean;
      
      public var tangyuan:int;
      
      public var foolsdayMask:int;
      
      public var tigerFightTeam:int;
      
      public var tigerFightScore:int;
      
      public var lordOfWarTeamId:int;
      
      public var otherPetID:uint;
      
      public var otherBright:Boolean;
      
      public var otherEatBright:Boolean;
      
      public var logintimeThisTime:uint;
      
      public var getGiftDate:uint;
      
      public var getGiftTime:uint;
      
      public var redball:uint;
      
      public var yellowball:uint;
      
      public var blueball:uint;
      
      public function UserInfo()
      {
         super();
      }
      
      public static function setForPeoleInfo(param1:UserInfo, param2:IDataInput) : void
      {
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         param1.hasSimpleInfo = true;
         param1.sysTime = param2.readInt();
         param1.userID = param2.readUnsignedInt();
         param1.nick = param2.readUTFBytes(16);
         param1.curTitle = param2.readUnsignedInt();
         param1.color = param2.readUnsignedInt();
         param1.texture = param2.readUnsignedInt();
         param1.jobTitle = param2.readUnsignedInt();
         param1.isFamous = Boolean(param2.readUnsignedInt());
         param1.vipTitle = param2.readUnsignedInt();
         var _loc3_:uint = uint(param2.readUnsignedInt());
         param1.vip = BitUtil.getBit(_loc3_,0);
         param1.viped = BitUtil.getBit(_loc3_,1);
         var _loc4_:uint = uint(param2.readUnsignedByte());
         param1.isExtremeNono = Boolean(BitUtil.getBit(_loc4_,1));
         if(!param1.isVip)
         {
            param1.isExtremeNono = false;
         }
         param1.vipStage = param2.readUnsignedInt();
         param1.actionType = param2.readUnsignedInt();
         param1.pos = new Point(param2.readUnsignedInt(),param2.readUnsignedInt());
         param1.action = param2.readUnsignedInt();
         param1.direction = param2.readUnsignedInt();
         param1.changeShape = param2.readUnsignedInt();
         param1.darkLight = param2.readUnsignedInt();
         param1.luoboteStatus = param2.readUnsignedInt();
         param1.aresUnionTeam = param2.readUnsignedInt();
         param1.aiErFuAndMiYouLaStatus = param2.readUnsignedInt();
         param1.usersCamp = param2.readUnsignedInt();
         param1.spiritTime = param2.readUnsignedInt();
         param1.spiritID = param2.readUnsignedInt();
         param1.isBright = Boolean(param2.readUnsignedInt());
         param1.specialBright = Boolean(param2.readUnsignedInt());
         param1.otherPetID = param2.readUnsignedInt();
         param1.otherBright = Boolean(param2.readUnsignedInt());
         param1.otherEatBright = Boolean(param2.readUnsignedInt());
         param1.fightFlag = param2.readUnsignedInt();
         param1.teacherID = param2.readUnsignedInt();
         param1.studentID = param2.readUnsignedInt();
         var _loc5_:uint = uint(param2.readUnsignedInt());
         var _loc6_:int = 0;
         while(_loc6_ < 32)
         {
            param1.nonoState.push(BitUtil.getBit(_loc5_,_loc6_));
            _loc6_++;
         }
         param1.nonoColor = param2.readUnsignedInt();
         param1.superNono = Boolean(param2.readUnsignedInt());
         param1.nonoChangeToPet = param2.readUnsignedInt();
         param1.transId = param2.readUnsignedInt();
         param1.transDuration = param2.readUnsignedInt();
         var _loc7_:uint = uint(param2.readUnsignedInt());
         var _loc8_:Array = new Array();
         var _loc9_:int = 0;
         while(_loc9_ < _loc7_)
         {
            _loc8_.push(param2.readUnsignedInt());
            _loc9_++;
         }
         var _loc10_:uint = uint(_loc8_[0]);
         param1.openTiger = Boolean(BitUtil.getBit(_loc10_,0));
         param1.openDragon = Boolean(BitUtil.getBit(_loc10_,1));
         param1.openYanMo = Boolean(BitUtil.getBit(_loc10_,2));
         param1.openSaiBoSiTe = Boolean(BitUtil.getBit(_loc10_,3));
         param1.openGreenDragon = Boolean(BitUtil.getBit(_loc10_,4));
         param1.openJieensi = Boolean(BitUtil.getBit(_loc10_,5));
         param1.openBaenna = Boolean(BitUtil.getBit(_loc10_,6));
         param1.openShiZuLingShou = Boolean(BitUtil.getBit(_loc10_,7));
         param1.openTuoLuKe = Boolean(BitUtil.getBit(_loc10_,8));
         param1.openJixieTacoLyn = Boolean(BitUtil.getBit(_loc10_,9));
         param1.openBasite = Boolean(BitUtil.getBit(_loc10_,10));
         param1.openTaiGuLa = Boolean(BitUtil.getBit(_loc10_,11));
         param1.openBaihu = Boolean(BitUtil.getBit(_loc10_,12));
         param1.openSitanli = Boolean(BitUtil.getBit(_loc10_,14));
         param1.openRuidehaosi = Boolean(BitUtil.getBit(_loc10_,27));
         param1.openDierke = Boolean(BitUtil.getBit(_loc10_,19));
         param1.openWhiteHorse = Boolean(BitUtil.getBit(_loc10_,28));
         param1.openKubeisa = Boolean(BitUtil.getBit(_loc10_,29));
         param1.openBaKeDi = Boolean(BitUtil.getBit(_loc10_,24));
         param1.openSiweila = Boolean(BitUtil.getBit(_loc10_,30));
         param1.openPailabi = Boolean(BitUtil.getBit(_loc10_,31));
         _loc10_ = uint(_loc8_[1]);
         param1.openKaimila = Boolean(BitUtil.getBit(_loc10_,0));
         param1.openKuangyeheiniao = Boolean(BitUtil.getBit(_loc10_,1));
         param1.openQilin = Boolean(BitUtil.getBit(_loc10_,2));
         param1.openNaKaLuoHa = Boolean(BitUtil.getBit(_loc10_,3));
         param1.openGeErBoKe = Boolean(BitUtil.getBit(_loc10_,4));
         param1.openELingShou = Boolean(BitUtil.getBit(_loc10_,5));
         param1.openGhostTiger = Boolean(BitUtil.getBit(_loc10_,6));
         param1.openMegatronTiger = Boolean(BitUtil.getBit(_loc10_,7));
         param1.openPeiluomu = Boolean(BitUtil.getBit(_loc10_,8));
         param1.openYinLeiTianLong = Boolean(BitUtil.getBit(_loc10_,9));
         param1.openHanDiJuLong = Boolean(BitUtil.getBit(_loc10_,10));
         param1.openYikongzhanqi = Boolean(BitUtil.getBit(_loc10_,11));
         param1.mountId = param2.readUnsignedInt();
         var _loc11_:GroupInfo = new GroupInfo();
         _loc11_.groupIDInfo = new GroupIDInfo(param2);
         _loc11_.leaderID = param2.readUnsignedInt();
         _loc11_.groupName = param2.readUTFBytes(16);
         _loc11_.sctID = param2.readUnsignedByte();
         _loc11_.pointID = param2.readUnsignedByte();
         _loc11_.sctPoint = [_loc11_.sctID,_loc11_.pointID];
         param1.groupInfo = _loc11_;
         var _loc12_:TeamInfo = new TeamInfo();
         _loc12_.id = param2.readUnsignedInt();
         _loc12_.coreCount = param2.readUnsignedInt();
         _loc12_.isShow = Boolean(param2.readUnsignedInt());
         _loc12_.logoBg = param2.readShort();
         _loc12_.logoIcon = param2.readShort();
         _loc12_.logoColor = param2.readShort();
         _loc12_.txtColor = param2.readShort();
         _loc12_.logoWord = param2.readUTFBytes(4);
         param1.teamInfo = _loc12_;
         var _loc13_:uint = uint(param2.readUnsignedInt());
         param1.clothes.splice(0);
         var _loc14_:int = 0;
         while(_loc14_ < _loc13_)
         {
            _loc17_ = uint(param2.readUnsignedInt());
            _loc18_ = uint(param2.readUnsignedInt());
            param1.clothes.push(new PeopleItemInfo(_loc17_,_loc18_));
            _loc14_++;
         }
         param1.topFightEffect = param2.readUnsignedInt();
         param1.fireBuff = param2.readUnsignedByte();
         param1.tangyuan = param2.readUnsignedInt();
         param1.foolsdayMask = param2.readUnsignedInt();
         param1.tigerFightTeam = param2.readUnsignedInt();
         param1.tigerFightScore = param2.readUnsignedInt();
         param1.crackCupTeamId = param2.readUnsignedInt();
         param1.lordOfWarTeamId = param2.readUnsignedInt();
         var _loc15_:uint = uint(param2.readUnsignedInt());
         var _loc16_:int = 0;
         while(_loc16_ < 5)
         {
            param1.decorateList[_loc16_] = new PeopleItemInfo(param2.readUnsignedInt(),0);
            _loc16_++;
         }
         param2.readUnsignedInt();
      }
      
      public static function setForLoginInfo(param1:UserInfo, param2:IDataInput) : void
      {
         var _loc9_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:uint = 0;
         var _loc23_:uint = 0;
         var _loc24_:int = 0;
         var _loc25_:uint = 0;
         var _loc26_:uint = 0;
         var _loc27_:uint = 0;
         var _loc28_:Boolean = false;
         var _loc29_:uint = 0;
         var _loc30_:uint = 0;
         param1.hasSimpleInfo = true;
         param1.userID = param2.readUnsignedInt();
         param1.regTime = param2.readUnsignedInt();
         param1.nick = param2.readUTFBytes(16);
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            param1.decorateList[_loc3_] = new PeopleItemInfo(param2.readUnsignedInt(),0);
            _loc3_++;
         }
         param2.readUnsignedInt();
         param2.readUnsignedInt();
         var _loc4_:uint = uint(param2.readUnsignedInt());
         param1.coins = param2.readUnsignedInt();
         var _loc5_:uint = uint(param2.readUnsignedInt());
         param1.vip = BitUtil.getBit(_loc5_,0);
         param1.viped = BitUtil.getBit(_loc5_,1);
         var _loc6_:uint = uint(param2.readUnsignedByte());
         param1.isExtremeNono = Boolean(BitUtil.getBit(_loc6_,1));
         if(!param1.isVip)
         {
            param1.isExtremeNono = false;
         }
         param1.cuteType = param2.readUnsignedByte();
         param1.dsFlag = param2.readUnsignedInt();
         param1.color = param2.readUnsignedInt();
         param1.texture = param2.readUnsignedInt();
         param1.energy = param2.readUnsignedInt();
         param1.fireBuff = param2.readUnsignedByte();
         param1.jobTitle = param2.readUnsignedInt();
         param1.isActive = Boolean(param2.readUnsignedInt());
         param1.oldSeerInvateCount = param2.readUnsignedInt();
         param1.blanketInvateCount = param2.readUnsignedInt();
         param1.toDayGetGiftCount = param2.readUnsignedInt();
         param1.totalGiftCount = param2.readUnsignedInt();
         param1.getGiftDate = param2.readUnsignedInt();
         param1.getGiftTime = param2.readUnsignedInt();
         param1.fightBadge = param2.readUnsignedInt();
         param1.fightBadge1 = param2.readUnsignedInt();
         param1.fightPkBadge = param2.readUnsignedInt();
         param1.fightRoyale = param2.readUnsignedInt();
         param1.mapID = param2.readUnsignedInt();
         param1.pos = new Point(param2.readUnsignedInt(),param2.readUnsignedInt());
         param1.timeToday = param2.readUnsignedInt();
         param1.lastLoginTime = param2.readUnsignedInt();
         param1.timeLimit = param2.readUnsignedInt();
         param1.logintimeThisTime = param2.readUnsignedInt();
         MainManager.isClothHalfDay = Boolean(param2.readByte());
         MainManager.isRoomHalfDay = Boolean(param2.readByte());
         MainManager.iFortressHalfDay = Boolean(param2.readByte());
         MainManager.isHQHalfDay = Boolean(param2.readByte());
         DebugTrace.show("个人装扮是否半价：",MainManager.isClothHalfDay);
         DebugTrace.show("小屋装扮是否半价：",MainManager.isRoomHalfDay);
         DebugTrace.show("要塞装扮是否半价：",MainManager.iFortressHalfDay);
         DebugTrace.show("总部装扮是否半价：",MainManager.isHQHalfDay);
         param1.loginCnt = param2.readUnsignedInt();
         param1.inviter = param2.readUnsignedInt();
         param1.newInviteeCnt = param2.readUnsignedInt();
         param1.isFamous = Boolean(param2.readUnsignedInt());
         param1.vipTitle = param2.readUnsignedInt();
         param1.vipLevel = param2.readUnsignedInt();
         param1.vipValue = param2.readUnsignedInt();
         param1.vipStage = param2.readUnsignedInt();
         if(param1.vipStage > 4)
         {
            param1.vipStage = 4;
         }
         if(param1.vipStage == 0)
         {
            param1.vipStage = 1;
         }
         param1.autoCharge = param2.readUnsignedInt();
         param1.vipEndTime = param2.readUnsignedInt();
         param1.freshManBonus = param2.readUnsignedInt();
         var _loc7_:int = 0;
         while(_loc7_ < 80)
         {
            param1.nonoChipList.push(Boolean(param2.readByte()));
            _loc7_++;
         }
         var _loc8_:int = 0;
         while(_loc8_ < 300)
         {
            param1.dailyResArr.push(param2.readByte());
            _loc8_++;
         }
         _loc9_ = 0;
         while(_loc9_ < 7)
         {
            param1.summerHolidaysArr.push(param2.readByte());
            _loc9_++;
         }
         var _loc10_:int = 0;
         while(_loc10_ < 23)
         {
            param1.dailyTaskWeekHotArr.push(param2.readUnsignedByte());
            _loc10_++;
         }
         var _loc11_:int = 0;
         while(_loc11_ < 200)
         {
            _loc21_ = int(param2.readByte());
            _loc22_ = 0;
            while(_loc22_ < 8)
            {
               param1.bufferRecordArr.push(BitUtil.getBit(_loc21_,_loc22_));
               _loc22_++;
            }
            _loc11_++;
         }
         param1.teacherID = param2.readUnsignedInt();
         param1.studentID = param2.readUnsignedInt();
         param1.graduationCount = param2.readUnsignedInt();
         param1.isRecruitor = param2.readUnsignedInt() == 1 ? true : false;
         param1.maxPuniLv = param2.readUnsignedInt();
         param1.petMaxLev = param2.readUnsignedInt();
         param1.petAllNum = param2.readUnsignedInt();
         param1.totalAchieve = param2.readUnsignedInt();
         param1.curTitle = param2.readUnsignedInt();
         param1.achieRank = param2.readUnsignedInt();
         param1.monKingWin = param2.readUnsignedInt();
         param1.teamBoss = param2.readUnsignedInt();
         param1.curStage = param2.readUnsignedInt();
         param1.maxStage = param2.readUnsignedInt();
         param2.readUnsignedInt();
         param2.readUnsignedInt();
         param1.curFreshStage = 0;
         param1.maxFreshStage = 0;
         param1.curKingStage = param2.readUnsignedInt();
         param1.maxKingStage = param2.readUnsignedInt();
         param1.maxKingHeroStage = param2.readUnsignedInt();
         param1.maxLadderState = param2.readUnsignedInt();
         param1.maxFortuneState = param2.readUnsignedInt();
         param1.maxHigherState = param2.readUnsignedInt();
         param1.extremeLawLevel = param2.readUnsignedInt();
         param1.battleLabInfo = param2.readUnsignedInt();
         param1.zheguangWinTimes = param2.readUnsignedInt();
         param1.dreamMessWins = param2.readUnsignedInt();
         param1.maxArenaWins = param2.readUnsignedInt();
         param1.eFChampion = param2.readUnsignedInt();
         param1.twoTimes = param2.readUnsignedInt();
         param1.threeTimes = param2.readUnsignedInt();
         param1.dragonStatus = param2.readUnsignedByte();
         param1.autoFight = param2.readUnsignedInt();
         param1.autoFightTimes = param2.readUnsignedInt();
         param1.energyTimes = param2.readUnsignedInt();
         param1.learnTimes = param2.readUnsignedInt();
         param1.btlDetectTimes = param2.readUnsignedInt();
         param1.mobilizeTime = param2.readUnsignedInt();
         param1.monBtlMedal = param2.readUnsignedInt();
         param1.recordCnt = param2.readUnsignedInt();
         param1.obtainTm = param2.readUnsignedInt();
         param1.soulBeadItemID = param2.readUnsignedInt();
         param1.expireTm = param2.readUnsignedInt();
         param1.fuseTimes = param2.readUnsignedInt();
         param1.vipScore = param2.readUnsignedInt();
         var _loc12_:uint = uint(param2.readUnsignedInt());
         var _loc13_:Array = new Array();
         var _loc14_:int = 0;
         while(_loc14_ < _loc12_)
         {
            _loc13_.push(param2.readUnsignedInt());
            _loc14_++;
         }
         var _loc15_:uint = uint(_loc13_[0]);
         param1.openTiger = Boolean(BitUtil.getBit(_loc15_,0));
         param1.openDragon = Boolean(BitUtil.getBit(_loc15_,1));
         param1.openYanMo = Boolean(BitUtil.getBit(_loc15_,2));
         param1.openSaiBoSiTe = Boolean(BitUtil.getBit(_loc15_,3));
         param1.openGreenDragon = Boolean(BitUtil.getBit(_loc15_,4));
         param1.openJieensi = Boolean(BitUtil.getBit(_loc15_,5));
         param1.openBaenna = Boolean(BitUtil.getBit(_loc15_,6));
         param1.openShiZuLingShou = Boolean(BitUtil.getBit(_loc15_,7));
         param1.openTuoLuKe = Boolean(BitUtil.getBit(_loc15_,8));
         param1.openJixieTacoLyn = Boolean(BitUtil.getBit(_loc15_,9));
         param1.openBasite = Boolean(BitUtil.getBit(_loc15_,10));
         param1.openTaiGuLa = Boolean(BitUtil.getBit(_loc15_,11));
         param1.openBaihu = Boolean(BitUtil.getBit(_loc15_,12));
         param1.openSitanli = Boolean(BitUtil.getBit(_loc15_,14));
         param1.openRuidehaosi = Boolean(BitUtil.getBit(_loc15_,27));
         param1.openDierke = Boolean(BitUtil.getBit(_loc15_,19));
         param1.openWhiteHorse = Boolean(BitUtil.getBit(_loc15_,28));
         param1.openKubeisa = Boolean(BitUtil.getBit(_loc15_,29));
         param1.openBaKeDi = Boolean(BitUtil.getBit(_loc15_,24));
         param1.openSiweila = Boolean(BitUtil.getBit(_loc15_,30));
         param1.openPailabi = Boolean(BitUtil.getBit(_loc15_,31));
         _loc15_ = uint(_loc13_[1]);
         param1.openKaimila = Boolean(BitUtil.getBit(_loc15_,0));
         param1.openKuangyeheiniao = Boolean(BitUtil.getBit(_loc15_,1));
         param1.openQilin = Boolean(BitUtil.getBit(_loc15_,2));
         param1.openNaKaLuoHa = Boolean(BitUtil.getBit(_loc15_,3));
         param1.openGeErBoKe = Boolean(BitUtil.getBit(_loc15_,4));
         param1.openELingShou = Boolean(BitUtil.getBit(_loc15_,5));
         param1.openGhostTiger = Boolean(BitUtil.getBit(_loc15_,6));
         param1.openMegatronTiger = Boolean(BitUtil.getBit(_loc15_,7));
         param1.openPeiluomu = Boolean(BitUtil.getBit(_loc15_,8));
         param1.openYinLeiTianLong = Boolean(BitUtil.getBit(_loc15_,9));
         param1.openHanDiJuLong = Boolean(BitUtil.getBit(_loc15_,10));
         param1.openYikongzhanqi = Boolean(BitUtil.getBit(_loc15_,11));
         param1.mountId = param2.readUnsignedInt();
         param1.blackCrystalPos = param2.readUnsignedInt();
         param1.luogeTeamId = param2.readUnsignedInt();
         param1.crackCupTeamId = param2.readUnsignedInt();
         param1.monthLoginDay = param2.readUnsignedInt();
         param1.isBeaten = param2.readUnsignedInt();
         param1.isBeaten_1 = param2.readUnsignedInt();
         param1.hasNono = Boolean(param2.readUnsignedInt());
         param1.superNono = Boolean(param2.readUnsignedInt());
         var _loc16_:uint = uint(param2.readUnsignedInt());
         var _loc17_:int = 0;
         while(_loc17_ < 32)
         {
            param1.nonoState.push(BitUtil.getBit(_loc16_,_loc17_));
            _loc17_++;
         }
         param1.nonoColor = param2.readUnsignedInt();
         param1.nonoNick = param2.readUTFBytes(16);
         param1.nonoChangeToPet = param2.readUnsignedInt();
         param1.teamInfo = new TeamInfo(param2);
         param1.teamPKInfo = new TeamPKInfo(param2);
         param1.redball = param2.readUnsignedInt();
         param1.blueball = param2.readUnsignedInt();
         param1.yellowball = param2.readUnsignedInt();
         var _loc18_:ByteArray = new ByteArray();
         param2.readBytes(_loc18_,0,20);
         param1.reserved = _loc18_;
         TasksManager.taskList = [];
         _loc9_ = 0;
         while(_loc9_ < 1000)
         {
            _loc23_ = uint(param2.readUnsignedByte());
            _loc24_ = 0;
            while(_loc24_ < 4)
            {
               _loc25_ = uint(_loc24_ * 2 + 1);
               _loc26_ = _loc25_ - 1;
               _loc27_ = uint(BitUtil.getBit(_loc23_,_loc26_));
               _loc28_ = Boolean(BitUtil.getBit(_loc23_,_loc25_));
               if(_loc28_)
               {
                  TasksManager.taskList.push(TasksManager.COMPLETE);
               }
               else
               {
                  TasksManager.taskList.push(_loc27_);
               }
               _loc24_++;
            }
            _loc9_++;
         }
         param1.isCanBeTeacher = TasksManager.getTaskStatus(201) == 3;
         param1.petNum = param2.readUnsignedInt();
         PetManager.initData(param2,param1.petNum);
         PetManager.initData(param2,param2.readUnsignedInt(),true);
         var _loc19_:uint = uint(param2.readUnsignedInt());
         param1.clothes.splice(0);
         var _loc20_:uint = 0;
         while(_loc20_ < _loc19_)
         {
            _loc29_ = uint(param2.readUnsignedInt());
            _loc30_ = uint(param2.readUnsignedInt());
            param1.clothes.push(new PeopleItemInfo(_loc29_,_loc30_));
            _loc20_++;
         }
         param1.topStatus = param2.readUnsignedInt();
         param1.topStatus2 = param2.readUnsignedInt();
         param1.topStatus3 = param2.readUnsignedInt();
         param1.topStatus4 = param2.readUnsignedInt();
         param1.topStatus5 = param2.readUnsignedInt();
         param1.topStatus6 = param2.readUnsignedInt();
         param1.topStatus7 = param2.readUnsignedInt();
         param1.topStatus8 = param2.readUnsignedInt();
         param1.topStatus9 = param2.readUnsignedInt();
         param1.topStatus10 = param2.readUnsignedInt();
         param1.topStatus11 = param2.readUnsignedInt();
         param1.aresUnionTeam = param2.readUnsignedInt();
         param1.luoboteStatus = param2.readUnsignedInt();
         param1.aiErFuAndMiYouLaStatus = param2.readUnsignedInt();
         param1.usersCamp = param2.readUnsignedInt();
         param1.tangyuan = param2.readUnsignedInt();
         param1.foolsdayMask = param2.readUnsignedInt();
         param1.tigerFightTeam = param2.readUnsignedInt();
         param1.tigerFightScore = param2.readUnsignedInt();
         param1.lordOfWarTeamId = param2.readUnsignedInt();
      }
      
      public static function setForSimpleInfo(param1:UserInfo, param2:IDataInput) : void
      {
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         param1.hasSimpleInfo = true;
         ByteArray(param2).position = 0;
         param1.userID = param2.readUnsignedInt();
         param1.nick = param2.readUTFBytes(16);
         param1.color = param2.readUnsignedInt();
         param1.texture = param2.readUnsignedInt();
         param1.vip = param2.readUnsignedInt();
         var _loc3_:uint = uint(param2.readUnsignedByte());
         param1.isExtremeNono = Boolean(BitUtil.getBit(_loc3_,1));
         if(!param1.isVip)
         {
            param1.isExtremeNono = false;
         }
         param1.status = param2.readUnsignedInt();
         param1.mapType = param2.readUnsignedInt();
         param1.mapID = param2.readUnsignedInt();
         param1.isCanBeTeacher = param2.readUnsignedInt() == 1;
         param1.teacherID = param2.readUnsignedInt();
         param1.studentID = param2.readUnsignedInt();
         param1.graduationCount = param2.readUnsignedInt();
         param1.vipLevel = param2.readUnsignedInt();
         var _loc4_:TeamInfo = new TeamInfo();
         _loc4_.id = param2.readUnsignedInt();
         _loc4_.isShow = Boolean(param2.readUnsignedInt());
         param1.teamInfo = _loc4_;
         param1.teamID = _loc4_.id;
         var _loc5_:uint = uint(param2.readUnsignedInt());
         param1.clothes.splice(0);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = uint(param2.readUnsignedInt());
            _loc8_ = uint(param2.readUnsignedInt());
            param1.clothes.push(new PeopleItemInfo(_loc7_,_loc8_));
            _loc6_++;
         }
         param1.fightArenaPoint = param2.readUnsignedInt();
         param1.fireBuff = param2.readUnsignedByte();
         param1.loginTime = param2.readUnsignedInt();
         param1.lastOfflineTime = param2.readUnsignedInt();
         param1.isFriend = Boolean(param2.readUnsignedByte());
         param1.isBlack = Boolean(param2.readUnsignedByte());
         param2.readUnsignedInt();
         param2.readUnsignedInt();
         param2.readUnsignedInt();
         if(param2.bytesAvailable > 0)
         {
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
               param1.decorateList[_loc6_] = new PeopleItemInfo(param2.readUnsignedInt(),0);
               _loc6_++;
            }
         }
      }
      
      public static function setForMoreInfo(param1:UserInfo, param2:IDataInput) : void
      {
         param1.hasMoreInfo = true;
         param1.userID = param2.readUnsignedInt();
         param1.nick = param2.readUTFBytes(16);
         param1.regTime = param2.readUnsignedInt();
         var _loc3_:uint = uint(param2.readUnsignedByte());
         param1.isExtremeNono = Boolean(BitUtil.getBit(_loc3_,1));
         if(!param1.isVip)
         {
            param1.isExtremeNono = false;
         }
         param1.petAllNum = param2.readUnsignedInt();
         param1.petMaxLev = param2.readUnsignedInt();
         param1.totalClassWins = param2.readUnsignedInt();
         param1.totalAchieve = param2.readUnsignedInt();
         param1.achieShine = param2.readUnsignedInt();
         param1.achieRank = param2.readUnsignedInt();
         param1.curTitle = param2.readUnsignedInt();
         var _loc4_:int = 0;
         while(_loc4_ < 199)
         {
            param1.bossAchievement.push(Boolean(param2.readByte()));
            _loc4_++;
         }
         param1.graduationCount = param2.readUnsignedInt();
         param1.monKingWin = param2.readUnsignedInt();
         param1.teamBoss = param2.readUnsignedInt();
         param1.messWin = param2.readUnsignedInt();
         param1.luckyFightWin = param2.readUnsignedInt();
         param1.fightArenaWin = param2.readUnsignedInt();
         param1.royaleWin = param2.readUnsignedInt();
         param1.darkFightWin = param2.readUnsignedInt();
         param1.maxFreshStage = param2.readUnsignedInt();
         param1.maxStage = param2.readUnsignedInt();
         param1.maxKingStage = param2.readUnsignedInt();
         param1.maxKingHeroStage = param2.readUnsignedInt();
         param1.maxLadderState = param2.readUnsignedInt();
         param1.maxFortuneState = param2.readUnsignedInt();
         param1.maxArenaWins = param2.readUnsignedInt();
         param1.deltaTopHonour = param2.readUnsignedInt();
         param1.curTopHonour = param2.readUnsignedInt();
         param1.deltaTopLv = param2.readUnsignedInt();
         param1.topWinCount = param2.readUnsignedInt();
         param1.topLossCount = param2.readUnsignedInt();
         param1.maxTopWinSucc = param2.readUnsignedInt();
         param1.curTopWinSucc = param2.readUnsignedInt();
         param1.top_Two_Lvl = param2.readUnsignedInt();
         param1.top_Two_Win = param2.readUnsignedInt();
         param1.top_Two_Lose = param2.readUnsignedInt();
         param1.top_Two_Max_Win = param2.readUnsignedInt();
         param1.top_Two_Sur_Win = param2.readUnsignedInt();
         param1.top_Tree_Lvl = param2.readUnsignedInt();
         param1.top_Tree_Win = param2.readUnsignedInt();
         param1.top_Tree_Lose = param2.readUnsignedInt();
         param1.top_Tree_Max_Win = param2.readUnsignedInt();
         param1.top_Tree_Sur_Win = param2.readUnsignedInt();
         param1.top_Four_Lvl = param2.readUnsignedInt();
         param1.top_Four_Win = param2.readUnsignedInt();
         param1.top_Four_Lose = param2.readUnsignedInt();
         param1.top_Four_Max_Win = param2.readUnsignedInt();
         param1.top_Four_Sur_Win = param2.readUnsignedInt();
         param1.top_Five_Lvl = param2.readUnsignedInt();
         param1.top_Five_Win = param2.readUnsignedInt();
         param1.top_Five_Lose = param2.readUnsignedInt();
         param1.top_Five_Max_Win = param2.readUnsignedInt();
         param1.top_Five_Sur_Win = param2.readUnsignedInt();
         param1.top_Six_Lvl = param2.readUnsignedInt();
         param1.top_Six_Win = param2.readUnsignedInt();
         param1.top_Six_Lose = param2.readUnsignedInt();
         param1.top_Six_Max_Win = param2.readUnsignedInt();
         param1.top_Six_Sur_Win = param2.readUnsignedInt();
         param1.top_Seven_Lvl = param2.readUnsignedInt();
         param1.top_Seven_Win = param2.readUnsignedInt();
         param1.top_Seven_Lose = param2.readUnsignedInt();
         param1.top_Seven_Max_Win = param2.readUnsignedInt();
         param1.top_Seven_Sur_Win = param2.readUnsignedInt();
         param1.top_Eight_Lvl = param2.readUnsignedInt();
         param1.top_Eight_Win = param2.readUnsignedInt();
         param1.top_Eight_Lose = param2.readUnsignedInt();
         param1.top_Eight_Max_Win = param2.readUnsignedInt();
         param1.top_Eight_Sur_Win = param2.readUnsignedInt();
         param1.top_Nine_Lvl = param2.readUnsignedInt();
         param1.top_Nine_Win = param2.readUnsignedInt();
         param1.top_Nine_Lose = param2.readUnsignedInt();
         param1.top_Nine_Max_Win = param2.readUnsignedInt();
         param1.top_Nine_Sur_Win = param2.readUnsignedInt();
         param1.top_Ten_Lvl = param2.readUnsignedInt();
         param1.top_Ten_Win = param2.readUnsignedInt();
         param1.top_Ten_Lose = param2.readUnsignedInt();
         param1.top_Ten_Max_Win = param2.readUnsignedInt();
         param1.top_Ten_Sur_Win = param2.readUnsignedInt();
         param1.top_ELEVEN_Lvl = param2.readUnsignedInt();
         param1.top_ELEVEN_Win = param2.readUnsignedInt();
         param1.top_ELEVEN_Lose = param2.readUnsignedInt();
         param1.top_ELEVEN_Max_Win = param2.readUnsignedInt();
         param1.top_ELEVEN_Sur_Win = param2.readUnsignedInt();
         param1.top_TWELVE_Lvl = param2.readUnsignedInt();
         param1.top_TWELVE_Win = param2.readUnsignedInt();
         param1.top_TWELVE_Lose = param2.readUnsignedInt();
         param1.top_TWELVE_Max_Win = param2.readUnsignedInt();
         param1.top_TWELVE_Sur_Win = param2.readUnsignedInt();
         param1.highFightWin = param2.readShort();
         param2.readUnsignedInt();
         param2.readUnsignedInt();
         param2.readUnsignedInt();
         param1.trainerDoor_num = param2.readUnsignedInt();
         param1.carnival_total_score = param2.readUnsignedInt();
         param1.hurdles_win_num = param2.readUnsignedInt();
         param1.hurdles_lose_num = param2.readUnsignedInt();
         param1.tug_win_num = param2.readUnsignedInt();
         param1.tug_lose_num = param2.readUnsignedInt();
         param1.tug_draw_num = param2.readUnsignedInt();
         param1.jump_num = param2.readUnsignedInt();
         param2.readUnsignedInt();
         param2.readUnsignedInt();
         param2.readUnsignedInt();
         param1.maxSpaceArenaWins = param2.readUnsignedInt();
         param1.extremeLawLevel = param2.readUnsignedInt();
         param1.battleLabInfo = param2.readUnsignedInt();
         param1.zheguangWinTimes = param2.readUnsignedInt();
         param1.dreamMessWins = param2.readUnsignedInt();
         param1.aresUnionTeam = param2.readUnsignedInt();
      }
      
      public function get formatNick() : String
      {
         return "0xff0000" + StringUtil.replace(this.nick,"#","＃") + "0xffffff";
      }
      
      public function get clothIDs() : Array
      {
         var _loc2_:PeopleItemInfo = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.clothes)
         {
            _loc1_.push(_loc2_.id);
         }
         return _loc1_;
      }
      
      public function getDecorateIdList() : Array
      {
         var _loc2_:PeopleItemInfo = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.decorateList)
         {
            _loc1_.push(_loc2_.id);
         }
         return _loc1_;
      }
      
      public function updateDecorate(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            this.decorateList[_loc2_] = new PeopleItemInfo(param1[_loc2_],0);
            _loc2_++;
         }
      }
      
      public function isDecorate() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < this.decorateList.length)
         {
            if(this.decorateList[_loc2_].id != 0 && this.decorateList[_loc2_].id != 1)
            {
               _loc1_ = true;
               break;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getShowCloths(param1:Boolean = false) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Array = ["HEAD","EYE","HAND","WAIST","FOOT"];
         var _loc3_:Array = [100001,1,1,100002,100003];
         if(param1)
         {
            _loc4_ = [];
            _loc5_ = 0;
            while(_loc5_ < this.decorateList.length)
            {
               if(this.decorateList[_loc5_].id != 0)
               {
                  if(this.decorateList[_loc5_].id != 1)
                  {
                     _loc4_.push(this.decorateList[_loc5_]);
                  }
               }
               else
               {
                  _loc6_ = _loc2_[_loc5_];
                  _loc7_ = 0;
                  while(_loc7_ < this.clothes.length)
                  {
                     _loc8_ = int(this.clothes[_loc7_].id);
                     if(ClothXMLInfo.getItemInfo(_loc8_).type.toUpperCase() == _loc6_)
                     {
                        _loc4_.push(this.clothes[_loc7_]);
                        break;
                     }
                     _loc7_++;
                  }
               }
               _loc5_++;
            }
            return _loc4_;
         }
         return this.clothes;
      }
      
      public function get clothMaxLevel() : uint
      {
         var _loc2_:PeopleItemInfo = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this.clothes)
         {
            _loc1_ = Math.max(_loc1_,_loc2_.level);
         }
         return _loc1_;
      }
      
      public function get vipScoreMax() : uint
      {
         var _loc1_:uint = 0;
         if(this.vipLevel == 1)
         {
            _loc1_ = 20;
         }
         else if(this.vipLevel == 2)
         {
            _loc1_ = 24;
         }
         else if(this.vipLevel == 3)
         {
            _loc1_ = 28;
         }
         else if(this.vipLevel == 4)
         {
            _loc1_ = 32;
         }
         else if(this.vipLevel == 5)
         {
            _loc1_ = 36;
         }
         return _loc1_;
      }
      
      public function get vipValueMax() : uint
      {
         var _loc1_:uint = 0;
         if(this.vipLevel == 1)
         {
            _loc1_ = 450;
         }
         else if(this.vipLevel == 2)
         {
            _loc1_ = 1900;
         }
         else if(this.vipLevel == 3)
         {
            _loc1_ = 6600;
         }
         else if(this.vipLevel == 4 || this.vipLevel == 5)
         {
            _loc1_ = 19800;
         }
         return _loc1_;
      }
      
      public function get isVip() : Boolean
      {
         if(this.vip == 1 || this.vip == 3)
         {
            return true;
         }
         return false;
      }
      
      public function get isRegToday() : Boolean
      {
         var _loc1_:Date = new Date(this.regTime * 1000);
         if(_loc1_.fullYear == SystemTimerManager.sysBJDate.fullYear && _loc1_.month == SystemTimerManager.sysBJDate.month && _loc1_.date == SystemTimerManager.sysBJDate.date)
         {
            return true;
         }
         return false;
      }
      
      public function get oldlast() : uint
      {
         return this.lastLoginTime;
      }
      
      public function get onlineTime() : int
      {
         return MainManager.actorInfo.timeToday + SystemTimerManager.time - this.loginTime;
      }
      
      public function get coins() : uint
      {
         return this._coins;
      }
      
      public function set coins(param1:uint) : void
      {
         EventManager.dispatchEvent(new DynamicEvent(RobotEvent.SEERDOU_CHANGE_EVENT,param1 - this._coins));
         this._coins = param1;
      }
   }
}

