import asyncio
from ...core.crypto.algorithms import Algorithms

class SendPacketProcessing:
    def __init__(self, algorithms: Algorithms, writer: asyncio.StreamWriter, userid, message_callback=None):
        self.algorithms = algorithms
        self.writer = writer
        self.message_callback = message_callback
        self.length = None
        self.version = None
        self.cmd_id = None
        self.user_id = userid.to_bytes(length = 4, byteorder = 'big')
        self.result = None
        self.body = None

    def parse_packet(self, packet):
        if len(packet) >= 17:
            self.length = packet[0:4]
            self.version = packet[4]
            self.cmd_id = packet[5:9]
            # self.user_id = packet[9:13]
            # self.user_id = self.user_id
            self.result = packet[13:17]
            self.body = packet[17:]
            # print(f"Length: {int.from_bytes(self.length, byteorder = 'big')}")
            # print(f"Version: {self.version}")
            # print(f"CmdId: {int.from_bytes(self.cmd_id, byteorder = 'big')}")
            # print(f"UserId: {int.from_bytes(self.user_id, byteorder = 'big')}")
            # print(f"Result: {int.from_bytes(self.result, byteorder = 'big')}")
            # print(f"Body: {self.body.hex().upper()}")
        return self

    def GroupPacket(self, packet):
        try:
            bytes.fromhex(packet)
        except ValueError:
            if self.message_callback:
                self.message_callback("发送|错误|封包数据格式错误")
            return 0
        packet_bytes = bytes.fromhex(packet)
        self.parse_packet(packet_bytes)
        self.result = self.algorithms.calculate_result(int.from_bytes(self.cmd_id, byteorder = 'big'), self.body)
        return self.length + self.version.to_bytes(length = 1, byteorder = 'big') + self.cmd_id + self.user_id + self.result.to_bytes(length = 4, byteorder = 'big') + self.body

    async def SendPacket(self, packed_message):
        packed_message = self.GroupPacket(packed_message)
        if self.message_callback:
            self.message_callback(f'发送|未加密|{packed_message.hex().upper()}')
        message_encrypt = self.algorithms.encrypt(packed_message)
        if self.message_callback:
            self.message_callback(f'发送|加密后|{message_encrypt.hex().upper()}')
        self.writer.write(message_encrypt)
        await self.writer.drain()
