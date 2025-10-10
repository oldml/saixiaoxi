import asyncio
from .core.crypto.algorithms import Algorithms
from .core.auth.login import Login
from .network.packet.send import SendPacketProcessing
from .network.packet.receive import ReceivePacketAnalysis

class Main:
    def __init__(self):
        self.algorithms = Algorithms()
        self.login = Login(self.algorithms)
        self.reader = None
        self.writer = None
        self.send_packet_processing = None
        self.receive_packet_analysis = None
        self.receive_task = None

    async def initialize(self, userid, password, message_callback=None, disconnect_callback=None):
        # 从配置中获取服务器设置
        self.reader, self.writer = await self.login.login(userid, password)
        self.receive_packet_analysis = ReceivePacketAnalysis(self.algorithms, self.reader, self.writer, userid, message_callback, disconnect_callback)
        self.send_packet_processing = SendPacketProcessing(self.algorithms, self.writer, userid, message_callback)

    def start_receive_task(self):
        self.receive_task = asyncio.create_task(self.receive_packet_analysis.receive_data())
        return self.receive_task

    async def run(self, userid, password):
        await self.initialize(userid, password)
        return self.start_receive_task()

    async def close(self):
        if self.writer:
            self.writer.close()
            await self.writer.wait_closed()
        if self.receive_task and not self.receive_task.done():
            self.receive_task.cancel()
            try:
                await self.receive_task
            except asyncio.CancelledError:
                pass
