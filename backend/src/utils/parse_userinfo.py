#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
解析赛尔号UserInfo数据
根据UserInfo.as中的setForSimpleInfo和setForMoreInfo方法解析对应的二进制数据
"""

import struct
from typing import Dict, Any, List, BinaryIO


def read_uint(data: BinaryIO) -> int:
    """读取无符号32位整数（big-endian）"""
    return struct.unpack('>I', data.read(4))[0]


def read_ushort(data: BinaryIO) -> int:
    """读取无符号16位整数（big-endian）"""
    return struct.unpack('>H', data.read(2))[0]


def read_ubyte(data: BinaryIO) -> int:
    """读取无符号8位整数"""
    return struct.unpack('B', data.read(1))[0]


def read_byte(data: BinaryIO) -> int:
    """读取有符号8位整数"""
    return struct.unpack('b', data.read(1))[0]


def read_utf_bytes(data: BinaryIO, length: int) -> str:
    """读取UTF-8编码的字符串"""
    raw_bytes = data.read(length)
    # 去除末尾的空字节
    return raw_bytes.rstrip(b'\x00').decode('utf-8', errors='ignore')


def get_bit(value: int, position: int) -> int:
    """获取指定位的值"""
    return (value >> position) & 1


class UserInfoParser:
    """UserInfo解析器"""

    def __init__(self):
        self.simple_info = {}
        self.more_info = {}
        self.merged_info = {}

    def parse_simple_info(self, hex_data: str) -> Dict[str, Any]:
        """
        解析setForSimpleInfo数据
        对应UserInfo.as的setForSimpleInfo方法（第1040-1099行）
        """
        # 将十六进制字符串转换为字节数组
        binary_data = bytes.fromhex(hex_data.strip())

        from io import BytesIO
        data = BytesIO(binary_data)

        info = {}

        # 基本信息
        info['userID'] = read_uint(data)
        info['nick'] = read_utf_bytes(data, 16)
        info['color'] = read_uint(data)
        info['texture'] = read_uint(data)
        info['vip'] = read_uint(data)

        # 极品NoNo标志
        extreme_byte = read_ubyte(data)
        info['isExtremeNono'] = bool(get_bit(extreme_byte, 1))

        # 状态和地图信息
        info['status'] = read_uint(data)
        info['mapType'] = read_uint(data)
        info['mapID'] = read_uint(data)

        # 导师系统
        info['isCanBeTeacher'] = read_uint(data) == 1
        info['teacherID'] = read_uint(data)
        info['studentID'] = read_uint(data)
        info['graduationCount'] = read_uint(data)
        info['vipLevel'] = read_uint(data)

        # 战队信息
        team_info = {}
        team_info['id'] = read_uint(data)
        team_info['isShow'] = bool(read_uint(data))
        info['teamInfo'] = team_info
        info['teamID'] = team_info['id']

        # 装扮列表
        clothes_count = read_uint(data)
        clothes = []
        for _ in range(clothes_count):
            cloth_id = read_uint(data)
            cloth_level = read_uint(data)
            clothes.append({'id': cloth_id, 'level': cloth_level})
        info['clothes'] = clothes

        # 战斗信息
        info['fightArenaPoint'] = read_uint(data)
        info['fireBuff'] = read_ubyte(data)

        # 时间信息
        info['loginTime'] = read_uint(data)
        info['lastOfflineTime'] = read_uint(data)

        # 好友信息
        info['isFriend'] = bool(read_ubyte(data))
        info['isBlack'] = bool(read_ubyte(data))

        # 跳过3个uint
        read_uint(data)
        read_uint(data)
        read_uint(data)

        # 装饰列表（如果还有数据）
        decorateList = []
        if data.tell() < len(binary_data):
            for _ in range(5):
                if data.tell() < len(binary_data):
                    decorate_id = read_uint(data)
                    decorateList.append({'id': decorate_id, 'level': 0})
        info['decorateList'] = decorateList

        self.simple_info = info
        return info

    def parse_more_info(self, hex_data: str) -> Dict[str, Any]:
        """
        解析setForMoreInfo数据
        对应UserInfo.as的setForMoreInfo方法（第1101-1224行）
        """
        # 将十六进制字符串转换为字节数组
        binary_data = bytes.fromhex(hex_data.strip())

        from io import BytesIO
        data = BytesIO(binary_data)

        info = {}

        # 基本信息
        info['userID'] = read_uint(data)
        info['nick'] = read_utf_bytes(data, 16)
        info['regTime'] = read_uint(data)

        # 极品NoNo标志
        extreme_byte = read_ubyte(data)
        info['isExtremeNono'] = bool(get_bit(extreme_byte, 1))

        # 精灵信息
        info['petAllNum'] = read_uint(data)
        info['petMaxLev'] = read_uint(data)
        info['totalClassWins'] = read_uint(data)

        # 成就系统
        info['totalAchieve'] = read_uint(data)
        info['achieShine'] = read_uint(data)
        info['achieRank'] = read_uint(data)
        info['curTitle'] = read_uint(data)

        # Boss成就列表（199个）
        boss_achievement = []
        for _ in range(199):
            boss_achievement.append(bool(read_byte(data)))
        info['bossAchievement'] = boss_achievement

        # 战斗统计
        info['graduationCount'] = read_uint(data)
        info['monKingWin'] = read_uint(data)
        info['teamBoss'] = read_uint(data)
        info['messWin'] = read_uint(data)
        info['luckyFightWin'] = read_uint(data)
        info['fightArenaWin'] = read_uint(data)
        info['royaleWin'] = read_uint(data)
        info['darkFightWin'] = read_uint(data)

        # 关卡进度
        info['maxFreshStage'] = read_uint(data)
        info['maxStage'] = read_uint(data)
        info['maxKingStage'] = read_uint(data)
        info['maxKingHeroStage'] = read_uint(data)
        info['maxLadderState'] = read_uint(data)
        info['maxFortuneState'] = read_uint(data)
        info['maxArenaWins'] = read_uint(data)

        # 巅峰战斗统计
        info['deltaTopHonour'] = read_uint(data)
        info['curTopHonour'] = read_uint(data)
        info['deltaTopLv'] = read_uint(data)
        info['topWinCount'] = read_uint(data)
        info['topLossCount'] = read_uint(data)
        info['maxTopWinSucc'] = read_uint(data)
        info['curTopWinSucc'] = read_uint(data)

        # 各级别巅峰战斗统计（Two到TWELVE，共11个级别）
        top_tiers = ['Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'ELEVEN', 'TWELVE']
        for tier in top_tiers:
            info[f'top_{tier}_Lvl'] = read_uint(data)
            info[f'top_{tier}_Win'] = read_uint(data)
            info[f'top_{tier}_Lose'] = read_uint(data)
            info[f'top_{tier}_Max_Win'] = read_uint(data)
            info[f'top_{tier}_Sur_Win'] = read_uint(data)

        # 高级战斗
        info['highFightWin'] = read_ushort(data)

        # 跳过3个uint
        read_uint(data)
        read_uint(data)
        read_uint(data)

        # 训练营和嘉年华统计
        info['trainerDoor_num'] = read_uint(data)
        info['carnival_total_score'] = read_uint(data)
        info['hurdles_win_num'] = read_uint(data)
        info['hurdles_lose_num'] = read_uint(data)
        info['tug_win_num'] = read_uint(data)
        info['tug_lose_num'] = read_uint(data)
        info['tug_draw_num'] = read_uint(data)
        info['jump_num'] = read_uint(data)

        # 跳过3个uint
        read_uint(data)
        read_uint(data)
        read_uint(data)

        # 最终统计
        info['maxSpaceArenaWins'] = read_uint(data)
        info['extremeLawLevel'] = read_uint(data)
        info['battleLabInfo'] = read_uint(data)
        info['zheguangWinTimes'] = read_uint(data)
        info['dreamMessWins'] = read_uint(data)
        info['aresUnionTeam'] = read_uint(data)

        self.more_info = info
        return info

    def merge_data(self) -> Dict[str, Any]:
        """合并simple_info和more_info数据"""
        # 以simple_info为基础
        merged = self.simple_info.copy()

        # 从more_info中添加或更新字段
        for key, value in self.more_info.items():
            if key not in merged:
                # 新字段直接添加
                merged[key] = value
            elif key in ['userID', 'nick', 'isExtremeNono', 'graduationCount']:
                # 这些字段应该相同，使用simple_info的值
                pass
            else:
                # 其他冲突字段，使用more_info的值（更详细）
                merged[key + '_more'] = value

        self.merged_info = merged
        return merged
