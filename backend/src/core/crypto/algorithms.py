import hashlib

class Algorithms:
    def __init__(self):
        self.key = b'!crAckmE4nOthIng:-)'
        self.result = 0

    def encrypt(self, plain: bytes) -> bytes:
        cipher_len = len(plain) + 1
        plain = plain[4:]
        cipher = bytearray(len(plain) + 1)

        j = 0
        need_become_zero = False
        for i in range(len(plain)):
            if j == 1 and need_become_zero:
                j = 0
                need_become_zero = False
            if j == len(self.key):
                j = 0
                need_become_zero = True
            cipher[i] = plain[i] ^ self.key[j]
            j += 1
        cipher[-1] = 0

        for i in range(len(cipher) - 1, 0, -1):
            cipher[i] = ((cipher[i] << 5) & 0xFF) | (cipher[i - 1] >> 3)
        cipher[0] = ((cipher[0] << 5) & 0xFF) | 3
        result = self.key[len(plain) % len(self.key)] * 13 % len(cipher)
        cipher = cipher[result:len(cipher)] + cipher[0:result]
        return cipher_len.to_bytes(length = 4, byteorder = 'big') + bytes(cipher)

    def decrypt(self, cipher: bytes) -> bytes:
        plain_len = len(cipher) - 1
        cipher = cipher[4:]
        result = self.key[(len(cipher) - 1) % len(self.key)] * 13 % len(cipher)
        cipher = cipher[len(cipher) - result:len(cipher)] + cipher[0:len(cipher) - result]
        plain = bytearray(len(cipher) - 1)

        for i in range(len(cipher) - 1):
            plain[i] = ((cipher[i] >> 5) & 0xFF) | ((cipher[i + 1] << 3) & 0xFF)
        j = 0
        need_become_zero = False
        for i in range(len(plain)):
            if j == 1 and need_become_zero:
                j = 0
                need_become_zero = False
            if j == len(self.key):
                j = 0
                need_become_zero = True
            plain[i] = plain[i] ^ self.key[j]
            j += 1
        return plain_len.to_bytes(length = 4, byteorder = 'big') + bytes(plain)

    def InitKey(self, packet_data: bytes, userid: int):
        last_four_bytes = packet_data[-4:]
        last_uint = int.from_bytes(last_four_bytes, byteorder = 'big')
        xor_result = last_uint ^ userid
        xor_str = str(xor_result)
        md5_hash = hashlib.md5(xor_str.encode()).hexdigest()
        new_key = md5_hash[:10]
        self.key = new_key.encode('utf-8')
        print("Updated encryption key to:", self.key)

    def MSerial(self, a, b, c, d):
        return a + c + int(a / -3) + (b % 17) + (d % 23) + 120

    def calculate_result(self, cmdId, body):
        crc8_val = 0
        if cmdId > 1000:
            for byte in body:
                crc8_val ^= byte
        new_result = self.MSerial(self.result, len(body), crc8_val, cmdId)
        self.result = new_result
        # print("Updated result to:", new_result)
        return new_result
