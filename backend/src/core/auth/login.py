import hashlib
import socket
import struct
import asyncio

from ..crypto.algorithms import Algorithms
from ...config import settings

class Login():
    def __init__(self, algorithms: Algorithms):
        self.algorithms = algorithms

    async def login(self, userid, password, server=32):
        double_md5_password = self.double_md5(password)
        recv_data = await self.login_verify(userid, double_md5_password)
        recv_body = recv_data[21:37]
        userid_bytes = recv_data[9:13]
        try:
            server_addr = (settings.game_server_host, settings.game_server_port)
            reader, writer = await asyncio.open_connection(server_addr[0], server_addr[1])

            login_packet = self.LOGIN_IN(userid_bytes, recv_body)
            writer.write(login_packet)
            await writer.drain()

            return reader, writer
        except KeyboardInterrupt:
            if 'writer' in locals() and writer:
                writer.close()
                await writer.wait_closed()
            print('断开连接')

    def get_server_addr(self):
        # url = r'http://seerlogin.61.com/ip.txt'
        # r = requests.get(url)
        return (settings.login_server_host, settings.login_server_port)

    async def send_login_packet(self, server_addr, send_data):
        print(server_addr)
        reader, writer = await asyncio.open_connection(server_addr[0], server_addr[1])
        try:
            writer.write(send_data)
            await writer.drain()
            recv_data = await reader.read(1024)
            return recv_data  # 返回封包体
        finally:
            writer.close()
            await writer.wait_closed()

    @staticmethod
    def double_md5(password: str) -> str:
        first_md5 = hashlib.md5(password.encode()).hexdigest()
        second_md5 = hashlib.md5(first_md5.encode()).hexdigest()
        return second_md5

    async def login_verify(self, userid, double_md5_password, verification_code_num = b'\x00' * 16, verification_code = b'\x00' * 4):
        packet = bytes.fromhex('000000933100000067000000000000000036373264363639376135353432643932623532623566316339326633313362640000000000000002000000000000000000000000000000000000000000000000000074616F6D656500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000')
        packet = packet[:9] + struct.pack('>I', userid) + packet[13:17] + double_md5_password.encode() + packet[49:61] + verification_code_num + verification_code + packet[81:]
        recv_data = await self.send_login_packet(self.get_server_addr(), packet)
        recv_packet_body = recv_data[17:]
        if recv_packet_body[3] == 0:
            print('登录成功')
        elif recv_packet_body[3] == 1:
            print('密码错误')
        elif recv_packet_body[3] == 2:
            print('验证码错误')
            with open(r'验证码.bmp', 'wb')as f:
                f.write(recv_packet_body[24:])
            _verification_code_num = recv_packet_body[4:4+16]
            _verification_code = input('请查看保存在代码运行目录下的验证码图片并输入验证码：').encode()
            if len(_verification_code) == 4:
                await self.login_verify(userid, double_md5_password, _verification_code_num, _verification_code)
        return recv_data

    def LOGIN_IN(self, userid_bytes, recv_body):
        recv_body = recv_body + bytearray.fromhex('74616F6D6565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000001000000010000000000000000000000000000000000000000000000000000000000000000')
        result = self.algorithms.calculate_result(1001, recv_body)
        packet_data = bytearray.fromhex('0000008D31000003E9') + userid_bytes + result.to_bytes(length = 4, byteorder = 'big') + recv_body
        cipher = self.algorithms.encrypt(packet_data)
        return cipher
