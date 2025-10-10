import json
import asyncio
from pathlib import Path

from ...core.crypto.algorithms import Algorithms
from ...config.settings import settings

class ReceivePacketAnalysis:
    def __init__(self, algorithms: Algorithms, reader: asyncio.StreamReader, writer: asyncio.StreamWriter, userid, message_callback=None, disconnect_callback=None):
        self.algorithms = algorithms
        self.reader = reader
        self.writer = writer
        self.userid = userid
        self.message_callback = message_callback
        self.disconnect_callback = disconnect_callback
        command_json_path = Path(__file__).parent.parent.parent / 'data' / 'commands.json'
        with open(command_json_path, 'r') as file:
            self.command_dict = json.load(file)
        self.currentCommandId = None
        self.packet_data = None
        self.data_ready_event = asyncio.Event()

    async def receive_data(self):
        buffer = b''
        while True:
            try:
                if not self.reader:
                    if self.message_callback:
                        self.message_callback("连接|错误|未连接到服务器")
                    break

                recv_data = await self.reader.read(settings.receive_buffer_size)
                if not recv_data:
                    if self.message_callback:
                        self.message_callback("连接|断开|服务器断开连接")
                    # 通知上层连接已断开
                    if self.disconnect_callback:
                        await self.disconnect_callback()
                    break

                buffer += recv_data
                while len(buffer) >= 4:
                    packet_length = int.from_bytes(buffer[:4], byteorder = 'big')
                    if len(buffer) < packet_length:
                        break

                    packet_data = buffer[:packet_length]
                    buffer = buffer[packet_length:]

                    packet_data = self.algorithms.decrypt(packet_data)
                    cipher = packet_data.hex().upper()
                    formatted_hex_string = ' '.join([cipher[i:i+2] for i in range(0, len(cipher), 2)])
                    command_value = int.from_bytes(packet_data[5:9], byteorder = 'big')
                    command_str = self.command_dict.get(str(command_value), 'Unknown Command')
                    if self.message_callback:
                        self.message_callback(f"接收|{command_str}|{formatted_hex_string}")

                    if command_value == self.currentCommandId:
                        # print(f"需要分析的封包: {formatted_hex_string}")
                        self.packet_data = packet_data
                        self.data_ready_event.set()

                    if command_value == 1001:
                        self.algorithms.InitKey(packet_data, self.userid)
                        if self.message_callback:
                            self.message_callback("初始化|成功|密钥初始化完成")
                        result = int.from_bytes(packet_data[13:17], byteorder = 'big')
                        self.algorithms.result = result
                        if self.message_callback:
                            self.message_callback(f"初始化|更新|Result: {result}")
                        continue

            except Exception as e:
                if self.message_callback:
                    self.message_callback(f"接收|错误|{str(e)}")
                # 异常时也通知上层连接已断开
                if self.disconnect_callback:
                    await self.disconnect_callback()
                break

    async def wait_for_specific_data(self, command_id, timeout = 5):
        self.currentCommandId = command_id
        self.data_ready_event.clear()
        try:
            await asyncio.wait_for(self.data_ready_event.wait(), timeout=timeout)
            data = self.packet_data
            self.packet_data = None
            self.currentCommandId = None
            return data
        except asyncio.TimeoutError:
            if self.message_callback:
                self.message_callback(f"等待|超时|命令 {command_id} 响应超时")
            return None